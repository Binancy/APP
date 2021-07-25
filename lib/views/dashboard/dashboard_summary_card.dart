import 'package:binancy/globals.dart';
import 'package:flutter/material.dart';

class DashboardSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(customBorderRadius)),
      child: Container(
        height: 250,
      ),
    );
  }
}
