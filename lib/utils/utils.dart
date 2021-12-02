import 'dart:io';
import 'dart:math';
import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/microexpenses_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/controllers/providers/plans_change_notifier.dart';
import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
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
import 'package:provider/provider.dart';

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
    // TODO: Add premium features on next version
    /* String plan = userData['idPlan'] ?? "free";
    if (plan == MEMBER_PLAN || plan == BINANCY_PLAN) {
      return true;
    }
    return false; */
    return true;
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

  static DateTime getStartMonthByPayDay(DateTime referenceDate) {
    int payDay = userData['payDay'] ?? 1;
    if (referenceDate.day >= payDay) {
      return DateTime(referenceDate.year, referenceDate.month,
          getPayDayOfMonth(DateTime(referenceDate.year, referenceDate.month)));
    } else {
      return DateTime(
          referenceDate.year,
          referenceDate.month - 1,
          getPayDayOfMonth(
              DateTime(referenceDate.year, referenceDate.month - 1)));
    }
  }

  static DateTime getFinalMonthByPayDay(DateTime referenceDate) {
    int payDay = userData['payDay'] ?? 1;
    if (referenceDate.day >= payDay) {
      return DateTime(
          referenceDate.year,
          referenceDate.month + 1,
          getPayDayOfMonth(
              DateTime(referenceDate.year, referenceDate.month + 1)));
    } else {
      return DateTime(referenceDate.year, referenceDate.month,
          getPayDayOfMonth(DateTime(referenceDate.year, referenceDate.month)));
    }
  }

  static Month getMonthNameOfPayDay(DateTime thisMonthPayday) {
    bool isAfterHalfMonth = thisMonthPayday.day >= 16;
    return Month.values[
        isAfterHalfMonth ? thisMonthPayday.month + 1 : thisMonthPayday.month];
  }

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

  static bool isAfterPayDay(DateTime startPayDayMonth, DateTime movementDate) {
    bool potato = movementDate.isAfter(startPayDayMonth) ||
        movementDate.isAtSameMomentAs(startPayDayMonth);
    return potato;
  }

  static bool isBeforePayDay(DateTime finalPayDayMonth, DateTime movementDate) {
    bool tomate = movementDate.isBefore(finalPayDayMonth);
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
      parsedAmount += currency;
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

  static String parseColour(Color color) {
    if (color is MaterialColor) {
      return color.toString().split(' Color(')[1].split(')')[0];
    } else {
      return color.toString().split('Color(')[1].split(')')[0];
    }
  }

  static Future<bool> updateAllProviders(BuildContext context) async {
    bool status = false;
    if (await Utils.hasConnection().timeout(timeout)) {
      await Provider.of<CategoriesChangeNotifier>(context, listen: false)
          .updateCategories(context)
          .then((value) async {
        await Provider.of<MovementsChangeNotifier>(context, listen: false)
            .updateMovements()
            .then((value) {
          Provider.of<PlansChangeNotifier>(context, listen: false).updateAll();
          if (Utils.isPremium()) {
            Provider.of<SavingsPlanChangeNotifier>(context, listen: false)
                .updateSavingsPlan();
            Provider.of<MicroExpensesChangeNotifier>(context, listen: false)
                .updateMicroExpenses();
            Provider.of<SubscriptionsChangeNotifier>(context, listen: false)
                .updateSubscriptions();
          }
          status = true;
        });
      });
    } else {
      status = false;
    }

    return status;
  }

  static bool isIOS() {
    return Platform.isIOS;
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
