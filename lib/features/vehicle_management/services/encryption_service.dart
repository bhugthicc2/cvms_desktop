//todo implement soon
class EncryptionService {
  static String encrypt(String input) {
    return "cipher($input)";
  }

  static String decrypt(String cipherText) {
    return cipherText.replaceAll("cipher(", "").replaceAll(")", "");
  }
}
