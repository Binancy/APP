import 'package:binancy/controllers/dashboard_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:binancy/views/dashboard/dashboard_actions.dart';
import 'package:binancy/views/dashboard/dashboard_header_row.dart';
import 'package:binancy/views/dashboard/dashboard_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'dashboard_summary_notifications.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DashboardChangeNotifier dashboardChangeNotifier = DashboardChangeNotifier();
  _DashboardViewState() {
    dashboardChangeNotifier.updateDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => dashboardChangeNotifier)
      ],
      child: Stack(
        children: [
          Positioned(
              child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: ScrollConfiguration(
                behavior: MyBehavior(),
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: false,
                      snap: true,
                      floating: true,
                      brightness: Brightness.dark,
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      actions: [
                        IconButton(
                            icon: Icon(Icons.notifications_outlined),
                            onPressed: () {})
                      ],
                      leading: IconButton(
                          icon: Icon(Icons.settings_outlined),
                          onPressed: () {}),
                      title: Text(
                        AppLocalizations.of(context)!.dashboard_header,
                        style: appBarStyle(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: DashboardHeaderRow(),
                    ),
                    SliverToBoxAdapter(
                      child: DashboardSummaryCard(),
                    ),
                    SliverToBoxAdapter(
                      child: DashboardActionsCard(),
                    )
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
