import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:flutter/material.dart';

class AdviceBinancyView extends StatelessWidget {
  const AdviceBinancyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Acerca de " + appName, style: appBarStyle()),
      ),
    ));
  }
}
