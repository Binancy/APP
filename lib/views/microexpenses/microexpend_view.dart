import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

class MicroExpendView extends StatefulWidget {
  const MicroExpendView({Key? key}) : super(key: key);

  @override
  _MicroExpendViewState createState() => _MicroExpendViewState();
}

class _MicroExpendViewState extends State<MicroExpendView> {
  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        brightness: Brightness.dark,
        title: Text("data", style: appBarStyle()),
      ),
    ));
  }
}
