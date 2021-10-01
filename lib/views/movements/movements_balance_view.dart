import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/controllers/subscriptions_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/savings_plan.dart';
import 'package:binancy/models/subscription.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/movements/movements_card_widget.dart';
import 'package:binancy/views/movements/movements_empty_card_widget.dart';
import 'package:binancy/views/payments/premium_ad_widget.dart';
import 'package:binancy/views/savings_plan/savings_plan_empty_widget.dart';
import 'package:binancy/views/savings_plan/savings_plan_widget.dart';
import 'package:binancy/views/subscriptions/subscription_card_widget.dart';
import 'package:binancy/views/subscriptions/subscription_empty_card_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'movement_view.dart';

class MovementBalanceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Consumer4<
            MovementsChangeNotifier,
            CategoriesChangeNotifier,
            SubscriptionsChangeNotifier,
            SavingsPlanChangeNotifier>(
        builder: (context, movementsProvider, categoriesProvider,
                subscriptionsProvider, savingsPlanProvider, child) =>
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(AppLocalizations.of(context)!.my_account,
                    style: appBarStyle()),
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
                                child: Text(
                                    AppLocalizations.of(context)!
                                        .latests_balances,
                                    style: titleCardStyle())),
                        movementsProvider.totalHeritage == 0
                            ? const SizedBox()
                            : barChart(context, movementsProvider),
                        movementsProvider.totalHeritage == 0
                            ? const SizedBox()
                            : const SpaceDivider(),
                        Center(
                            child: Text(
                                AppLocalizations.of(context)!.latests_movements,
                                style: titleCardStyle())),
                        latestsIncomes(context, movementsProvider),
                        latestsExpenses(context, movementsProvider),
                        for (var i in premiumWidgets(context, movementsProvider,
                            subscriptionsProvider, savingsPlanProvider))
                          Utils.isPremium() ? i : const SizedBox(),
                        Utils.isPremium()
                            ? const SizedBox()
                            : const PremiumAdWidget()
                      ])),
            )));
  }

  Widget latestsExpenses(
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
        children:
            getLatestMovements(context, MovementType.EXPEND, movementsProvider),
      ),
    );
  }

  Widget latestsIncomes(
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
        children:
            getLatestMovements(context, MovementType.INCOME, movementsProvider),
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
                      AppLocalizations.of(context)!.income,
                      style: inputStyle(),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white.withOpacity(0.25)),
                    const SpaceDivider(isVertical: true, customSpace: 10),
                    Text(
                      AppLocalizations.of(context)!.expend,
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
              Text(AppLocalizations.of(context)!.my_heritage,
                  style: accentTitleStyle()),
              Text(Utils.parseAmount(movementsProvider.totalHeritage),
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
              text: AppLocalizations.of(context)!.see_all_movements,
              action: () {}),
        )
      ],
    );
  }

  Widget subscriptionsCard(BuildContext context,
      SubscriptionsChangeNotifier subscriptionsChangeNotifier) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.only(left: customMargin, right: customMargin),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) =>
              getSubscriptions(context, subscriptionsChangeNotifier)
                  .elementAt(index),
          separatorBuilder: (context, index) => const LinearDivider(),
          itemCount:
              getSubscriptions(context, subscriptionsChangeNotifier).length),
    );
  }

  Widget savingsPlanCard(
      BuildContext context,
      SavingsPlanChangeNotifier savingsPlanChangeNotifier,
      double currentAmount) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.only(left: customMargin, right: customMargin),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) =>
              getSavingsPlan(context, savingsPlanChangeNotifier, currentAmount)
                  .elementAt(index),
          separatorBuilder: (context, index) => const LinearDivider(),
          itemCount:
              getSavingsPlan(context, savingsPlanChangeNotifier, currentAmount)
                  .length),
    );
  }

  List<Widget> premiumWidgets(
      BuildContext context,
      MovementsChangeNotifier movementsChangeNotifier,
      SubscriptionsChangeNotifier subscriptionsChangeNotifier,
      SavingsPlanChangeNotifier savingsPlanChangeNotifier) {
    List<Widget> premiumWidgetList = [];
    premiumWidgetList.add(const SpaceDivider());
    premiumWidgetList.add(Center(
        child: Text(AppLocalizations.of(context)!.premium_features,
            style: titleCardStyle())));
    premiumWidgetList.add(const SpaceDivider());

    premiumWidgetList
        .add(subscriptionsCard(context, subscriptionsChangeNotifier));
    premiumWidgetList.add(const SpaceDivider());
    premiumWidgetList.add(savingsPlanCard(context, savingsPlanChangeNotifier,
        movementsChangeNotifier.totalHeritage));

    return premiumWidgetList;
  }

  List<Widget> getLatestMovements(
      BuildContext context,
      MovementType movementType,
      MovementsChangeNotifier movementsChangeNotifier) {
    List<Widget> listMovementsWidget = [];
    List<dynamic> providerList = movementType == MovementType.INCOME
        ? movementsChangeNotifier.incomeList
        : movementsChangeNotifier.expendList;

    listMovementsWidget.add(Padding(
        padding: const EdgeInsets.only(
            top: customMargin, left: customMargin, bottom: customMargin),
        child: Text(
            movementType == MovementType.INCOME
                ? AppLocalizations.of(context)!.income
                : AppLocalizations.of(context)!.expend,
            style: titleCardStyle())));
    listMovementsWidget.add(const LinearDivider());
    if (providerList.isEmpty) {
      listMovementsWidget.add(MovememntEmptyCard(movementType));
    } else {
      if (providerList.length > balanceMaxItemsPerCategory) {
        for (var i = 0; i < latestMovementsMaxCount; i++) {
          listMovementsWidget.add(MovementCard(
              parentContext: context,
              movement: providerList.elementAt(i),
              movementsProvider: movementsChangeNotifier));
          if (i != latestMovementsMaxCount - 1) {
            listMovementsWidget.add(const LinearDivider());
          }
        }
      } else {
        for (var i = 0; i < providerList.length; i++) {
          listMovementsWidget.add(MovementCard(
              parentContext: context,
              movement: providerList.elementAt(i),
              movementsProvider: movementsChangeNotifier));
          if (i != providerList.length - 1) {
            listMovementsWidget.add(const LinearDivider());
          }
        }
      }
    }
    return listMovementsWidget;
  }

  List<String> generateBalanceChartTitles(BuildContext context) {
    List<String> chartTitles = [];

    DateTime today = Utils.getTodayDate();
    for (var i = 0; i < balanceChartMaxMonths; i++) {
      DateTime payDayMonth = Utils.getStartMonthByPayDay(
          DateTime(today.year, today.month - i, today.day));
      Month month = Utils.getMonthNameOfPayDay(payDayMonth);

      if (month.index > payDayMonth.month) {
        payDayMonth = Utils.getStartMonthByPayDay(
            DateTime(today.year, today.month - (i - 1), today.day));
      }
      chartTitles.add(Utils.toMY(payDayMonth, context));
    }
    return chartTitles;
  }

  List<BarChartGroupData> buildBarCharts(
      BuildContext context, MovementsChangeNotifier movementsChangeNotifier) {
    List<BarChartGroupData> barChartList = [];
    List<String> chartTitles = generateBalanceChartTitles(context);

    for (var i = 0; i < balanceChartMaxMonths; i++) {
      DateTime parsedDate = Utils.fromMY(chartTitles[i], context);
      DateTime startMonth = DateTime(
          parsedDate.year,
          parsedDate.month - 1,
          Utils.getPayDayOfMonth(
              DateTime(parsedDate.year, parsedDate.month - 1)));
      double monthIncomes = movementsChangeNotifier.getMonthIncomes(startMonth);
      double monthExpends = movementsChangeNotifier.getMonthExpends(startMonth);
      barChartList.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
            y: monthIncomes, colors: [accentColor], width: barChartWidth),
        BarChartRodData(
            y: monthExpends,
            colors: [Colors.white.withOpacity(0.25)],
            width: barChartWidth)
      ]));
    }
    return List.from(barChartList.reversed);
  }

  List<Widget> getSubscriptions(BuildContext context,
      SubscriptionsChangeNotifier subscriptionsChangeNotifier) {
    List<Widget> subscriptionsWidgetList = [];
    subscriptionsWidgetList.add(Padding(
        padding: const EdgeInsets.only(
            top: customMargin, left: customMargin, bottom: customMargin),
        child: Text(AppLocalizations.of(context)!.subscription,
            style: titleCardStyle())));
    subscriptionsWidgetList.add(const LinearDivider());
    if (subscriptionsChangeNotifier.subscriptionsList.isNotEmpty) {
      if (subscriptionsChangeNotifier.subscriptionsList.length >
          balanceMaxItemsPerCategory) {
        for (var i = 0; i < balanceMaxItemsPerCategory; i++) {
          Subscription subscription =
              subscriptionsChangeNotifier.subscriptionsList.elementAt(i);
          subscriptionsWidgetList.add(SubscriptionCard(
              parentContext: context,
              subscription: subscription,
              subscriptionsChangeNotifier: subscriptionsChangeNotifier));
        }
      } else {
        for (var subscription
            in subscriptionsChangeNotifier.subscriptionsList) {
          subscriptionsWidgetList.add(SubscriptionCard(
              parentContext: context,
              subscription: subscription,
              subscriptionsChangeNotifier: subscriptionsChangeNotifier));
        }
      }
    } else {
      subscriptionsWidgetList.add(const SubscriptionEmptyCard());
    }

    return subscriptionsWidgetList;
  }

  List<Widget> getSavingsPlan(
      BuildContext context,
      SavingsPlanChangeNotifier savingsPlanChangeNotifier,
      double currentAmount) {
    List<Widget> savingsPlanWidgetList = [];
    savingsPlanWidgetList.add(Padding(
        padding: const EdgeInsets.only(
            top: customMargin, left: customMargin, bottom: customMargin),
        child: Text(AppLocalizations.of(context)!.goals,
            style: titleCardStyle())));
    savingsPlanWidgetList.add(const LinearDivider());
    if (savingsPlanChangeNotifier.savingsPlanList.isNotEmpty) {
      if (savingsPlanChangeNotifier.savingsPlanList.length >
          balanceMaxItemsPerCategory) {
        for (var i = 0; i < balanceMaxItemsPerCategory; i++) {
          SavingsPlan savingsPlan =
              savingsPlanChangeNotifier.savingsPlanList.elementAt(i);
          savingsPlanWidgetList.add(SavingsPlanWidget(
              context, savingsPlan, savingsPlanChangeNotifier, currentAmount));
        }
      } else {
        for (var savingsPlan in savingsPlanChangeNotifier.savingsPlanList) {
          savingsPlanWidgetList.add(SavingsPlanWidget(
              context, savingsPlan, savingsPlanChangeNotifier, currentAmount));
        }
      }
    } else {
      savingsPlanWidgetList.add(const SavingsPlanEmptyWidget());
    }
    return savingsPlanWidgetList;
  }
}
