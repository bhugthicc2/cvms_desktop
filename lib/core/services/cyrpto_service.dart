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

  /// Applies PKCS#7 padding to make data length a multiple of 16 bytes.
  Uint8List _padData(List<int> data) {
    const blockSize = 16;
    final padLength = blockSize - (data.length % blockSize);
    final padded = Uint8List(data.length + padLength);
    padded.setRange(0, data.length, data);
    padded.fillRange(data.length, padded.length, padLength);
    return padded;
  }

  /// Removes PKCS#7 padding from data.
  Uint8List _unpadData(Uint8List data) {
    if (data.isEmpty) {
      throw FormatException('Invalid padded data');
    }
    final padLength = data[data.length - 1];
    if (padLength < 1 || padLength > 16 || data.length < padLength) {
      throw FormatException('Invalid padding');
    }
    for (var i = data.length - padLength; i < data.length; i++) {
      if (data[i] != padLength) {
        throw FormatException('Invalid padding bytes');
      }
    }
    return Uint8List.sublistView(data, 0, data.length - padLength);
  }
}

/// Custom exception for cryptographic errors.
class CryptographicException implements Exception {
  final String message;
  CryptographicException(this.message);
  @override
  String toString() => 'CryptographicException: $message';
}
