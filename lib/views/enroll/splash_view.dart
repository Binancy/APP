import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/microexpenses_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/controllers/providers/plans_change_notifier.dart';
import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/controllers/subscriptions_controller.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/dashboard/dashboard_view.dart';
import 'package:binancy/views/enroll/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            const Positioned(
                child: Center(
              child: BinancyIconVertical(
                showProgressIndicator: true,
              ),
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
    await precacheSvg(context);
    if (await checkLoginWithToken()) {
      gotoDashboard(context);
    } else {
      await Future.delayed(const Duration(milliseconds: 1500));
      gotoLogin(context);
    }
  }

  Future<bool> checkLoginWithToken() async {
    bool isOnStorage = await Utils.isOnSecureStorage("token");
    if (isOnStorage) {
      String token = await Utils.getFromSecureStorage("token");
      ConnAPI connAPI = ConnAPI(
          APIEndpoints.LOGIN_WITH_TOKEN, "POST", false, {"token": token},
          disableTimeout: true);
      await connAPI.callAPI();
      if (connAPI.getStatus() == 200) {
        userData = connAPI.getResponse()![0];
        return true;
      }
    }
    return false;
  }

  Future<void> precacheSvg(BuildContext context) async {
    Future.wait([
      precachePicture(
          ExactAssetPicture(
              SvgPicture.svgStringDecoder, "assets/svg/dashboard_vault.svg"),
          null),
      precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder,
              "assets/svg/dashboard_add_expense.svg"),
          null),
      precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder,
              "assets/svg/dashboard_add_income.svg"),
          null),
      precachePicture(
          ExactAssetPicture(
              SvgPicture.svgStringDecoder, "assets/svg/dashboard_advices.svg"),
          null),
      precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder,
              "assets/svg/dashboard_categories.svg"),
          null),
      precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder,
              "assets/svg/dashboard_check_balance.svg"),
          null),
      precachePicture(
          ExactAssetPicture(
              SvgPicture.svgStringDecoder, "assets/svg/dashboard_coins.svg"),
          null),
      precachePicture(
          ExactAssetPicture(
              SvgPicture.svgStringDecoder, "assets/svg/dashboard_compare.svg"),
          null),
      precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder,
              "assets/svg/dashboard_historial.svg"),
          null),
      precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder,
              "assets/svg/dashboard_pie_chart.svg"),
          null),
      precachePicture(
          ExactAssetPicture(
              SvgPicture.svgStringDecoder, "assets/svg/dashboard_premium.svg"),
          null),
      precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder,
              "assets/svg/dashboard_see_movements.svg"),
          null),
      precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder,
              "assets/svg/dashboard_see_movements.svg"),
          null),
      precachePicture(
          ExactAssetPicture(
              SvgPicture.svgStringDecoder, "assets/svg/dashboard_settings.svg"),
          null),
    ]);
  }
}

void gotoLogin(BuildContext context) {
  Navigator.pushAndRemoveUntil(
      context, FadeRoute(page: LoginView()), (route) => false);
}

void gotoDashboard(BuildContext context) async {
  CategoriesChangeNotifier categoriesChangeNotifier =
      CategoriesChangeNotifier();
  await categoriesChangeNotifier.updateCategories(context);

  MovementsChangeNotifier dashboardChangeNotifier = MovementsChangeNotifier();
  await dashboardChangeNotifier.updateMovements();

  PlansChangeNotifier plansChangeNotifier = PlansChangeNotifier();
  await plansChangeNotifier.updatePlans();
  await plansChangeNotifier.updateCarousel();

  SubscriptionsChangeNotifier subscriptionsChangeNotifier =
      SubscriptionsChangeNotifier();

  SavingsPlanChangeNotifier savingsPlanChangeNotifier =
      SavingsPlanChangeNotifier();

  MicroExpensesChangeNotifier microExpensesChangeNotifier =
      MicroExpensesChangeNotifier();

  if (Utils.isPremium()) {
    await subscriptionsChangeNotifier.updateSubscriptions();
    await savingsPlanChangeNotifier.updateSavingsPlan();
    await microExpensesChangeNotifier.updateMicroExpenses();

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
      FadeRoute(
          page: MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => dashboardChangeNotifier),
        ChangeNotifierProvider(create: (context) => categoriesChangeNotifier),
        ChangeNotifierProvider(
          create: (context) => subscriptionsChangeNotifier,
        ),
        ChangeNotifierProvider(create: (context) => savingsPlanChangeNotifier),
        ChangeNotifierProvider(create: (context) => plansChangeNotifier),
        ChangeNotifierProvider(create: (context) => microExpensesChangeNotifier)
      ], child: DashboardView())),
      (route) => false);
}
