## QR Code Generation and Encryption Guide

### Overview

This document explains how QR data is produced for vehicle stickers, how it is encrypted, and how the UI renders the final QR image.

### What data is encoded?

- The raw input is the vehicle's unique identifier: `vehicle.vehicleID`.
- This value is encrypted and then Base64-URL encoded to form the final QR payload.

### Encryption scheme

- **Cipher**: AES-128 (block size 16 bytes) via `EnhancedAES128`.
- **Padding**: PKCS#7 to full 16-byte blocks.
- **Output encoding**: Base64 URL-safe (no `+` or `/`).
- **Key**: 16-byte fixed key for desktop and mobile to interoperate.

Keyed service used by the app:

```1:19:lib/core/services/cyrpto_service.dart
import 'dart:typed_data';
import 'dart:convert';
import 'package:cvms_desktop/core/crypto/enhanced_aes.dart';

class CryptoService {
  final EnhancedAES128 _aes;
  final void Function(String)? _logger;

  /// Creates a CryptoService with the given key and optional logger.
  CryptoService(Uint8List key, {void Function(String)? logger})
    : assert(key.length == 16, 'Key must be 16 bytes'),
      _aes = EnhancedAES128(key),
      _logger = logger;

  /// Default instance with a fixed key (must match mobile app).
  factory CryptoService.withDefaultKey({void Function(String)? logger}) {
    final key = Uint8List.fromList(utf8.encode('akoSiPogi123ert5'));
    return CryptoService(key, logger: logger);
  }
```

Encryption and decryption methods:

```21:41:lib/core/services/cyrpto_service.dart
  /// Encrypts a vehicle ID into a Base64 URL-safe string.
  /// Pads input to 16-byte blocks with PKCS#7 padding.
  String encryptVehicleId(String rawId) {
    final data = utf8.encode(rawId);
    final padded = _padData(data);
    final encryptedBlocks = Uint8List(padded.length);

    for (var i = 0; i < padded.length; i += 16) {
      final block = padded.sublist(i, i + 16);
      final cipherBlock = _aes.encryptBlock(block);
      encryptedBlocks.setRange(i, i + 16, cipherBlock);
    }

    final encoded = base64UrlEncode(encryptedBlocks);
    _logger?.call('[CryptoService] Encrypted Vehicle ID: $rawId -> $encoded');
    return encoded;
  }

  /// Decrypts a Base64 URL-safe QR payload into the raw vehicle ID.
  /// Expects PKCS#7 padded data.
  String decryptVehicleId(String encrypted) {
```

PKCS#7 helpers:

```66:74:lib/core/services/cyrpto_service.dart
  /// Applies PKCS#7 padding to make data length a multiple of 16 bytes.
  Uint8List _padData(List<int> data) {
    const blockSize = 16;
    final padLength = blockSize - (data.length % blockSize);
    final padded = Uint8List(data.length + padLength);
    padded.setRange(0, data.length, data);
    padded.fillRange(data.length, padded.length, padLength);
    return padded;
  }
```

### UI flow: where QR data is produced and displayed

1. In the QR dialog, the app takes `vehicle.vehicleID`, encrypts it, and holds the resulting string as `qrData`:

```34:43:lib/features/vehicle_management/widgets/dialogs/view_qr_code.dart
  @override
  Widget build(BuildContext context) {
    // -------encryption----------
    //  Use CryptoService instead of inline AES
    final rawVehicleId = widget.vehicle.vehicleID;
    final qrData = CryptoService.withDefaultKey().encryptVehicleId(
      rawVehicleId,
    );
    // -------end of encryption----------
```

2. The dialog passes `qrData` into the QR card widget which renders the QR code component:

```142:151:lib/features/vehicle_management/widgets/dialogs/view_qr_code.dart
    RepaintBoundary(
      key: _cardKey,
      child: CustomQrCard(
        plateNumber: widget.vehicle.plateNumber,
        qrData: qrData,
        embeddedImage: const AssetImage(
          'assets/images/jrmsu-logo.png',
        ),
      ),
    ),
```

3. The card composes a styled pass and injects `qrData` into `CustomQrView` which actually draws the QR image:

```93:102:lib/features/vehicle_management/widgets/qr/custom_qr_card.dart
  // QR view
  Container(
    height: 190,
    width: 190,
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: CustomQrView(qrData: qrData, embeddedImage: embeddedImage),
  ),
```

Note: `CustomQrView` is responsible for the actual QR module generation and optional logo embedding.

### Decryption on the scanning side

To read a sticker, a client needs the same 16-byte key and must reverse the process:

```dart
final crypto = CryptoService.withDefaultKey();
final rawVehicleId = crypto.decryptVehicleId(scannedQrPayload);
// rawVehicleId matches the original vehicle.vehicleID
```

### Error handling

- Decryption validates that ciphertext length is a multiple of 16.
- PKCS#7 bytes are verified; invalid padding throws a `FormatException` wrapped as `CryptographicException`.

```41:63:lib/core/services/cyrpto_service.dart
  String decryptVehicleId(String encrypted) {
    try {
      final cipherBytes = base64Url.decode(encrypted);
      if (cipherBytes.length % 16 != 0) {
        throw FormatException(
          'Ciphertext length must be a multiple of 16 bytes',
        );
      }

      final decryptedBytes = Uint8List(cipherBytes.length);
      for (var i = 0; i < cipherBytes.length; i += 16) {
        final block = cipherBytes.sublist(i, i + 16);
        final plainBlock = _aes.decryptBlock(Uint8List.fromList(block));
        decryptedBytes.setRange(i, i + 16, plainBlock);
      }

      final unpadded = _unpadData(decryptedBytes);
      final result = utf8.decode(unpadded);
      _logger?.call('[CryptoService] Decrypted Vehicle ID: $result');
      return result;
    } catch (e) {
      throw CryptographicException('Decryption failed: $e');
    }
  }
```

### Key management notes

- The default key is hard-coded for cross-platform interoperability. Rotate carefully and update all clients together.
- Never expose the key in logs or UI; `CryptoService` supports an optional logger for internal debugging only.

### Quick reference: end-to-end steps

- Get `vehicle.vehicleID`.
- Encrypt with `CryptoService.encryptVehicleId` → Base64-URL string.
- Render using `CustomQrView(qrData: ...)`.
- On scan, decode using `CryptoService.decryptVehicleId` to recover the original ID.
