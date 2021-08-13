import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/dashboard/dashboard_actions.dart';
import 'package:binancy/views/dashboard/dashboard_header_row.dart';
import 'package:binancy/views/dashboard/dashboard_summary_card.dart';
import 'package:binancy/views/settings/settings_view.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            child: BinancyBackground(
          Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(BinancyIcons.settings),
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
    );
  }
}
