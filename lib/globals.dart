// APP GLOBALS
const String appName = "Binancy";
const String organizationName = "Appxs";
const String appVersion = "0.4.0";

// API GLOBALS
const String apiURL = "https://binancy.herokuapp.com";
const String testURL = "http://localhost:5000";
const Duration timeout = Duration(milliseconds: 5000);
const supportEmail = "support@appxs.es";
const appWebsite = "binancy.appxs.es";

// PLANS
const String MEMBER_PLAN = "member";
const String BINANCY_PLAN = "binancy";
const String FREE_PLAN = "free";

enum AvaiablePlans { member, binancy, free }

extension ParseToString on AvaiablePlans {
  String toShortString() {
    return toString().split('.').last;
  }
}

// USER GLOBALS
Map<String, dynamic> userData = {};
String currency = "€";

// WIDGET GLOBALS
const double customBorderRadius = 10;
const double customMargin = 20;
const double settingsRowHeight = 55;
const double buttonHeight = 70;
const double animLoadingSize = 200;
const double movementCardSize = 75;
const double subscriptionCardSize = 75;
const double adviceCardMinHeight = 125;
const double descriptionWidgetHeight = 250;
const double barChartWidth = 15;

// ANIMATION INTERVALS AND DURATION
const int savingsPlanProgressMS = 750;
const int plansCarouselIntervalMS = 7500;
const int opacityAnimationDurationMS = 250;
const int progressDialogBlurAnimation = 100;
const int logoutMinTimeMS = 3000;
const int pageSwapDurationMS = 500;
const int swapAnimationDurationMS = 500;
const int autoPassAdviceInterval = 5;
const int adviceTransitionDuration = 500;
const int registerTransitionDuration = 750;

// UI GLOBALS
const int dashboardMaxNotifications = 3;
const int summaryMaxDifference = 5;
const int latestMovementsMaxCount = 3;
const int savingsPlanMaxCount = 3;
const int dashboardSavingsPlanMaxCount = 2;
const int balanceChartMaxMonths = 6;
const int balanceMaxItemsPerCategory = 3;
const int categoryMaxItemsToShow = 5;

// ERROR CODES
class BinancyErrorCodes {
  static const int ERROR_CONNECTION_UNAVAIABLE = 1000;
  static const int ERROR_CONNECTION_TIMEOUT = 1001;
  static const int ERROR_RESPONSE_UNAVAIABLE = 1002;
}
