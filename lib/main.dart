import 'dart:async';

import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/views/enroll/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    Paint.enableDithering = true;

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      await FirebaseCrashlytics.instance.sendUnsentReports();
    }

    runApp(MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: secondaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(),
          splashColor: themeColor.withOpacity(0.1),
          highlightColor: themeColor.withOpacity(0.1),
          toggleableActiveColor: Colors.transparent,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
          unselectedWidgetColor: accentColor),
      builder: (context, child) =>
          ResponsiveWrapper.builder(child, defaultScale: true),
      title: appName,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('ca', '')
      ],
    );
  }
}
