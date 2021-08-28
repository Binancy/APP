import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/savings_plan.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

class SavingsPlanWidget extends StatelessWidget {
  final SavingsPlan savingsPlan;
  final SavingsPlanChangeNotifier savingsPlanChangeNotifier;
  final bool rightPadding;

  SavingsPlanWidget(this.savingsPlan, this.savingsPlanChangeNotifier,
      {this.rightPadding = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        highlightColor: Colors.transparent,
        splashColor: themeColor.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.all(customMargin),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: Text(savingsPlan.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: savingsPlanTitleStyle(false))),
                  SpaceDivider(isVertical: true),
                  Text(getPercentage(), style: newMethod())
                ],
              ),
              SpaceDivider(customSpace: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  color: accentColor,
                  value: savingsPlan.amount / savingsPlan.total,
                  minHeight: 12.5,
                ),
              ),
              SpaceDivider(customSpace: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                          savingsPlan.amount.toString() +
                              "€ de " +
                              savingsPlan.total.toString() +
                              "€",
                          style: newMethod())),
                  SpaceDivider(isVertical: true),
                  Text(getDaysToLimitDate(), style: newMethod())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle newMethod() {
    return TextStyle(
        color: textColor,
        fontFamily: "OpenSans",
        fontSize: 14,
        fontWeight: FontWeight.w300);
  }

  String getPercentage() {
    double percentage = ((savingsPlan.amount / savingsPlan.total) * 100);
    return percentage.toStringAsFixed(0) + "%";
  }

  String getDaysToLimitDate() {
    if (savingsPlan.limitDate != null) {
      if (Utils.isAtSameDay(savingsPlan.limitDate!, DateTime.now())) {
        return "Hoy";
      } else if (savingsPlan.limitDate!
              .difference(DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day))
              .inDays ==
          1) {
        return "Mañana";
      } else {
        int days = savingsPlan.limitDate!.difference(DateTime.now()).inDays;
        if (days.isNegative) {
          return "Hace " + days.toString() + " días";
        } else {
          return days.toString() + " días restatntes";
        }
      }
    } else {
      return "";
    }
  }
}
