import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/views/advice/advice_card.dart';
import 'package:binancy/views/categories/category_card_widget.dart';
import 'package:binancy/views/categories/category_view.dart';
import 'package:binancy/views/movements/movement_view.dart';
import 'package:binancy/views/movements/movements_empty_card_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'category_indicator_widget.dart';

class CategorySummaryView extends StatefulWidget {
  const CategorySummaryView({Key? key}) : super(key: key);

  @override
  State<CategorySummaryView> createState() => _CategorySummaryViewState();
}

class _CategorySummaryViewState extends State<CategorySummaryView> {
  late FlipCardController flipCardController;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    flipCardController = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    return BinancyBackground(
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text("Categorías", style: appBarStyle()),
          ),
          body: Consumer2<CategoriesChangeNotifier, MovementsChangeNotifier>(
            builder: (context, categoriesChangeNotifier,
                movementsChangeNotifier, child) {
              getCategoryMovemntsFromLast90Days(
                  categoriesChangeNotifier, movementsChangeNotifier);
              return ScrollConfiguration(
                behavior: MyBehavior(),
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    const SliverToBoxAdapter(child: SpaceDivider()),
                    SliverToBoxAdapter(
                        child: AdviceCard(
                            icon: SvgPicture.asset(
                                "assets/svg/dashboard_categories.svg"),
                            text:
                                "Visualiza todos los movimientos de los últimos 90 días clasificados en categorías")),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Positioned(
                              child: categoriesPieChart(
                                  context,
                                  categoriesChangeNotifier,
                                  movementsChangeNotifier),
                            ),
                            Positioned(
                                right: customMargin * 2,
                                top: customMargin * 2,
                                child: Material(
                                  color: accentColor,
                                  borderRadius:
                                      BorderRadius.circular(customBorderRadius),
                                  child: InkWell(
                                    onTap: () =>
                                        flipCardController.toggleCard(),
                                    child: const SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                        child: Icon(Icons.swipe,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                          child:
                              Text("Tus categorías", style: titleCardStyle())),
                    ),
                    SliverToBoxAdapter(
                        child: categoryListWidget(
                            categoriesChangeNotifier, context)),
                    SliverToBoxAdapter(child: addCategoryButton(context)),
                    const SliverToBoxAdapter(child: SpaceDivider())
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget categoriesPieChart(
      BuildContext context,
      CategoriesChangeNotifier categoriesChangeNotifier,
      MovementsChangeNotifier movementsChangeNotifier) {
    return Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              kToolbarHeight -
              (customMargin * 4) -
              adviceCardMinHeight,
        ),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(customMargin),
        padding: const EdgeInsets.all(customMargin),
        decoration: BoxDecoration(
            color: themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(customBorderRadius)),
        child: FlipCard(
            alignment: Alignment.topCenter,
            controller: flipCardController,
            flipOnTouch: false,
            front: movementsChangeNotifier.incomeList.isNotEmpty
                ? ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Center(
                        child: Text(AppLocalizations.of(context)!.income,
                            style: titleCardStyle()),
                      ),
                      const SpaceDivider(customSpace: 40),
                      SizedBox(
                        height: MediaQuery.of(context).size.width -
                            (customMargin * 4),
                        child: PieChart(
                            PieChartData(
                                centerSpaceRadius: 100,
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                startDegreeOffset: 270,
                                sectionsSpace: categoriesSectionsMargin,
                                sections: categoriesToSections(
                                    categoriesChangeNotifier,
                                    MovementType.INCOME)),
                            swapAnimationDuration:
                                const Duration(milliseconds: 500),
                            swapAnimationCurve: Curves.easeInOut),
                      ),
                      const SpaceDivider(customSpace: 20),
                      generateLegend(
                          categoriesChangeNotifier, MovementType.INCOME)
                    ],
                  )
                : const MovememntEmptyCard(MovementType.EXPEND,
                    isExpanded: true),
            back: movementsChangeNotifier.expendList.isNotEmpty
                ? ListView(
                    shrinkWrap: true,
                    children: [
                      Center(
                        child: Text(AppLocalizations.of(context)!.expend,
                            style: titleCardStyle()),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width,
                        child: PieChart(
                            PieChartData(
                                centerSpaceRadius: 100,
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                startDegreeOffset: 270,
                                sectionsSpace: categoriesSectionsMargin,
                                sections: categoriesToSections(
                                    categoriesChangeNotifier,
                                    MovementType.EXPEND)),
                            swapAnimationDuration:
                                const Duration(milliseconds: 500), // Optional
                            swapAnimationCurve: Curves.easeInOut),
                      ),
                      generateLegend(
                          categoriesChangeNotifier, MovementType.EXPEND)
                    ],
                  )
                : const MovememntEmptyCard(MovementType.EXPEND,
                    isExpanded: true)));
  }

  Widget addCategoryButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: customMargin, right: customMargin),
      child: BinancyButton(
          context: context,
          text: "Añade una categoría",
          action: () => Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) =>
                            Provider.of<CategoriesChangeNotifier>(context),
                      )
                    ],
                    child: const CategoryView(allowEdit: true),
                  )))),
    );
  }

  Widget categoryListWidget(
      CategoriesChangeNotifier categoriesChangeNotifier, BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            color: themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(customBorderRadius)),
        margin: const EdgeInsets.all(customMargin),
        child: Column(
          children: [
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, index) => CategoryCardWidget(
                    category: categoryList.elementAt(index),
                    context: context,
                    categoriesChangeNotifier: categoriesChangeNotifier),
                separatorBuilder: (context, index) => const LinearDivider(),
                itemCount: categoryList.length > categoryMaxItemsToShow
                    ? categoryMaxItemsToShow
                    : categoryList.length),
            categoryList.length > categoryMaxItemsToShow
                ? Column(
                    children: [
                      const LinearDivider(),
                      Material(
                        color: Colors.transparent,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: InkWell(
                          highlightColor: themeColor.withOpacity(0.1),
                          splashColor: themeColor.withOpacity(0.1),
                          onTap: () {},
                          child: SizedBox(
                              height: buttonHeight,
                              child: Center(
                                  child: Text("Ver todas tus categorías",
                                      style: buttonStyle()))),
                        ),
                      )
                    ],
                  )
                : const SizedBox()
          ],
        ));
  }

  List<PieChartSectionData> categoriesToSections(
      CategoriesChangeNotifier categoriesChangeNotifier,
      MovementType movementType) {
    List<PieChartSectionData> pieChartSections = [];
    if (movementType == MovementType.INCOME) {
      for (var category in categoryList) {
        if (category.categoryIncomes.isNotEmpty) {
          double totalAmount = 0;
          for (var movement in category.categoryIncomes) {
            totalAmount += movement.value;
          }
          pieChartSections.add(PieChartSectionData(
              value: totalAmount,
              color: category.color,
              showTitle: false,
              title: category.title +
                  "\n" +
                  Utils.parseAmount(
                      category.getTotalAmountOfThisCategoryMovements()),
              borderSide:
                  BorderSide(width: 10, color: themeColor.withOpacity(0.1)),
              radius: categoriesPieChartRadius));
        }
      }

      pieChartSections.add(remainingMovementsWithoutCategory(
          categoriesChangeNotifier.incomesWithoutCategory));
    } else {
      for (var category in categoryList) {
        if (category.categoryExpenses.length > 1) {
          double totalAmount = 0;
          for (var movement in category.categoryExpenses) {
            totalAmount += movement.value;
          }
          pieChartSections.add(PieChartSectionData(
              value: totalAmount,
              showTitle: false,
              radius: categoriesPieChartRadius,
              title: category.title));
        }
      }

      pieChartSections.add(remainingMovementsWithoutCategory(
          categoriesChangeNotifier.expensesWithoutCategory));
    }
    return pieChartSections;
  }

  PieChartSectionData remainingMovementsWithoutCategory(
      List<dynamic> movementsWithoutCategory) {
    double totalAmount = 0;
    for (var movement in movementsWithoutCategory) {
      totalAmount += movement.value;
    }

    return (PieChartSectionData(
        value: totalAmount,
        showTitle: false,
        borderSide: BorderSide(color: themeColor.withOpacity(0.1), width: 10),
        title: "Sin categorizar",
        radius: categoriesPieChartRadius,
        color: Colors.grey));
  }

  Future<void> getCategoryMovemntsFromLast90Days(
      CategoriesChangeNotifier categoriesChangeNotifier,
      MovementsChangeNotifier movementsChangeNotifier) async {
    resetData(categoriesChangeNotifier);

    for (var income in movementsChangeNotifier.incomeList) {
      if (income.date.difference(Utils.getTodayDate()) <
          const Duration(days: 90)) {
        if (income.category != null) {
          for (var category in categoryList) {
            if (category.idCategory == income.category!.idCategory) {
              category.categoryIncomes.add(income);
            }
          }
        } else {
          categoriesChangeNotifier.incomesWithoutCategory.add(income);
        }
      }
    }

    // CLASSIFY ALL EXPENSES FROM THE LAST 90 DAYS

    for (var expend in movementsChangeNotifier.expendList) {
      if (expend.date.difference(Utils.getTodayDate()) <
          const Duration(days: 90)) {
        if (expend.category != null) {
          for (var category in categoryList) {
            if (category.idCategory == expend.category!.idCategory) {
              category.categoryExpenses.add(expend);
            }
          }
        } else {
          categoriesChangeNotifier.expensesWithoutCategory.add(expend);
        }
      }
    }
  }

  void resetData(CategoriesChangeNotifier categoriesChangeNotifier) {
    categoriesChangeNotifier.expensesWithoutCategory = [];
    categoriesChangeNotifier.incomesWithoutCategory = [];
    for (var category in categoryList) {
      category.categoryExpenses = [];
      category.categoryIncomes = [];
    }
  }

  Widget generateLegend(CategoriesChangeNotifier categoriesChangeNotifier,
      MovementType movementType) {
    List<Widget> categoryIndicators = [];
    if (movementType == MovementType.INCOME) {
      for (var category in categoryList) {
        if (category.categoryIncomes.isNotEmpty) {
          categoryIndicators.add(Indicator(
            color: category.color,
            isSquare: false,
            text: category.title,
            size: 20,
            textColor: textColor,
          ));
        }
      }

      if (categoriesChangeNotifier.incomesWithoutCategory.isNotEmpty) {
        categoryIndicators.add(Indicator(
          color: Colors.grey,
          isSquare: false,
          text: "Sin categorizar",
          size: 20,
          textColor: textColor,
        ));
      }
    } else {
      for (var category in categoryList) {
        if (category.categoryExpenses.length > 1) {
          categoryIndicators.add(Indicator(
            color: category.color,
            isSquare: false,
            text: category.title,
            size: 20,
            textColor: textColor,
          ));
        }
      }

      if (categoriesChangeNotifier.expensesWithoutCategory.isNotEmpty) {
        categoryIndicators.add(Indicator(
          color: Colors.grey,
          isSquare: false,
          text: "Sin categorizar",
          size: 20,
          textColor: textColor,
        ));
      }
    }

    List<Widget> rowWidgets = [];
    int count = 0;
    for (var indicator in categoryIndicators) {
      count++;
      if (count == 1 && rowWidgets.isNotEmpty) {
        rowWidgets.add(const SpaceDivider(customSpace: 10));
      } else if (count == 2) {
        rowWidgets.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              categoryIndicators
                  .elementAt(categoryIndicators.indexOf(indicator) - 1),
              indicator
            ]));
        count = 0;
      }
    }

    if (count == 1) {
      rowWidgets.add(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [categoryIndicators.last],
      ));
    }

    return Column(
        children: rowWidgets,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min);
  }
}
