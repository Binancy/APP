import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/controllers/providers/plans_change_notifier.dart';
import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/controllers/subscriptions_controller.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/dashboard/dashboard_view.dart';
import 'package:binancy/views/enroll/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    startSplashScreen(context);
    return BinancyBackground(Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
                child: Center(
              child: BinancyIconVertical(),
            )),
            Positioned(
                child: Container(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/icons/binancy_signature.png",
                  scale: .5,
                ),
              ),
            ))
          ],
        )));
  }

  void startSplashScreen(BuildContext context) async {
    if (await checkLoginWithToken()) {
      gotoDashboard(context);
    } else {
      gotoLogin(context);
    }
  }

  Future<bool> checkLoginWithToken() async {
    bool isOnStorage = await Utils.isOnSecureStorage("token");
    if (isOnStorage) {
      String token = await Utils.getFromSecureStorage("token");
      ConnAPI connAPI = ConnAPI(
          APIEndpoints.LOGIN_WITH_TOKEN, "POST", false, {"token": token});
      await connAPI.callAPI();
      if (connAPI.getStatus() == 200) {
        userData = connAPI.getResponse()![0];
        return true;
      }
    }
    return false;
  }

  void gotoLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LoginView()), (route) => false);
  }
}

void gotoDashboard(BuildContext context) async {
  MovementsChangeNotifier dashboardChangeNotifier = MovementsChangeNotifier();
  await dashboardChangeNotifier.updateMovements();

  CategoriesChangeNotifier categoriesChangeNotifier =
      CategoriesChangeNotifier();
  await categoriesChangeNotifier.updateCategories();

  SubscriptionsChangeNotifier subscriptionsChangeNotifier =
      SubscriptionsChangeNotifier();

  SavingsPlanChangeNotifier savingsPlanChangeNotifier =
      SavingsPlanChangeNotifier();

  if (Utils.isPremium()) {
    await subscriptionsChangeNotifier.updateSubscriptions();
    await savingsPlanChangeNotifier.updateSavingsPlan();

    // Verifica si hay alguna suscripción por pagar, si es asi, añade el gasto a la
    // DB, actualiza el ultimo mes de cobro de la suscripción y avisa a MovementsChangeNotifier
    // que tiene que actualizarse de nuevo
    await SubscriptionsController.checkSubscriptions(
            subscriptionsChangeNotifier.subscriptionsList)
        .then((value) async {
      if (value) {
        await dashboardChangeNotifier.updateMovements();
      }
    });
  }

  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (_) => MultiProvider(providers: [
                ChangeNotifierProvider(
                    create: (context) => dashboardChangeNotifier),
                ChangeNotifierProvider(
                    create: (context) => categoriesChangeNotifier),
                ChangeNotifierProvider(
                  create: (context) => subscriptionsChangeNotifier,
                ),
                ChangeNotifierProvider(
                    create: (context) => savingsPlanChangeNotifier),
                ChangeNotifierProvider(
                    create: (_) => PlansChangeNotifier()
                      ..updatePlans()
                      ..updateCarousel())
              ], child: DashboardView())),
      (route) => false);
}
