import 'dart:math';

import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/enroll/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingView extends StatefulWidget {
  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  Widget build(BuildContext context) {
    initializeApp(context);
    return WillPopScope(
        child: BinancyBackground(Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: animLoadingSize,
                    width: animLoadingSize,
                    child: Lottie.asset("assets/lottie/loading_view_anim.json"),
                  ),
                  const SpaceDivider(),
                  Text(
                    AppLocalizations.of(context)!.please_wait,
                    style: titleCardStyle(),
                  ),
                  const SpaceDivider(),
                  Utils.getAllAdviceCards(context)[
                      Random().nextInt(Utils.getAllAdviceCards(context).length)]
                ],
              ),
            ))),
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
