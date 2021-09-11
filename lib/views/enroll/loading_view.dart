import 'dart:math';

import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/controllers/providers/plans_change_notifier.dart';
import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/controllers/subscriptions_controller.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/dashboard/dashboard_view.dart';
import 'package:binancy/views/enroll/splash_view.dart';
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

  Future<void> storeToken() async {
    await Utils.saveOnSecureStorage("token", userData["token"]);
  }
}
