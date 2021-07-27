import 'package:binancy/utils/styles.dart';
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
      bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded), label: 'Dashboard')
          ]),
      backgroundColor: Colors.white,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              brightness: Brightness.dark,
              centerTitle: true,
              elevation: 0,
              backgroundColor: primaryColor,
              actions: [
                IconButton(
                    icon: Icon(Icons.notifications_outlined), onPressed: () {})
              ],
              leading: IconButton(
                  icon: Icon(Icons.settings_outlined), onPressed: () {}),
              title: Text(
                AppLocalizations.of(context)!.dashboard_header,
                style: appBarStyle(),
              ),
            ),
            SliverToBoxAdapter(
              child: DashboardSummary(),
            ),
            SliverToBoxAdapter(
              child: DashboardCreateButtons(),
            )
          ],
        ),
      ),
    );
  }
}
