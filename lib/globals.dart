// APP GLOBALS
import 'package:binancy/models/category.dart';

const String appName = "Binancy";
const String appVersion = "1.1.1";

// API GLOBALS
const String apiURL = "https://binancy.herokuapp.com";
const String testURL = "http://localhost:5000";

// PLANS
const String MEMBER_PLAN = "member";
const String BINANCY_PLAN = "binancy";
const String FREE_PLAN = "free";

enum AvaiablePlans { member, binancy, free }

extension ParseToString on AvaiablePlans {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

// USER GLOBALS
Map<String, dynamic> userData = {};
List<Category> categoryList = [];
int? userPayDay = 28;

// WIDGET GLOBALS
double customBorderRadius = 10;
double customMargin = 20;
double settingsRowHeight = 55;
double buttonHeight = 70;
double animLoadingSize = 200;
double movementCardSize = 75;
double subscriptionCardSize = 75;
double adviceCardMinHeight = 125;
double descriptionWidgetHeight = 250;

// ANIMATION INTERVALS AND DURATION
int savingsPlanProgressMS = 750;

// UI GLOBALS
int dashboardMaxNotifications = 3;
int summaryMaxDifference = 5;
int latestMovementsMaxCount = 3;
int savingsPlanMaxCount = 3;
int dashboardSavingsPlanMaxCount = 2;

// ERROR CODES
class BinancyErrorCodes {
  static const int ERROR_CONNECTION_UNAVAIABLE = 1000;
  static const int ERROR_CONNECTION_TIMEOUT = 1001;
  static const int ERROR_RESPONSE_UNAVAIABLE = 1002;
}
