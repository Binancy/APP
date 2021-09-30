import 'dart:math';

import 'package:binancy/controllers/subscriptions_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/views/advice/advice_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Utils {
  static List<AdviceCard> adviceCardList(BuildContext context) {
    return [
      AdviceCard(
          icon: SvgPicture.asset("assets/svg/dashboard_categories.svg"),
          text: AppLocalizations.of(context)!.register_advice_1(appName)),
      AdviceCard(
          icon: SvgPicture.asset("assets/svg/dashboard_historial.svg"),
          text: AppLocalizations.of(context)!.register_advice_2(appName)),
      AdviceCard(
          icon: SvgPicture.asset("assets/svg/dashboard_pie_chart.svg"),
          text: AppLocalizations.of(context)!.register_advice_3(appName))
    ];
  }

  // PLANS

  /// Check if the current user is premium or not
  static bool isPremium() {
    String plan = userData['idPlan'] ?? "free";
    if (plan == MEMBER_PLAN || plan == BINANCY_PLAN) {
      return true;
    }
    return false;
  }

  /// Returns true if [cuurentPlan] has the same lever or if it's greater than
  /// [neededPlan]
  static bool showIfPlanIsEqualOrHigher(String currentPlan, String neededPlan) {
    int posCurrentPlan = 0, posNeededPlan = 0;

    for (var plan in AvaiablePlans.values) {
      if (plan.toShortString() == currentPlan) {
        posCurrentPlan = plan.index;
      }

      if (plan.toShortString() == neededPlan) {
        posNeededPlan = plan.index;
      }
    }

    return posCurrentPlan <= posNeededPlan;
  }

  /// Returns true if [currentPlan] has the same lever or if it's lower than
  /// [maxPlan]
  static bool showIfPlanIsEqualOrLower(String currentPlan, String maxPlan) {
    int posCurrentPlan = 0, posMaxPlan = 0;

    for (var plan in AvaiablePlans.values) {
      if (plan.toShortString() == currentPlan) {
        posCurrentPlan = plan.index;
      }

      if (plan.toShortString() == maxPlan) {
        posMaxPlan = plan.index;
      }
    }

    return posCurrentPlan >= posMaxPlan;
  }

  /// Returns true if [currentPlan] has the same level of [toComparePlan]
  static bool showIfPlanIsEqual(String currentPlan, String toComparePlan) {
    return currentPlan == toComparePlan;
  }

  // ENROLLMENT

  /// Use it for encrypt a text or a text, for example.
  static String encrypt(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  /// Returns true if [email] contains the minimun characters to be a valid email.
  static bool verifyEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  /// Returns true if [password] meets the following conditions
  ///   - [password.length] >= 8
  ///   - [password] contains at least 1 uppercase
  ///   - [password] contains at least 1 lowercase
  ///   - [password] contains at least 1 number
  ///   - [password] contains at least 1 special character
  static bool verifySecurityPassword(String password) {
    RegExp regEx =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return password.length >= 8 && regEx.hasMatch(password);
  }

  /// Returns [adviceCardList()]
  static List<AdviceCard> getAllAdviceCards(BuildContext context) {
    return adviceCardList(context);
  }

  // SHARED STORAGE

  /// Save a value on SharedPreferences
  static Future<void> saveOnSecureStorage(String key, dynamic value) async {
    var storage = const FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  /// Remove a value from SharedPreferences
  static Future<void> removeFromSecureStorage(String key) async {
    var storage = const FlutterSecureStorage();
    await storage.delete(key: key);
  }

  /// Clears all data from SharedPreferences
  static Future<void> clearSecureStorage() async {
    var storage = const FlutterSecureStorage();
    await storage.deleteAll();
  }

  /// Get a value from SharedPreferences depending of [key]
  static Future<String> getFromSecureStorage(String key) async {
    var storage = const FlutterSecureStorage();
    return await storage.read(key: key) ?? "";
  }

  /// Checks if SharedPreferences has a value which contains [key]
  static Future<bool> isOnSecureStorage(String key) async {
    var storage = const FlutterSecureStorage();
    return await storage.containsKey(key: key);
  }

  // BASIC DATES

  static DateTime getTodayDate() {
    DateTime today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }

  static bool validateStringDate(String date) {
    try {
      DateFormat.yMd().parse(date);
    } catch (e) {
      return false;
    }

    return true;
  }

  static bool isAtSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }

  static bool isLeapYear(DateTime date) {
    return date.year % 4 == 0 || date.year % 100 == 0 && date.year % 400 == 0;
  }

  // PARSE AND TRANSFORM DATES

  static DateTime fromISOStandard(String date) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date);
  }

  static String toISOStandard(DateTime date) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss").format(date);
  }

  static bool isValidDateYMD(String date, BuildContext context) {
    try {
      fromYMD(date, context);
      return true;
    } catch (e) {
      return false;
    }
  }

  static DateTime fromYMD(String date, BuildContext context) {
    return DateFormat.yMd(Localizations.localeOf(context).toLanguageTag())
        .parse(date);
  }

  static String toYMD(DateTime date, BuildContext context) {
    return DateFormat.yMd(Localizations.localeOf(context).toLanguageTag())
        .format(date);
  }

  static DateTime fromMD(String date, BuildContext context) {
    return DateFormat.Md(Localizations.localeOf(context).toLanguageTag())
        .parse(date);
  }

  static String toMD(DateTime date, BuildContext context) {
    return DateFormat.Md(Localizations.localeOf(context).toLanguageTag())
        .format(date);
  }

  static DateTime fromMY(String date, BuildContext context) {
    return DateFormat("M/yy", Localizations.localeOf(context).toLanguageTag())
        .parse(date);
  }

  static String toMY(DateTime date, BuildContext context) {
    return DateFormat("M/yy", Localizations.localeOf(context).toLanguageTag())
        .format(date);
  }

  static String getMonthOfDate(DateTime date, BuildContext context) {
    return DateFormat.MMMM(Localizations.localeOf(context).toLanguageTag())
        .format(date);
  }

  // PAYDAY

  /// payDay 2.0
  static DateTime getCurrentMonthPayDay() {
    DateTime today = Utils.getTodayDate();
    int payDay = userData['payDay'] ?? 1;
    if (today.day >= payDay) {
      return DateTime(today.year, today.month,
          getPayDayOfMonth(DateTime(today.year, today.month)));
    } else {
      return DateTime(today.year, today.month - 1,
          getPayDayOfMonth(DateTime(today.year, today.month - 1)));
    }
  }

  /// payDay 2.0
  static DateTime getNextMonthPayDay() {
    DateTime today = Utils.getTodayDate();
    int payDay = userData['payDay'] ?? 1;
    if (today.day >= payDay) {
      return DateTime(today.year, today.month + 1,
          getPayDayOfMonth(DateTime(today.year, today.month + 1)));
    } else {
      return DateTime(today.year, today.month,
          getPayDayOfMonth(DateTime(today.year, today.month)));
    }
  }

  /// payDay 2.0
  static Month getMonthNameOfPayDay(DateTime thisMonthPayday) {
    bool isAfterHalfMonth = thisMonthPayday.day >= 16;
    return Month.values[
        isAfterHalfMonth ? thisMonthPayday.month + 1 : thisMonthPayday.month];
  }

  // payDay 2.0
  static int getPayDayOfMonth(DateTime date) {
    int payDay = userData['payDay'];

    if (payDay == 31) {
      if (date.month == 2) {
        return isLeapYear(date) ? 29 : 28;
      } else {
        DateTime expectedDate = DateTime(date.year, date.month, payDay);
        if (expectedDate.month == date.month + 1 && expectedDate.day == 1) {
          return 30;
        }
      }
    } else if (payDay == 29 || payDay == 30) {
      if (date.month == 2) {
        return isLeapYear(date) ? 29 : 28;
      }
    }

    return payDay;
  }

  static DateTime getThisMonthPayDay() {
    DateTime today = DateTime.now();
    int payDay = userData['payDay'] ?? 1;

    if (payDay == 31) {
      DateTime expectedPayDayDate =
          DateTime(today.year, today.month, userData['payDay']);
      if (today.month == 2 && expectedPayDayDate.day == 1 | 2 | 3) {
        return DateTime(today.year, today.month, isLeapYear(today) ? 29 : 28);
      } else if (expectedPayDayDate.month == today.month + 1 &&
          expectedPayDayDate.day == 1) {
        return DateTime(today.year, today.month, 30);
      }
    } else if (payDay == 30 || payDay == 29) {
      if (today.month == 2) {
        return DateTime(today.year, today.month, isLeapYear(today) ? 29 : 28);
      }
    }
    return DateTime(today.year, today.month, userData['payDay'] ?? 1);
  }

  static DateTime getLatestMonthPayDay() {
    DateTime today = DateTime.now();
    int payDay = userData['payDay'] ?? 1;

    if (payDay == 31) {
      DateTime expectedDate = DateTime(
          today.month == 1 ? today.year - 1 : today.year,
          today.month == 1 ? 12 : today.month - 1,
          userData['payDay']);
      if (expectedDate.month == 2 && expectedDate.day == 1 | 2 | 3) {
        return DateTime(expectedDate.year, expectedDate.month - 1,
            isLeapYear(today) ? 29 : 28);
      } else if (expectedDate.month == today.month && expectedDate.day == 1) {
        return DateTime(expectedDate.year, expectedDate.month - 1, 30);
      }
    } else if (payDay == 30 || payDay == 29) {
      return DateTime(today.month == 1 ? today.year - 1 : today.year,
          today.month == 1 ? 12 : today.month - 1, isLeapYear(today) ? 29 : 28);
    }
    return DateTime(today.month == 1 ? today.year - 1 : today.year,
        today.month == 1 ? 12 : today.month - 1, userData['payDay'] ?? 1);
  }

  static DateTime getSpecificMonthPayDay(DateTime monthDate) {
    int payDay = userData['payDay'] ?? 1;
    if (payDay == 31) {
      DateTime expectedDate = DateTime(monthDate.year, monthDate.month, payDay);
      if (monthDate.month == 2 && expectedDate.day == 1 | 2 | 3) {
        return DateTime(
            monthDate.year, monthDate.month, isLeapYear(monthDate) ? 29 : 28);
      } else if (expectedDate.month == monthDate.month + 1 &&
          expectedDate.day == 1) {
        return DateTime(monthDate.year, monthDate.month, 30);
      }
    } else if (payDay == 30 || payDay == 29) {
      if (monthDate.month == 2) {
        return DateTime(
            monthDate.year, monthDate.month, isLeapYear(monthDate) ? 29 : 28);
      }
    }

    return DateTime(monthDate.year, monthDate.month, payDay);
  }

  static bool isAfterPayDay(DateTime month, DateTime movementDate) {
    DateTime lastMonthPayDay = DateTime(
        month.year, month.month - 1, Utils.getThisMonthPayDay().day, 0, 0, 0);
    bool potato = movementDate.isAfter(lastMonthPayDay) ||
        movementDate.isAtSameMomentAs(lastMonthPayDay);
    return potato;
  }

  static bool isBeforePayDay(DateTime month, DateTime movementDate) {
    DateTime thisMonthPayDay = DateTime(
        month.year, month.month, Utils.getThisMonthPayDay().day, 0, 0, 0);
    bool tomate = movementDate.isBefore(thisMonthPayDay);
    return tomate;
  }

  static double roundDown(double value, int precision) {
    final isNegative = value.isNegative;
    final mod = pow(10.0, precision);
    final roundDown = (((value.abs() * mod).floor()) / mod);
    return isNegative ? -roundDown : roundDown;
  }

  // XTRA

  static String getFullUsername() {
    String name = userData['nameUser'];
    String firstSurname = userData['firstSurname'] ?? "";
    String lastSurname = userData['lastSurname'] ?? "";

    String fullName = name;

    if (firstSurname.isNotEmpty) {
      fullName += " " + firstSurname;
    }

    if (lastSurname.isNotEmpty) {
      fullName += " " + lastSurname;
    }

    return fullName;
  }

  static Future<bool> hasConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static String parseAmount(dynamic amount,
      {bool addCurreny = true, int amountToRound = 10000}) {
    String parsedAmount = "";

    if (amount is int) {
      parsedAmount = amount.toString();
    } else if (amount is double) {
      bool canParseToInt = amount % 1 == 0;
      amount = roundDown(amount, 2);
      parsedAmount = amount >= amountToRound
          ? roundDown(amount, 0).toStringAsFixed(0)
          : amount.toStringAsFixed(canParseToInt ? 0 : 2);
    }

    if (addCurreny) {
      parsedAmount += "€";
    }

    return parsedAmount;
  }

  static Month thisMonthEnun(DateTime todayDate) {
    return Month.values[todayDate.month];
  }

  static void unfocusAll(List<FocusNode> focusNodeList) {
    for (var focusNode in focusNodeList) {
      focusNode.unfocus();
    }
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange, this.currency = "€"})
      : assert(decimalRange > 0);

  final int decimalRange;
  final String currency;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;
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
}
