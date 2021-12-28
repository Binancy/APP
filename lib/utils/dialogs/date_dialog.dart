import 'package:binancy/utils/ui/styles.dart';
import 'package:flutter/material.dart';

class BinancyDatePicker {
  final BuildContext context;
  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  BinancyDatePicker(
      {required this.context,
      required this.initialDate,
      this.firstDate,
      this.lastDate});

  Future<DateTime?> showCustomDialog() async {
    return showDatePicker(
            locale: Localizations.localeOf(context),
            context: context,
            builder: (context, child) => Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: accentColor,
                  colorScheme: ColorScheme.light(primary: secondaryColor),
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                ),
                child: child ?? Container()),
            initialDate: initialDate,
            firstDate: firstDate ?? DateTime(1970),
            lastDate: lastDate ?? DateTime(2100))
        .then((value) async {
      if (value != null) {
        return value;
      }
    });
  }
}
