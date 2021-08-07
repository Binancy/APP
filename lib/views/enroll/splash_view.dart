import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/dashboard/dashboard_view.dart';
import 'package:binancy/views/enroll/login_view.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    startSplashScreen();
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: FlutterLogo(),
      ),
    ));
  }

  void startSplashScreen() async {
    await Future.delayed(Duration(seconds: 3));
    if (await checkLoginWithToken()) {
      // TODO: Aqui se confirma que ha hecho login con el token, por lo cual ahora tiene que obtener los datos previos, una vez hecho esto mandar a DashbaordView()
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardView()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginView()),
          (route) => false);
    }
  }

  Future<bool> checkLoginWithToken() async {
    bool isOnStorage = await Utils.isOnSecureStorage("token");
    if (isOnStorage) {
      String token = await Utils.getFromSecureStorage("token");
      ConnAPI connAPI = ConnAPI(
          APIEndpoints.LOGIN_WITH__TOKEN, "POST", false, {"token": token});
      await connAPI.callAPI();
      List<dynamic>? response = connAPI.getResponse();
      if (response != null) {
        userData = response[0];
        return true;
      }
    }

    return false;
  }
}
