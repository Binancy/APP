import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/views/advice/advice_card.dart';
import 'package:binancy/views/categories/category_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CategorySummaryView extends StatefulWidget {
  const CategorySummaryView({Key? key}) : super(key: key);

  @override
  State<CategorySummaryView> createState() => _CategorySummaryViewState();
}

class _CategorySummaryViewState extends State<CategorySummaryView> {
  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Categorías", style: appBarStyle()),
      ),
      body: Consumer2<CategoriesChangeNotifier, MovementsChangeNotifier>(
          builder: (context, categoriesChangeNotifier, movementsChangeNotifier,
                  child) =>
              FutureBuilder(
                future: getCategoryMovemntsFromLast90Days(
                    categoriesChangeNotifier, movementsChangeNotifier),
                builder: (context, snapshot) => ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    children: [
                      const SpaceDivider(),
                      AdviceCard(
                          icon: SvgPicture.asset(
                              "assets/svg/dashboard_categories.svg"),
                          text:
                              "Visualiza todos los movimientos de los últimos 90 días clasificados en categorías"),
                      const SpaceDivider(),
                      Center(
                          child:
                              Text("Tus categorías", style: titleCardStyle())),
                      Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              color: themeColor.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(customBorderRadius)),
                          margin: const EdgeInsets.all(customMargin),
                          child: Column(
                            children: [
                              ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) => CategoryCardWidget(
                                      category: categoriesChangeNotifier
                                          .categoryList
                                          .elementAt(index),
                                      context: context),
                                  separatorBuilder: (context, index) =>
                                      const LinearDivider(),
                                  itemCount: categoriesChangeNotifier
                                              .categoryList.length >
                                          categoryMaxItemsToShow
                                      ? categoryMaxItemsToShow
                                      : categoriesChangeNotifier
                                          .categoryList.length),
                              categoriesChangeNotifier.categoryList.length >
                                      categoryMaxItemsToShow
                                  ? Column(
                                      children: [
                                        const LinearDivider(),
                                        Material(
                                          color: Colors.transparent,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: InkWell(
                                            highlightColor:
                                                themeColor.withOpacity(0.1),
                                            splashColor:
                                                themeColor.withOpacity(0.1),
                                            onTap: () {},
                                            child: SizedBox(
                                                height: buttonHeight,
                                                child: Center(
                                                    child: Text(
                                                        "Ver todas tus categorías",
                                                        style: buttonStyle()))),
                                          ),
                                        )
                                      ],
                                    )
                                  : const SizedBox()
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: customMargin, right: customMargin),
                        child: BinancyButton(
                            context: context,
                            text: "Añade una categoría",
                            action: () {}),
                      )
                    ],
                  ),
                ),
              )),
    ));
  }

  Future<void> getCategoryMovemntsFromLast90Days(
      CategoriesChangeNotifier categoriesChangeNotifier,
      MovementsChangeNotifier movementsChangeNotifier) async {
    // CLASSIFY ALL INCOMES FROM THE LAST 90 DAYS

    for (var income in movementsChangeNotifier.incomeList) {
      if (income.date.difference(Utils.getTodayDate()) <
          const Duration(days: 90)) {
        if (income.category != null) {
          for (var category in categoriesChangeNotifier.categoryList) {
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
          for (var category in categoriesChangeNotifier.categoryList) {
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
}
