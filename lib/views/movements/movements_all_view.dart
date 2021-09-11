import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/utils/enums.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/movements/movements_empty_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'movements_card_widget.dart';

class AllMovementView extends StatefulWidget {
  final int initialPage;
  AllMovementView({this.initialPage = 0});

  @override
  _AllMovementViewState createState() => _AllMovementViewState(initialPage);
}

class _AllMovementViewState extends State<AllMovementView>
    with SingleTickerProviderStateMixin {
  DateTime? fromDate, toDate;
  double? minValue, maxValue;

  late PageController pageController;
  late TabController tabController;

  int pageIndex;
  int pageSwapDurationMS = 500;

  _AllMovementViewState(this.pageIndex);

  @override
  void initState() {
    pageController = PageController(initialPage: pageIndex);
    tabController =
        TabController(length: 2, vsync: this, initialIndex: pageIndex);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Consumer<MovementsChangeNotifier>(
        builder: (context, movementsProvider, child) => WillPopScope(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  elevation: 0,
                  actions: [
                    IconButton(
                        onPressed: () {}, icon: Icon(BinancyIcons.filter))
                  ],
                  title: Text("Todos tus movimientos", style: appBarStyle()),
                  bottom: TabBar(
                      controller: tabController,
                      onTap: (value) {
                        setState(() {
                          pageIndex = value;
                        });
                        pageController.animateToPage(pageIndex,
                            duration:
                                Duration(milliseconds: pageSwapDurationMS),
                            curve: Curves.easeOut);
                      },
                      labelStyle: semititleStyle(),
                      indicatorColor: accentColor,
                      tabs: [Tab(text: "Ingresos"), Tab(text: "Gastos")]),
                ),
                body: Container(
                    child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged: (value) {
                            setState(() {
                              pageIndex = value;
                            });
                            tabController.animateTo(pageIndex);
                          },
                          controller: pageController,
                          children: [
                            incomesPage(movementsProvider),
                            expensesPage(movementsProvider)
                          ],
                        ))),
              ),
              onWillPop: () async {
                movementsProvider.updateMovements();
                return true;
              },
            )));
  }

  Widget headerWidget(int count, MovementType movementType) {
    return Column(
      children: [
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(customMargin),
          padding: EdgeInsets.only(left: customMargin, right: customMargin),
          decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(customBorderRadius)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 65),
              ),
              SpaceDivider(isVertical: true),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movementType == MovementType.INCOME
                        ? "Ingresos realizados"
                        : "Gastos realizados",
                    style: titleCardStyle(),
                  ),
                  Text(
                    buildSubtitleText(),
                    style: semititleStyle(),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ))
            ],
          ),
        ),
      ],
    );
  }

  String buildSubtitleText() {
    if (fromDate == null && toDate == null) {
      return "Desde siempre";
    } else if (fromDate != null && toDate == null) {
      return "Desde el " + Utils.toYMD(fromDate ?? DateTime.now(), context);
    } else if (fromDate == null && toDate != null) {
      return "Dasta el " + Utils.toYMD(toDate ?? DateTime.now(), context);
    } else {
      return "Desde el " +
          Utils.toYMD(fromDate ?? DateTime.now(), context) +
          " hasta el " +
          Utils.toYMD(toDate ?? DateTime.now(), context);
    }
  }

  Widget incomesPage(MovementsChangeNotifier movementsProvider) {
    List<Income> incomeMovements =
        applyFilter(MovementType.INCOME, movementsProvider.incomeList)
            as List<Income>;

    return Column(
      children: [
        headerWidget(incomeMovements.length, MovementType.INCOME),
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 65,
          margin: EdgeInsets.only(left: customMargin, right: customMargin),
          decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(customBorderRadius),
                  topRight: Radius.circular(customBorderRadius))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              Padding(
                  padding: EdgeInsets.only(left: customMargin),
                  child: Text(
                    "Ingresos",
                    style: titleCardStyle(),
                  )),
              LinearDivider()
            ],
          ),
        ),
        Expanded(
            child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(customBorderRadius),
                  bottomRight: Radius.circular(customBorderRadius)),
              color: themeColor.withOpacity(0.1)),
          margin: EdgeInsets.only(
              left: customMargin, right: customMargin, bottom: customMargin),
          child: movementsProvider.incomeList.isEmpty
              ? MovememntEmptyCard(MovementType.INCOME, isExpanded: true)
              : ListView.separated(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  itemBuilder: (context, index) => MovementCard(
                      movement: incomeMovements.elementAt(index),
                      movementsProvider: movementsProvider),
                  separatorBuilder: (context, index) => LinearDivider(),
                  itemCount: incomeMovements.length),
        ))
      ],
    );
  }

  Widget expensesPage(MovementsChangeNotifier movementsProvider) {
    List<Expend> expenseMovements =
        applyFilter(MovementType.EXPEND, movementsProvider.expendList)
            as List<Expend>;

    return Column(
      children: [
        headerWidget(expenseMovements.length, MovementType.EXPEND),
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 65,
          margin: EdgeInsets.only(left: customMargin, right: customMargin),
          decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(customBorderRadius),
                  topRight: Radius.circular(customBorderRadius))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              Padding(
                  padding: EdgeInsets.only(left: customMargin),
                  child: Text(
                    "Gastos",
                    style: titleCardStyle(),
                  )),
              LinearDivider()
            ],
          ),
        ),
        Expanded(
            child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(customBorderRadius),
                  bottomRight: Radius.circular(customBorderRadius)),
              color: themeColor.withOpacity(0.1)),
          margin: EdgeInsets.only(
              left: customMargin, right: customMargin, bottom: customMargin),
          child: movementsProvider.expendList.isEmpty
              ? MovememntEmptyCard(MovementType.EXPEND, isExpanded: true)
              : ListView.separated(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  itemBuilder: (context, index) => MovementCard(
                      movement: expenseMovements.elementAt(index),
                      movementsProvider: movementsProvider),
                  separatorBuilder: (context, index) => LinearDivider(),
                  itemCount: expenseMovements.length),
        ))
      ],
    );
  }

  List<dynamic> applyFilter(
      MovementType movementType, List<dynamic> movementList) {
    switch (movementType) {
      case MovementType.INCOME:
        List<Income> incomeList = movementList as List<Income>;
        if (fromDate != null && toDate == null) {
          incomeList.removeWhere(
              (element) => element.date.isBefore(fromDate ?? DateTime.now()));
        } else if (fromDate == null && toDate != null) {
          incomeList.removeWhere(
              (element) => element.date.isAfter(toDate ?? DateTime.now()));
        } else if (fromDate != null && toDate != null) {
          incomeList.removeWhere((element) =>
              element.date.isBefore(fromDate ?? DateTime.now()) ||
              element.date.isAfter(toDate ?? DateTime.now()));
        }

        if (minValue != null && maxValue == null) {
          incomeList.removeWhere((element) => element.value < minValue);
        } else if (minValue == null && maxValue != null) {
          incomeList.removeWhere((element) => element.value > maxValue);
        } else if (minValue != null && maxValue != null) {
          incomeList.removeWhere((element) =>
              element.value < minValue || element.value > maxValue);
        }

        return incomeList;
      case MovementType.EXPEND:
        List<Expend> expendList = movementList as List<Expend>;
        if (fromDate != null && toDate == null) {
          expendList.removeWhere(
              (element) => element.date.isBefore(fromDate ?? DateTime.now()));
        } else if (fromDate == null && toDate != null) {
          expendList.removeWhere(
              (element) => element.date.isAfter(toDate ?? DateTime.now()));
        } else if (fromDate != null && toDate != null) {
          expendList.removeWhere((element) =>
              element.date.isBefore(fromDate ?? DateTime.now()) ||
              element.date.isAfter(toDate ?? DateTime.now()));
        }

        if (minValue != null && maxValue == null) {
          expendList.removeWhere((element) => element.value < minValue);
        } else if (minValue == null && maxValue != null) {
          expendList.removeWhere((element) => element.value > maxValue);
        } else if (minValue != null && maxValue != null) {
          expendList.removeWhere((element) =>
              element.value < minValue || element.value > maxValue);
        }
        return expendList;
    }
  }
}
