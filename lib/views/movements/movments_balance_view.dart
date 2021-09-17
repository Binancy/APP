import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/enums.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/movements/movements_card_widget.dart';
import 'package:binancy/views/movements/movements_empty_card_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovementBalanceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BinancyBackground(
        Consumer2<MovementsChangeNotifier, CategoriesChangeNotifier>(
            builder: (context, movementsProvider, categoriesProvider, child) =>
                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    title: Text("Mi cuenta", style: appBarStyle()),
                  ),
                  body: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: customMargin),
                        children: [
                          headerCard(context, movementsProvider),
                          const SpaceDivider(),
                          movementsProvider.totalHeritage == 0
                              ? const SizedBox()
                              : Center(
                                  child: Text("Tus últimos balances",
                                      style: titleCardStyle())),
                          movementsProvider.totalHeritage == 0
                              ? const SizedBox()
                              : barChart(context, movementsProvider),
                          movementsProvider.totalHeritage == 0
                              ? const SizedBox()
                              : const SpaceDivider(),
                          Center(
                              child: Text("Tus últimos movimientos",
                                  style: titleCardStyle())),
                          const SpaceDivider(),
                          latestsIncomes(context, movementsProvider),
                          latestsExpenses(context, movementsProvider)
                        ],
                      )),
                )));
  }

  Container latestsExpenses(
      BuildContext context, MovementsChangeNotifier movementsProvider) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.fromLTRB(
          customMargin, customMargin, customMargin, 0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(customBorderRadius),
        color: themeColor.withOpacity(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getLatestMovements(MovementType.EXPEND, movementsProvider),
      ),
    );
  }

  Container latestsIncomes(
      BuildContext context, MovementsChangeNotifier movementsProvider) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.fromLTRB(
          customMargin, customMargin, customMargin, 0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(customBorderRadius),
        color: themeColor.withOpacity(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getLatestMovements(MovementType.INCOME, movementsProvider),
      ),
    );
  }

  Widget barChart(
      BuildContext context, MovementsChangeNotifier movementsChangeNotifier) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          padding: const EdgeInsets.all(customMargin),
          child: BarChart(
            BarChartData(
                alignment: BarChartAlignment.center,
                groupsSpace: 24,
                barTouchData: BarTouchData(enabled: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                        getTitles: (value) =>
                            generateBalanceChartTitles(context)
                                .elementAt(value.toInt()),
                        getTextStyles: (value) => const TextStyle(
                            fontSize: 11, fontFamily: "OpenSans"),
                        showTitles: true),
                    leftTitles: SideTitles(showTitles: false)),
                barGroups: buildBarCharts(context, movementsChangeNotifier)),
            swapAnimationDuration:
                const Duration(milliseconds: swapAnimationDurationMS),
            swapAnimationCurve: Curves.easeOut,
          ),
        ),
        Padding(
            padding:
                const EdgeInsets.only(left: customMargin, right: customMargin),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, color: accentColor),
                    const SpaceDivider(isVertical: true, customSpace: 10),
                    Text(
                      "Ingresos",
                      style: inputStyle(),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white.withOpacity(0.25)),
                    const SpaceDivider(isVertical: true, customSpace: 10),
                    Text(
                      "Gastos",
                      style: inputStyle(),
                    )
                  ],
                )
              ],
            ))
      ],
    );
  }

  Widget headerCard(
      BuildContext context, MovementsChangeNotifier movementsProvider) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.fromLTRB(
              customMargin, customMargin, customMargin, 0),
          padding: const EdgeInsets.fromLTRB(
              customMargin, customMargin, customMargin, 0),
          decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(customBorderRadius),
                  topRight: Radius.circular(customBorderRadius))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Tu patrimonio", style: accentTitleStyle()),
              Text(movementsProvider.totalHeritage.toStringAsFixed(2) + "€",
                  style: balanceValueStyle()),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: customMargin, right: customMargin),
          child: BinancyButton(
              wrapOnFinal: true,
              context: context,
              text: "Ver movimientos",
              action: () {}),
        )
      ],
    );
  }

  List<Widget> getLatestMovements(MovementType movementType,
      MovementsChangeNotifier movementsChangeNotifier) {
    List<Widget> listMovementsWidget = [];
    List<dynamic> providerList = movementType == MovementType.INCOME
        ? movementsChangeNotifier.incomeList
        : movementsChangeNotifier.expendList;

    listMovementsWidget.add(Padding(
        padding: const EdgeInsets.only(
            top: customMargin, left: customMargin, bottom: customMargin),
        child: Text(movementType == MovementType.INCOME ? "Ingresos" : "Gastos",
            style: titleCardStyle())));
    listMovementsWidget.add(const LinearDivider());
    if (providerList.isEmpty) {
      listMovementsWidget.add(MovememntEmptyCard(movementType));
    } else {
      if (providerList.length > 3) {
        for (var i = 0; i < latestMovementsMaxCount; i++) {
          listMovementsWidget.add(MovementCard(
              movement: providerList.elementAt(i),
              movementsProvider: movementsChangeNotifier));
          if (i != latestMovementsMaxCount - 1) {
            listMovementsWidget.add(const LinearDivider());
          }
        }
      } else {
        for (var i = 0; i < providerList.length; i++) {
          for (var i = 0; i < latestMovementsMaxCount; i++) {
            listMovementsWidget.add(MovementCard(
                movement: providerList.elementAt(i),
                movementsProvider: movementsChangeNotifier));
            if (i != providerList.length - 1) {
              listMovementsWidget.add(const LinearDivider());
            }
          }
        }
      }
    }
    return listMovementsWidget;
  }

  List<String> generateBalanceChartTitles(BuildContext context) {
    List<String> chartTitles = [];
    for (var i = 0; i < balanceChartMaxMonths; i++) {
      DateTime previousMonth = DateTime(Utils.getTodayDate().year,
          Utils.getTodayDate().month - (i), Utils.getTodayDate().day);
      chartTitles.add(Utils.toMY(previousMonth, context));
    }
    return chartTitles;
  }

  List<BarChartGroupData> buildBarCharts(
      BuildContext context, MovementsChangeNotifier movementsChangeNotifier) {
    List<BarChartGroupData> barChartList = [];
    for (var i = 0; i < balanceChartMaxMonths; i++) {
      double monthIncomes = movementsChangeNotifier.getMonthIncomes(DateTime(
          Utils.getTodayDate().year,
          Utils.getTodayDate().month - i,
          Utils.getTodayDate().day));
      double monthExpends = movementsChangeNotifier.getMonthExpends(DateTime(
          Utils.getTodayDate().year,
          Utils.getTodayDate().month - i,
          Utils.getTodayDate().day));
      if (monthIncomes != 0 && monthExpends != 0) {}
      barChartList.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
            y: monthIncomes != 0 ? monthIncomes : 1,
            colors: [accentColor],
            width: barChartWidth),
        BarChartRodData(
            y: monthExpends != 0 ? monthExpends : 1,
            colors: [Colors.white.withOpacity(0.25)],
            width: barChartWidth)
      ]));
    }
    return List.from(barChartList.reversed);
  }
}
