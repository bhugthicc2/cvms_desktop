import 'dart:typed_data';
import 'dart:convert';
import 'package:cvms_desktop/core/crypto/enhanced_aes.dart';

class CryptoService {
  final EnhancedAES128 _aes;
  final void Function(String)? _logger;

  CryptoService(Uint8List key, {void Function(String)? logger})
    : assert(key.length == 16, 'Key must be 16 bytes'),
      _aes = EnhancedAES128(key),
      _logger = logger;

  /// Default instance with a fixed key
  factory CryptoService.withDefaultKey({void Function(String)? logger}) {
    final key = Uint8List.fromList(utf8.encode('akoSiPogi123ert5'));
    return CryptoService(key, logger: logger);
  }

  /// Encrypts a vehicle ID into a Base64 URL-safe string
  /// Pads input to 16-byte blocks with PKCS#7 padding
  /// main encryption method
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

  /// Applies PKCS#7 padding to make data length a multiple of 16 bytes.
  Uint8List _padData(List<int> data) {
    const blockSize = 16;
    final padLength = blockSize - (data.length % blockSize);
    final padded = Uint8List(data.length + padLength);
    padded.setRange(0, data.length, data);
    padded.fillRange(data.length, padded.length, padLength);
    return padded;
  }
}

/// Custom exception for cryptographic errors.
class CryptographicException implements Exception {
  final String message;
  CryptographicException(this.message);
  @override
  String toString() => 'CryptographicException: $message';
}
