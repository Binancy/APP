// ignore_for_file: no_logic_in_create_state

import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/category.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/movements/movements_empty_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'movement_view.dart';
import 'movements_card_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllMovementView extends StatefulWidget {
  final Category? selectedCategory;
  final int initialPage;
  const AllMovementView({this.initialPage = 0, this.selectedCategory});

  @override
  _AllMovementViewState createState() =>
      _AllMovementViewState(initialPage, selectedCategory);
}

class _AllMovementViewState extends State<AllMovementView>
    with SingleTickerProviderStateMixin {
  DateTime? fromDate, toDate;
  double? minValue, maxValue;
  Category? selectedCategory;

  late PageController pageController;
  late TabController tabController;

  int pageIndex;

  _AllMovementViewState(this.pageIndex, this.selectedCategory);

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: pageIndex);
    tabController =
        TabController(length: 2, vsync: this, initialIndex: pageIndex);
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
        builder: (context, movementsProvider, child) => Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
                title: Text(AppLocalizations.of(context)!.all_movements,
                    style: appBarStyle()),
                bottom: TabBar(
                    controller: tabController,
                    onTap: (value) {
                      pageIndex = value;
                      pageController.animateToPage(pageIndex,
                          duration:
                              const Duration(milliseconds: pageSwapDurationMS),
                          curve: Curves.fastLinearToSlowEaseIn);
                    },
                    labelStyle: semititleStyle(),
                    indicatorColor: accentColor,
                    tabs: [
                      Tab(text: AppLocalizations.of(context)!.income),
                      Tab(text: AppLocalizations.of(context)!.expend)
                    ]),
              ),
              body: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (value) {
                      pageIndex = value;
                      tabController.animateTo(pageIndex);
                    },
                    controller: pageController,
                    children: [
                      incomesPage(movementsProvider),
                      expensesPage(movementsProvider)
                    ],
                  )),
            )));
  }

  Widget headerWidget(int count, MovementType movementType) {
    return Column(
      children: [
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(customMargin),
          padding:
              const EdgeInsets.only(left: customMargin, right: customMargin),
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
              const SpaceDivider(isVertical: true),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movementType == MovementType.INCOME
                        ? AppLocalizations.of(context)!.incomes_realized
                        : AppLocalizations.of(context)!.expends_realized,
                    style: titleCardStyle(),
                  ),
                  selectedCategory != null
                      ? Text(
                          AppLocalizations.of(context)!.category +
                              ": " +
                              selectedCategory!.title,
                          style: semititleStyle())
                      : const SizedBox(),
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
      return AppLocalizations.of(context)!.since_forever;
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
        incomeMovements.isNotEmpty
            ? headerWidget(incomeMovements.length, MovementType.INCOME)
            : selectedCategory != null
                ? headerWidget(incomeMovements.length, MovementType.INCOME)
                : const SizedBox(height: customMargin),
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 65,
          margin:
              const EdgeInsets.only(left: customMargin, right: customMargin),
          decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(customBorderRadius),
                  topRight: Radius.circular(customBorderRadius))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(),
              Padding(
                  padding: const EdgeInsets.only(left: customMargin),
                  child: Text(
                    AppLocalizations.of(context)!.income,
                    style: titleCardStyle(),
                  )),
              const LinearDivider()
            ],
          ),
        ),
        Expanded(
            child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(customBorderRadius),
                  bottomRight: Radius.circular(customBorderRadius)),
              color: themeColor.withOpacity(0.1)),
          margin: const EdgeInsets.only(
              left: customMargin, right: customMargin, bottom: customMargin),
          child: movementsProvider.incomeList.isEmpty
              ? const MovememntEmptyCard(MovementType.INCOME, isExpanded: true)
              : ListView.separated(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  itemBuilder: (_, index) => MovementCard(
                      parentContext: context,
                      movement: incomeMovements.elementAt(index),
                      movementsProvider: movementsProvider),
                  separatorBuilder: (context, index) => const LinearDivider(),
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
        expenseMovements.isNotEmpty
            ? headerWidget(expenseMovements.length, MovementType.EXPEND)
            : selectedCategory != null
                ? headerWidget(expenseMovements.length, MovementType.EXPEND)
                : const SizedBox(height: customMargin),
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 65,
          margin:
              const EdgeInsets.only(left: customMargin, right: customMargin),
          decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(customBorderRadius),
                  topRight: Radius.circular(customBorderRadius))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(),
              Padding(
                  padding: const EdgeInsets.only(left: customMargin),
                  child: Text(
                    AppLocalizations.of(context)!.expend,
                    style: titleCardStyle(),
                  )),
              const LinearDivider()
            ],
          ),
        ),
        Expanded(
            child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(customBorderRadius),
                  bottomRight: Radius.circular(customBorderRadius)),
              color: themeColor.withOpacity(0.1)),
          margin: const EdgeInsets.only(
              left: customMargin, right: customMargin, bottom: customMargin),
          child: movementsProvider.expendList.isEmpty
              ? const MovememntEmptyCard(MovementType.EXPEND, isExpanded: true)
              : ListView.separated(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  itemBuilder: (_, index) => MovementCard(
                      parentContext: context,
                      movement: expenseMovements.elementAt(index),
                      movementsProvider: movementsProvider),
                  separatorBuilder: (context, index) => const LinearDivider(),
                  itemCount: expenseMovements.length),
        ))
      ],
    );
  }

  List<dynamic> applyFilter(
      MovementType movementType, List<dynamic> movementList) {
    switch (movementType) {
      case MovementType.INCOME:
        List<Income> incomeList = List.from(movementList);
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

        if (selectedCategory != null) {
          incomeList.removeWhere((element) {
            if (element.category != null) {
              return element.category!.idCategory !=
                  selectedCategory!.idCategory;
            }
            return true;
          });
        }

        return incomeList;
      case MovementType.EXPEND:
        List<Expend> expendList = List.from(movementList);
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

        if (selectedCategory != null) {
          expendList.removeWhere((element) {
            if (element.category != null) {
              return element.category!.idCategory !=
                  selectedCategory!.idCategory;
            }
            return true;
          });
        }
        return expendList;
    }
  }
}
