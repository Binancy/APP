import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:binancy/views/movements/movements_all_view.dart';
import 'package:binancy/views/movements/movement_view.dart';
import 'package:binancy/views/movements/movments_balance_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DashboardActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                                          create: (_) => Provider.of<
                                              MovementsChangeNotifier>(context),
                                        ),
                                        ChangeNotifierProvider(
                                          create: (_) => Provider.of<
                                                  CategoriesChangeNotifier>(
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
                                          create: (_) => Provider.of<
                                              MovementsChangeNotifier>(context),
                                        ),
                                        ChangeNotifierProvider(
                                          create: (_) => Provider.of<
                                                  CategoriesChangeNotifier>(
                                              context),
                                        )
                                      ],
                                      child: MovementBalanceView(),
                                    )))),
                    buildActionWidget(
                        context,
                        SvgPicture.asset(
                            "assets/svg/dashboard_add_expense.svg"),
                        "Añade un gasto",
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider(
                                          create: (_) => Provider.of<
                                              MovementsChangeNotifier>(context),
                                        ),
                                        ChangeNotifierProvider(
                                          create: (_) => Provider.of<
                                                  CategoriesChangeNotifier>(
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
                        SvgPicture.asset(
                            "assets/svg/dashboard_see_movements.svg"),
                        "Todos mis movimientos",
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
            ))
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
          width: (MediaQuery.of(context).size.height / 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40, width: 40, child: Center(child: icon)),
              SizedBox(height: 3),
              Text(
                text,
                style: dashboardActionButtonStyle(),
                maxLines: 2,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
