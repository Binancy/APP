import 'package:crypto/crypto.dart';
import 'dart:convert';

class Utils {
  String encrypt(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  bool verifyEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
