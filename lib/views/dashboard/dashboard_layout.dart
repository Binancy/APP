import 'package:binancy/controllers/dashboard_change_notifier.dart';
import 'package:binancy/utils/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/dashboard/dashboard_actions.dart';
import 'package:binancy/views/dashboard/dashboard_header_row.dart';
import 'package:binancy/views/dashboard/dashboard_summary_card.dart';
import 'package:binancy/views/settings/settings_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
              child: BalancyBackground(
            Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      icon: Icon(Icons.settings_rounded),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsView()))),
                  automaticallyImplyLeading: false,
                  title: Text('Mi resumen', style: appBarStyle()),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  brightness: Brightness.dark,
                ),
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    DashboardHeaderRow(),
                    DashboardSummaryCard(),
                    DashboardActionsCard()
                  ],
                )),
          )),
        ],
      ),
    );
  }
}
