import 'package:binancy/controllers/dashboard_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/loading_widget.dart';
import 'package:binancy/utils/styles.dart';
import 'package:binancy/views/dashboard/dashboard_notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardSummaryNotificationLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardChangeNotifier>(
        builder: (context, value, child) => value.updating
            ? SliverToBoxAdapter(child: LoadingWidget())
            : SliverList(
                delegate: SliverChildListDelegate(
                    mountNotifications(value.movementsList)),
              ));
  }

  List<Widget> mountNotifications(List<dynamic> movementsList) {
    List<Widget> widgetList = [];

    widgetList.add(Padding(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
      child: Center(
        child: Text(
          'Tus ultimos movimientos',
          style: titleCardStyle(),
        ),
      ),
    ));

    if (movementsList.length > dashboardMaxNotifications) {
      for (var i = 0; i < dashboardMaxNotifications; i++) {
        widgetList.add(DashboardNotification(movementsList[i]));
      }
      widgetList.add(DashboardSeeAllNotifications());
    } else {
      for (var notification in movementsList) {
        widgetList.add(DashboardNotification(notification));
      }
    }
    return widgetList;
  }
}
