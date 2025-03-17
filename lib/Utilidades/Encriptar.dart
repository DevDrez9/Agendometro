import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class Encriptador {
  static final String _key =
      "H-yuFu2wicr?fr2wOJa\$lbRoswEGapaS"; // Llave de encriptación
  static final Key _secretKey = _createKey(_key); // Llave secreta
  static final IV _iv = IV.fromLength(16); // Vector de inicialización

  // Función para crear la clave de encriptación
  static Key _createKey(String key) {
    final keyBytes = utf8.encode(key);
    final sha1Bytes = sha1.convert(keyBytes).bytes;
    final aesKey = Uint8List.fromList(
        sha1Bytes.sublist(0, 16)); // AES usa una llave de 16 bytes
    return Key(aesKey);
  }

  // Función para encriptar
  static String encrypt(String plaintext) {
    final encrypter = Encrypter(AES(_secretKey,
        mode: AESMode.ecb)); // Asegurarse de usar el mismo modo y padding
    final encrypted = encrypter.encrypt(plaintext, iv: _iv);
    return encrypted.base64;
  }

  // Función para desencriptar
  static String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(_secretKey));
    final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}
