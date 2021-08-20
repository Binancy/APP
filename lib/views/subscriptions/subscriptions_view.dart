import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

class SubscriptionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text("Tus suscripciones", style: appBarStyle()),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              icon: Icon(Icons.more_horiz_rounded, color: Colors.white),
              onPressed: () {})
        ],
      ),
    ));
  }
}
