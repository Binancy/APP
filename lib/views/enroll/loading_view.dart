import 'package:binancy/utils/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:lottie/lottie.dart';

import '../../globals.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getData(context);
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
                  Container(
                    margin: EdgeInsets.only(
                        left: customMargin, right: customMargin),
                    decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(customBorderRadius)),
                    height: 100,
                    padding: EdgeInsets.all(customMargin),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: SvgPicture.asset(
                              "assets/svg/dashboard_categories.svg"),
                        ),
                        SpaceDivider(isVertical: true),
                        Expanded(
                            child: Text(
                          "Binancy te permite clasificar tus movimientos en categorias para tener un mayor control de ellos",
                          style: semititleStyle(),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            )))),
        onWillPop: () async => false);
  }

  void getData(BuildContext context) {
    gotoDashboard(context);
  }

  void gotoDashboard(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardView()),
        (route) => false);
  }
}
