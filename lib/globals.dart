// APP GLOBALS
import 'package:binancy/models/category.dart';

String appName = "Binancy";
String appVersion = "1.100.1";

// API GLOBALS
String apiURL = "https://binancy.herokuapp.com";
String testURL = "http://localhost:5000";

// USER GLOBALS
Map<String, dynamic> userData = {};
List<Category> categoryList = [];
int? userPayDay = 28;

// WIDGET GLOBALS
double customBorderRadius = 10;
double customMargin = 20;
double settingsRowHeight = 62;
double buttonHeight = 70;
double animLoadingSize = 200;
double movementCardSize = 75;

// UI GLOBALS
int dashboardMaxNotifications = 3;
int summaryMaxDifference = 5;
int latestMovementsMaxCount = 3;
