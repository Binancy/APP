import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/microexpenses_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/controllers/providers/plans_change_notifier.dart';
import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/enums.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/microexpenses/microexpenses_view.dart';
import 'package:binancy/views/movements/movements_all_view.dart';
import 'package:binancy/views/movements/movement_view.dart';
import 'package:binancy/views/movements/movments_balance_view.dart';
import 'package:binancy/views/payments/donations_view.dart';
import 'package:binancy/views/payments/premium_plans_view.dart';
import 'package:binancy/views/savings_plan/savings_plans_all_view.dart';
import 'package:binancy/views/settings/settings_view.dart';
import 'package:binancy/views/subscriptions/subscriptions_all_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'dashboard_action_button_widget.dart';

class DashboardActionsCard extends StatefulWidget {
  @override
  _DashboardActionsCardState createState() => _DashboardActionsCardState();
}

class _DashboardActionsCardState extends State<DashboardActionsCard> {
  List<double> opacityValueList = [];
  List<ActionButtonWidget> actionsList = [];
  List<Widget> pageList = [];

  bool firstRun = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (firstRun) {
      clearLists();
      buildActions();
      buildPageList(context);
      opacityValueList = List.filled(pageList.length, 0.25);
      opacityValueList[0] = 1;
      firstRun = false;
    }

    return Column(
      children: [
        Text(
          '¿Que quieres hacer?',
          style: titleCardStyle(),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
            height: (MediaQuery.of(context).size.height / 10 * 2.75),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(customBorderRadius),
              color: themeColor.withOpacity(0.1),
            ),
            margin:
                const EdgeInsets.only(left: customMargin, right: customMargin),
            child: Column(
              children: [
                SizedBox(
                    height: (MediaQuery.of(context).size.height / 10 * 2.5),
                    child: PageView(
                      onPageChanged: (value) => updatePointers(value),
                      children: pageList,
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 150, right: 150),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: buildPointers(),
                    ))
              ],
            ))
      ],
    );
  }

  Widget buildEmptyActionWidget(BuildContext context) {
    return SizedBox(
        height: (MediaQuery.of(context).size.height / 10) + 3,
        width: (MediaQuery.of(context).size.height / 8));
  }

  void updatePointers(int value) {
    for (var i = 0; i < opacityValueList.length; i++) {
      opacityValueList[i] = 0.25;
    }

    setState(() {
      opacityValueList[value] = 1;
    });
  }

  void buildPageList(BuildContext context) {
    double numPages = Utils.roundDown(actionsList.length / 6, 0);
    if (actionsList.length % 6 != 0) {
      numPages++;
    }

    for (var i = 0; i < numPages; i++) {
      List<Widget> pageActions = [];
      for (var j = 0; j < 6; j++) {
        try {
          pageActions.add(actionsList.elementAt((6 * i) + j));
        } catch (e) {
          pageActions.add(buildEmptyActionWidget(context));
        }
      }
      pageList.add(Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              pageActions.elementAt(0),
              pageActions.elementAt(1),
              pageActions.elementAt(2)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              pageActions.elementAt(3),
              pageActions.elementAt(4),
              pageActions.elementAt(5)
            ],
          )
        ],
      ));
    }
  }

  void buildActions() {
    actionsList.add(ActionButtonWidget(
        context: context,
        icon: SvgPicture.asset("assets/svg/dashboard_add_income.svg"),
        text: "Añade un ingreso",
        action: () => Navigator.push(
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
                      child: const MovementView(
                        allowEdit: true,
                        movementType: MovementType.INCOME,
                      ),
                    )))));
    actionsList.add(ActionButtonWidget(
        context: context,
        icon: SvgPicture.asset("assets/svg/dashboard_compare.svg"),
        text: "Mi cuenta",
        action: () => Navigator.push(
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
                              Provider.of<SubscriptionsChangeNotifier>(context),
                        ),
                        ChangeNotifierProvider(
                          create: (_) =>
                              Provider.of<SavingsPlanChangeNotifier>(context),
                        ),
                        ChangeNotifierProvider(
                          create: (_) =>
                              Provider.of<CategoriesChangeNotifier>(context),
                        )
                      ],
                      child: MovementBalanceView(),
                    )))));
    actionsList.add(ActionButtonWidget(
        context: context,
        icon: SvgPicture.asset("assets/svg/dashboard_add_expense.svg"),
        text: "Añade un gasto",
        action: () => Navigator.push(
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
                      child: const MovementView(
                        allowEdit: true,
                        movementType: MovementType.EXPEND,
                      ),
                    )))));
    actionsList.add(ActionButtonWidget(
        context: context,
        icon: SvgPicture.asset("assets/svg/dashboard_categories.svg"),
        text: "Ver categorías",
        action: () {}));
    actionsList.add(ActionButtonWidget(
        context: context,
        icon: SvgPicture.asset("assets/svg/dashboard_see_movements.svg"),
        text: "Todos mis movimientos",
        action: () => Navigator.push(
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
                child: const AllMovementView(),
              ),
            ))));
    actionsList.add(ActionButtonWidget(
        context: context,
        icon: SvgPicture.asset("assets/svg/dashboard_coins.svg"),
        text: "Gastos rápidos",
        action: () async {
          if (Utils.isPremium()) {
            MicroExpensesChangeNotifier microExpensesChangeNotifier =
                MicroExpensesChangeNotifier();
            await microExpensesChangeNotifier.updateMicroExpenses();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MultiProvider(providers: [
                          ChangeNotifierProvider(
                              create: (_) => microExpensesChangeNotifier),
                          ChangeNotifierProvider(
                              create: (_) =>
                                  Provider.of<MovementsChangeNotifier>(context))
                        ], child: MicroExpensesView())));
          } else {
            lockedAction();
          }
        }));
    actionsList.add(ActionButtonWidget(
        context: context,
        icon: SvgPicture.asset("assets/svg/dashboard_vault.svg"),
        text: "Metas de ahorro",
        action: () => Utils.isPremium()
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                              create: (_) =>
                                  Provider.of<SavingsPlanChangeNotifier>(
                                      context),
                            ),
                            ChangeNotifierProvider(
                              create: (_) =>
                                  Provider.of<MovementsChangeNotifier>(context),
                            )
                          ],
                          child: SavingsPlanAllView(),
                        )))
            : lockedAction()));
    actionsList.add(ActionButtonWidget(
        context: context,
        icon: SvgPicture.asset("assets/svg/dashboard_historial.svg"),
        text: "Tus suscripciones",
        action: () => Utils.isPremium()
            ? Navigator.push(
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
                        )))
            : lockedAction()));
    actionsList.add(ActionButtonWidget(
        context: context,
        icon: SvgPicture.asset("assets/svg/dashboard_advices.svg"),
        text: "Ayudas y consejos",
        action: () {}));
    if (Utils.showIfPlanIsEqualOrLower(userData['idPlan'], "binancy")) {
      actionsList.add(ActionButtonWidget(
          context: context,
          icon: SvgPicture.asset("assets/svg/dashboard_premium.svg"),
          text: "Hazte premium",
          action: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MultiProvider(providers: [
                        ChangeNotifierProvider(
                            create: (_) =>
                                Provider.of<PlansChangeNotifier>(context))
                      ], child: const PremiumPlansView())))));
    } else {
      actionsList.add(ActionButtonWidget(
          context: context,
          icon: SvgPicture.asset("assets/svg/dashboard_premium.svg"),
          text: "Haz una donación",
          action: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MultiProvider(providers: [
                        ChangeNotifierProvider(
                            create: (_) =>
                                Provider.of<PlansChangeNotifier>(context))
                      ], child: const DonationView())))));
    }
    actionsList.add(ActionButtonWidget(
        context: context,
        icon: SvgPicture.asset("assets/svg/dashboard_settings.svg"),
        text: "Ajustes",
        action: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MultiProvider(providers: [
                      ChangeNotifierProvider(
                          create: (_) =>
                              Provider.of<PlansChangeNotifier>(context))
                    ], child: SettingsView())))));
  }

  Future<dynamic> lockedAction() {
    return showCupertinoModalBottomSheet(
        context: context,
        barrierColor: themeColor.withOpacity(0.65),
        builder: (_) => Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              padding: const EdgeInsets.all(customMargin),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Esta es una función premium",
                          style: headerItemView(), textAlign: TextAlign.center),
                      const SpaceDivider(),
                      Text(
                          "Para utilizar esta función debes adquirir uno de los planes premium que Binancy obtiene",
                          style: accentStyle(),
                          textAlign: TextAlign.center)
                    ],
                  ),
                  const SpaceDivider(),
                  BinancyButton(
                      context: context,
                      text: "Hazte premium",
                      action: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MultiProvider(providers: [
                                      ChangeNotifierProvider(
                                          create: (_) =>
                                              Provider.of<PlansChangeNotifier>(
                                                  context))
                                    ], child: const PremiumPlansView())));
                      })
                ],
              ),
            ));
  }

  List<Widget> buildPointers() {
    List<Widget> pointersList = [];
    for (var i = 0; i < pageList.length; i++) {
      pointersList.add(AnimatedOpacity(
          opacity: opacityValueList[i],
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: opacityAnimationDurationMS),
          child: const Icon(Icons.circle, color: Colors.white, size: 10)));
    }

    return pointersList;
  }

  void clearLists() {
    actionsList.clear();
    pageList.clear();
  }
}
