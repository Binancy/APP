import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:binancy/views/dashboard/dashboard_chart.dart';
import 'package:binancy/views/dashboard/dashboard_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dashboard_create_buttons.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
              child: Container(
            height: 300,
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(customBorderRadius))),
          )),
          Positioned(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                title: Text(AppLocalizations.of(context)!.header_summary),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(Icons.settings_rounded), onPressed: () {}),
                actions: [
                  IconButton(
                      icon: Icon(Icons.notifications_active), onPressed: () {})
                ],
              ),
              body: ListView(
                children: [
                  SizedBox(height: 75),
                  DashboardSummaryCard(),
                  DashboardCreateButtons(),
                  DashboardChart()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
