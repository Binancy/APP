import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/movements/movement_view.dart';
import 'package:binancy/views/movements/movements_card_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

class MovementBalanceView extends StatelessWidget {
  final List<String> monthsList = [
    "01/21",
    "02/21",
    "03/21",
    "04/21",
    "05/21",
    "06/21",
    "07/21",
    "08/21",
    "09/21",
    "10/21",
    "11/21",
    "12/21"
  ];

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
                    brightness: Brightness.dark,
                    centerTitle: true,
                    title: Text("Mi cuenta", style: appBarStyle()),
                  ),
                  body: Container(
                    child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView(
                          padding: EdgeInsets.only(
                              top: customMargin, bottom: customMargin),
                          children: [
                            Center(
                                child: Text(
                                    "Buenos días, " + userData['nameUser'],
                                    style: titleCardStyle())),
                            headerCard(context, movementsProvider),
                            SpaceDivider(),
                            Center(
                                child: Text("Tus últimos balances",
                                    style: titleCardStyle())),
                            barChart(context),
                            SpaceDivider(),
                            Center(
                                child: Text("Tus últimos movimientos",
                                    style: titleCardStyle())),
                            SpaceDivider(),
                            latestsIncomes(context, movementsProvider),
                            latestsExpenses(context, movementsProvider)
                          ],
                        )),
                  ),
                )));
  }

  Container latestsExpenses(
      BuildContext context, MovementsChangeNotifier movementsProvider) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.fromLTRB(customMargin, customMargin, customMargin, 0),
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
      margin: EdgeInsets.fromLTRB(customMargin, customMargin, customMargin, 0),
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

  Column barChart(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          padding: EdgeInsets.all(customMargin),
          child: BarChart(BarChartData(
              alignment: BarChartAlignment.center,
              groupsSpace: 24,
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                  bottomTitles: SideTitles(
                      getTitles: (value) => monthsList.elementAt(value.toInt()),
                      getTextStyles: (value) =>
                          TextStyle(fontSize: 11, fontFamily: "OpenSans"),
                      showTitles: true),
                  leftTitles: SideTitles(showTitles: false)),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [
                  BarChartRodData(y: 1517.79, colors: [accentColor], width: 15),
                  BarChartRodData(
                      y: 304.80,
                      colors: [Colors.white.withOpacity(0.25)],
                      width: 15)
                ]),
                BarChartGroupData(x: 1, barRods: [
                  BarChartRodData(y: 1574.79, colors: [accentColor], width: 15),
                  BarChartRodData(
                      y: 1854.80,
                      colors: [Colors.white.withOpacity(0.25)],
                      width: 15)
                ]),
                BarChartGroupData(x: 2, barRods: [
                  BarChartRodData(y: 1517.79, colors: [accentColor], width: 15),
                  BarChartRodData(
                      y: 954.80,
                      colors: [Colors.white.withOpacity(0.25)],
                      width: 15)
                ]),
                BarChartGroupData(x: 3, barRods: [
                  BarChartRodData(y: 854.79, colors: [accentColor], width: 15),
                  BarChartRodData(
                      y: 151.80,
                      colors: [Colors.white.withOpacity(0.25)],
                      width: 15)
                ]),
                BarChartGroupData(x: 4, barRods: [
                  BarChartRodData(y: 1254.79, colors: [accentColor], width: 15),
                  BarChartRodData(
                      y: 1000.80,
                      colors: [Colors.white.withOpacity(0.25)],
                      width: 15)
                ]),
                BarChartGroupData(x: 5, barRods: [
                  BarChartRodData(y: 1200.79, colors: [accentColor], width: 15),
                  BarChartRodData(
                      y: 1300.80,
                      colors: [Colors.white.withOpacity(0.25)],
                      width: 15)
                ])
              ])),
        ),
        Padding(
            padding: EdgeInsets.only(left: customMargin, right: customMargin),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, color: accentColor),
                    SpaceDivider(isVertical: true, customSpace: 10),
                    Text(
                      "Ingresos",
                      style: inputStyle(),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white.withOpacity(0.25)),
                    SpaceDivider(isVertical: true, customSpace: 10),
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
          margin:
              EdgeInsets.fromLTRB(customMargin, customMargin, customMargin, 0),
          padding:
              EdgeInsets.fromLTRB(customMargin, customMargin, customMargin, 0),
          decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
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
          padding: EdgeInsets.only(left: customMargin, right: customMargin),
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
        padding: EdgeInsets.only(
            top: customMargin, left: customMargin, bottom: customMargin),
        child: Text(movementType == MovementType.INCOME ? "Ingresos" : "Gastos",
            style: titleCardStyle())));
    listMovementsWidget.add(LinearDivider());
    if (providerList.length > 3) {
      for (var i = 0; i < latestMovementsMaxCount; i++) {
        listMovementsWidget.add(MovementCard(
            movement: providerList.elementAt(i),
            movementsProvider: movementsChangeNotifier));
        if (i != latestMovementsMaxCount - 1) {
          listMovementsWidget.add(LinearDivider());
        }
      }
    } else {
      for (var i = 0; i < providerList.length; i++) {
        for (var i = 0; i < latestMovementsMaxCount; i++) {
          listMovementsWidget.add(MovementCard(
              movement: providerList.elementAt(i),
              movementsProvider: movementsChangeNotifier));
          if (i != providerList.length - 1) {
            listMovementsWidget.add(LinearDivider());
          }
        }
      }
    }
    return listMovementsWidget;
  }
}
