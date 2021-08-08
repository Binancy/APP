import 'package:binancy/views/advice/advice_card.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_svg/svg.dart';

class Utils {
  static List<AdviceCard> adviceCardList = [
    AdviceCard(
        icon: SvgPicture.asset("assets/svg/dashboard_categories.svg"),
        text:
            "Binancy te permite clasificar tus movimientos en categorias para tener un mayor control de ellos"),
    AdviceCard(
        icon: SvgPicture.asset("assets/svg/dashboard_historial.svg"),
        text:
            "Binancy almacena todos tus movimientos para que no se te escape ninguno."),
    AdviceCard(
        icon: SvgPicture.asset("assets/svg/dashboard_pie_chart.svg"),
        text:
            "Binancy te permite visualizar tus movimientos de multiples formas y filtros.")
  ];

  static String encrypt(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  static bool verifyEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static List<AdviceCard> getAllAdviceCards() {
    return adviceCardList;
  }

  static Future<void> saveOnSecureStorage(String key, dynamic value) async {
    var storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  static Future<void> removeFromSecureStorage(String key) async {
    var storage = FlutterSecureStorage();
    await storage.delete(key: key);
  }

  static Future<void> clearSecureStorage() async {
    var storage = FlutterSecureStorage();
    await storage.deleteAll();
  }

  static Future<String> getFromSecureStorage(String key) async {
    var storage = FlutterSecureStorage();
    return await storage.read(key: key) ?? "";
  }

  static Future<bool> isOnSecureStorage(String key) async {
    var storage = FlutterSecureStorage();
    return await storage.containsKey(key: key);
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange, this.currency = "€"})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;
  final String currency;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
