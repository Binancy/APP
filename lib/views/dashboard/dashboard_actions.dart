import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/enums.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/views/movements/movements_all_view.dart';
import 'package:binancy/views/movements/movement_view.dart';
import 'package:binancy/views/movements/movments_balance_view.dart';
import 'package:binancy/views/subscriptions/subscriptions_all_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DashboardActionsCard extends StatefulWidget {
  @override
  _DashboardActionsCardState createState() => _DashboardActionsCardState();
}

class _DashboardActionsCardState extends State<DashboardActionsCard> {
  List<double> opacityValueList = [1, 0.25];
  List<Widget> pointersList = [];
  int opacityAnimationDurationMS = 500;

  @override
  Widget build(BuildContext context) {
    pointersList.clear();
    for (var i = 0; i < opacityValueList.length; i++) {
      pointersList.add(AnimatedOpacity(
          opacity: opacityValueList[i],
          duration: Duration(milliseconds: opacityAnimationDurationMS),
          child: Icon(Icons.circle, color: Colors.white, size: 10)));
    }

    return Column(
      children: [
        Text(
          '¿Que quieres hacer?',
          style: titleCardStyle(),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            height: (MediaQuery.of(context).size.height / 10 * 2.75),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(customBorderRadius),
              color: themeColor.withOpacity(0.1),
            ),
            margin: EdgeInsets.only(left: customMargin, right: customMargin),
            child: Column(
              children: [
                Container(
                    height: (MediaQuery.of(context).size.height / 10 * 2.5),
                    child: PageView(
                      onPageChanged: (value) => updatePointers(value),
                      children: [firstPage(context), secondPage(context)],
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 150, right: 150),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: pointersList,
                    ))
              ],
            ))
      ],
    );
  }

  Widget firstPage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildActionWidget(
                context,
                SvgPicture.asset("assets/svg/dashboard_add_income.svg"),
                "Añade un ingreso",
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (_) =>
                                      Provider.of<MovementsChangeNotifier>(
                                          context),
                                ),
                                ChangeNotifierProvider(
                                  create: (_) =>
                                      Provider.of<CategoriesChangeNotifier>(
                                          context),
                                )
                              ],
                              child: MovementView(
                                allowEdit: true,
                                movementType: MovementType.INCOME,
                              ),
                            )))),
            buildActionWidget(
                context,
                SvgPicture.asset("assets/svg/dashboard_compare.svg"),
                "Mi cuenta",
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (_) =>
                                      Provider.of<MovementsChangeNotifier>(
                                          context),
                                ),
                                ChangeNotifierProvider(
                                  create: (_) =>
                                      Provider.of<CategoriesChangeNotifier>(
                                          context),
                                )
                              ],
                              child: MovementBalanceView(),
                            )))),
            buildActionWidget(
                context,
                SvgPicture.asset("assets/svg/dashboard_add_expense.svg"),
                "Añade un gasto",
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (_) =>
                                      Provider.of<MovementsChangeNotifier>(
                                          context),
                                ),
                                ChangeNotifierProvider(
                                  create: (_) =>
                                      Provider.of<CategoriesChangeNotifier>(
                                          context),
                                )
                              ],
                              child: MovementView(
                                allowEdit: true,
                                movementType: MovementType.EXPEND,
                              ),
                            ))))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildActionWidget(
                context,
                SvgPicture.asset("assets/svg/dashboard_categories.svg"),
                "Ver categorías",
                () {}),
            buildActionWidget(
                context,
                SvgPicture.asset("assets/svg/dashboard_see_movements.svg"),
                "Todos mis movimientos",
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
                        child: AllMovementView(),
                      ),
                    ))),
            buildActionWidget(
                context,
                SvgPicture.asset("assets/svg/dashboard_advices.svg"),
                "Añade un ingreso",
                () {}),
          ],
        )
      ],
    );
  }

  Widget secondPage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildActionWidget(
                context,
                SvgPicture.asset("assets/svg/dashboard_historial.svg"),
                "Tus suscripciones",
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
                            )))),
            buildEmptyActionWidget(context),
            buildEmptyActionWidget(context)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildEmptyActionWidget(context),
            buildEmptyActionWidget(context),
            buildEmptyActionWidget(context)
          ],
        )
      ],
    );
  }

  Widget buildActionWidget(
      BuildContext context, Widget icon, String text, Function() action) {
    return Material(
      borderRadius: BorderRadius.circular(customBorderRadius),
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(customBorderRadius),
        onTap: action,
        highlightColor: Colors.transparent,
        splashColor: themeColor.withOpacity(0.1),
        child: Container(
          height: (MediaQuery.of(context).size.height / 10) + 3,
          width: (MediaQuery.of(context).size.height / 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40, width: 40, child: Center(child: icon)),
              SizedBox(height: 3),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    text,
                    style: dashboardActionButtonStyle(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmptyActionWidget(BuildContext context) {
    return Container(
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
}
