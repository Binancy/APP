import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/controllers/providers/plans_change_notifier.dart';
import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/dashboard/dashboard_actions.dart';
import 'package:binancy/views/dashboard/dashboard_header_row.dart';
import 'package:binancy/views/dashboard/dashboard_summary_card.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:binancy/views/settings/settings_view.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Consumer<MovementsChangeNotifier>(
      builder: (context, provider, child) => BinancyBackground(
        Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    icon: const Icon(BinancyIcons.alert), onPressed: () {})
              ],
              leading: IconButton(
                  icon: const Icon(BinancyIcons.settings),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MultiProvider(providers: [
                                ChangeNotifierProvider(
                                    create: (_) =>
                                        Provider.of<PlansChangeNotifier>(
                                            context))
                              ], child: SettingsView())))),
              automaticallyImplyLeading: false,
              title: Text('Mi resumen', style: appBarStyle()),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SmartRefresher(
                  header: ClassicHeader(
                    textStyle: inputStyle(),
                    idleIcon: Icon(Icons.arrow_downward, color: accentColor),
                    releaseIcon:
                        Icon(Icons.refresh_rounded, color: accentColor),
                    refreshingIcon: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(accentColor),
                            strokeWidth: 1)),
                    completeIcon: Icon(Icons.check, color: accentColor),
                    refreshingText: "Actualizando...",
                    completeText: "Datos actualizados",
                    releaseText: "Suelta para actualizar",
                    idleText: "Desliza para actualizar",
                  ),
                  controller: _refreshController,
                  onRefresh: () async {
                    await provider.updateMovements().then((value) {
                      Provider.of<SavingsPlanChangeNotifier>(context,
                              listen: false)
                          .updateSavingsPlan();
                      Provider.of<SubscriptionsChangeNotifier>(context,
                              listen: false)
                          .updateSubscriptions();
                      Provider.of<PlansChangeNotifier>(context, listen: false)
                          .updateAll();
                      _refreshController.refreshCompleted();
                    });
                  },
                  child: Column(
                    children: [
                      DashboardHeaderRow(),
                      const DashboardSummaryCard(),
                      DashboardActionsCard()
                    ],
                  ),
                ))),
      ),
    );
  }
}
