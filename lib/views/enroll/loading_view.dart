import 'dart:math';

import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/utils/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../globals.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeApp(context);
    return WillPopScope(
        child: BinancyBackground(Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: animLoadingSize,
                    width: animLoadingSize,
                    child: Lottie.asset("assets/lottie/loading_view_anim.json"),
                  ),
                  SpaceDivider(),
                  Text(
                    appName + " esta cargando...",
                    style: titleCardStyle(),
                  ),
                  SpaceDivider(),
                  Utils.getAllAdviceCards()[
                      Random().nextInt(Utils.getAllAdviceCards().length)]
                ],
              ),
            )))),
        onWillPop: () async => false);
  }

  void initializeApp(BuildContext context) async {
    await storeToken();
    gotoDashboard(context);
  }

  void gotoDashboard(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));

    MovementsChangeNotifier dashboardChangeNotifier = MovementsChangeNotifier();
    dashboardChangeNotifier.updateDashboard();

    CategoriesChangeNotifier categoriesChangeNotifier =
        CategoriesChangeNotifier();
    categoriesChangeNotifier.updateCategories();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => MultiProvider(providers: [
                  ChangeNotifierProvider(
                      create: (context) => dashboardChangeNotifier),
                  ChangeNotifierProvider(
                      create: (context) => categoriesChangeNotifier)
                ], child: DashboardView())),
        (route) => false);
  }

  Future<void> storeToken() async {
    await Utils.saveOnSecureStorage("token", userData["token"]);
  }
}
