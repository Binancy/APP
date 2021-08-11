import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/views/movements/all_movements_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:binancy/utils/styles.dart';

class DashboardHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MovementsChangeNotifier>(
        builder: (context, provider, child) {
      List<Widget> rowItems = [
        rowWidget(provider.totalHeritage, "Ver patrimonio", () {}),
        rowWidget(
            provider.getThisMonthIncomes(),
            "Ver ingresos",
            () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) =>
                            Provider.of<MovementsChangeNotifier>(context),
                      ),
                      ChangeNotifierProvider(
                        create: (_) =>
                            Provider.of<CategoriesChangeNotifier>(context),
                      )
                    ],
                    child: AllMovementView(initialPage: 0),
                  ),
                ))),
        rowWidget(
            provider.getThisMonthExpenses(),
            "Ver gastos",
            () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) =>
                            Provider.of<MovementsChangeNotifier>(context),
                      ),
                      ChangeNotifierProvider(
                        create: (_) =>
                            Provider.of<CategoriesChangeNotifier>(context),
                      )
                    ],
                    child: AllMovementView(initialPage: 1),
                  ),
                )))
      ];
      return Container(
          margin: EdgeInsets.only(top: 10, bottom: customMargin),
          height: (MediaQuery.of(context).size.height / 10),
          child: ListView.separated(
              padding: EdgeInsets.only(left: 20, right: 20),
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
        splashColor: themeColor.withOpacity(0.1),
        onTap: action,
        child: Container(
            height: 75,
            width: 160,
            child: Padding(
              padding: EdgeInsets.only(left: customMargin, right: customMargin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  value >= 10000
                      ? Text(
                          value.toInt().toString() + "€",
                          style: dashboardHeaderItemTitleStyle(),
                        )
                      : Text(value.toStringAsFixed(2) + "€",
                          style: dashboardHeaderItemTitleStyle()),
                  Text(placeholder, style: dashboardHeaderItemActionStyle())
                ],
              ),
            )),
      ),
    );
  }
}
