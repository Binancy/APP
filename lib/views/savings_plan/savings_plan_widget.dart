import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/savings_plan.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

class SavingsPlanWidget extends StatefulWidget {
  final SavingsPlan savingsPlan;
  final SavingsPlanChangeNotifier savingsPlanChangeNotifier;
  final bool animate;

  SavingsPlanWidget(this.savingsPlan, this.savingsPlanChangeNotifier,
      {this.animate = true});

  @override
  _SavingsPlanWidgetState createState() => _SavingsPlanWidgetState();
}

class _SavingsPlanWidgetState extends State<SavingsPlanWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Tween<double> valueTween;
  late Animation<double> curve;

  @override
  void initState() {
    super.initState();
    this.valueTween = Tween<double>(
        begin: 0, end: widget.savingsPlan.amount / widget.savingsPlan.total);
    this.animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: savingsPlanProgressMS))
      ..value = 0
      ..forward();
    this.curve = CurvedAnimation(
        parent: this.animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

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
                      child: Text(widget.savingsPlan.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: savingsPlanTitleStyle(false))),
                  SpaceDivider(isVertical: true),
                  Text(getPercentage(), style: newMethod())
                ],
              ),
              SpaceDivider(customSpace: 10),
              AnimatedBuilder(
                  animation: this.curve,
                  builder: (context, child) => ClipRRect(
                        borderRadius: BorderRadius.circular(360),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white.withOpacity(0.5),
                          color: accentColor,
                          value: widget.animate
                              ? this
                                  .valueTween
                                  .evaluate(this.animationController)
                              : widget.savingsPlan.amount /
                                  widget.savingsPlan.total,
                          minHeight: 12.5,
                        ),
                      )),
              SpaceDivider(customSpace: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                          widget.savingsPlan.amount.toString() +
                              "€ de " +
                              widget.savingsPlan.total.toString() +
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
    double percentage =
        ((widget.savingsPlan.amount / widget.savingsPlan.total) * 100);
    return percentage.toStringAsFixed(0) + "%";
  }

  String getDaysToLimitDate() {
    if (widget.savingsPlan.limitDate != null) {
      if (Utils.isAtSameDay(widget.savingsPlan.limitDate!, DateTime.now())) {
        return "Hoy";
      } else if (widget.savingsPlan.limitDate!
              .difference(DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day))
              .inDays ==
          1) {
        return "Mañana";
      } else {
        int days =
            widget.savingsPlan.limitDate!.difference(DateTime.now()).inDays;
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
