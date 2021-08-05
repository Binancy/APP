import 'package:binancy/controllers/dashboard_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:binancy/utils/styles.dart';

class DashboardHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardChangeNotifier>(builder: (context, value, child) {
      List<Widget> rowItems = [
        rowWidget(2151.15, "Ver patrimonio", () {}),
        rowWidget(1250.50, "Ver ingresos", () {}),
        rowWidget(752.76, "Ver gastos", () {})
      ];
      return Container(
          margin: EdgeInsets.all(customMargin),
          height: 75,
          child: ListView.separated(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => rowItems.elementAt(index),
              separatorBuilder: (context, index) => SizedBox(width: 10),
              itemCount: rowItems.length));
    });
  }

  Widget rowWidget(double value, String placeholder, Function() action) {
    return Material(
      color: themeColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(customBorderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(customBorderRadius),
        highlightColor: Colors.transparent,
        splashColor: secondaryColor.withOpacity(0.2),
        onTap: action,
        child: Container(
            height: 75,
            width: 140,
            child: Padding(
              padding: EdgeInsets.only(left: customMargin, right: customMargin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value.toStringAsFixed(2),
                      style: dashboardHeaderItemTitleStyle()),
                  Text(placeholder, style: dashboardHeaderItemActionStyle())
                ],
              ),
            )),
      ),
    );
  }
}
