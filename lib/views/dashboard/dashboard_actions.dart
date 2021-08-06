import 'package:binancy/globals.dart';
import 'package:binancy/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                        () {}),
                    buildActionWidget(
                        context,
                        SvgPicture.asset(
                            "assets/svg/dashboard_add_expense.svg"),
                        "Añade un ingreso",
                        () {}),
                    buildActionWidget(
                        context,
                        SvgPicture.asset(
                            "assets/svg/dashboard_check_balance.svg"),
                        "Añade un ingreso",
                        () {}),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildActionWidget(
                        context,
                        SvgPicture.asset("assets/svg/dashboard_compare.svg"),
                        "Añade un ingreso",
                        () {}),
                    buildActionWidget(
                        context,
                        SvgPicture.asset(
                            "assets/svg/dashboard_see_movements.svg"),
                        "Añade un ingreso",
                        () {}),
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