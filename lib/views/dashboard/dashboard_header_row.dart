import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/views/movements/movements_all_view.dart';
import 'package:binancy/views/movements/movments_balance_view.dart';
import 'package:binancy/views/subscriptions/subscriptions_all_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:binancy/utils/ui/styles.dart';

class DashboardHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<MovementsChangeNotifier, SubscriptionsChangeNotifier>(
        builder: (context, movementsProvider, subscriptionsProvider, child) {
      List<Widget> rowItems = buildRowWidgets(context, movementsProvider);
      if (Utils.isPremium()) {
        rowItems.add(rowWidget(
            subscriptionsProvider.totalSubscriptionsValue,
            "Ver suscripciones",
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                              create: (_) =>
                                  Provider.of<SubscriptionsChangeNotifier>(
                                      context),
                            )
                          ],
                          child: SubscriptionsView(),
                        )))));
      }

      return Container(
          margin: const EdgeInsets.only(top: 10, bottom: customMargin),
          height: (MediaQuery.of(context).size.height / 10),
          child: ListView.separated(
              padding: const EdgeInsets.only(left: 20, right: 20),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => rowItems.elementAt(index),
              separatorBuilder: (context, index) => const SizedBox(width: 10),
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
        child: SizedBox(
            height: 75,
            width: 160,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: customMargin, right: customMargin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Utils.parseAmount(value, amountToRound: 10000),
                      style: dashboardHeaderItemTitleStyle()),
                  Text(placeholder, style: dashboardHeaderItemActionStyle())
                ],
              ),
            )),
      ),
    );
  }

  List<Widget> buildRowWidgets(
      BuildContext context, MovementsChangeNotifier movementsProvider) {
    return [
      rowWidget(
          movementsProvider.totalHeritage,
          "Ver patrimonio",
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
                        child: MovementBalanceView(),
                      )))),
      rowWidget(
          movementsProvider.getThisMonthIncomes(),
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
                  child: const AllMovementView(initialPage: 0),
                ),
              ))),
      rowWidget(
          movementsProvider.getThisMonthExpenses(),
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
                  child: const AllMovementView(initialPage: 1),
                ),
              ))),
    ];
  }
}
