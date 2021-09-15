import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/controllers/savings_plan_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/savings_plan.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/savings_plan/savings_plan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SavingsPlanWidget extends StatefulWidget {
  final SavingsPlan savingsPlan;
  final SavingsPlanChangeNotifier savingsPlanChangeNotifier;
  final bool animate;
  final dynamic currentAmount;

  const SavingsPlanWidget(
      this.savingsPlan, this.savingsPlanChangeNotifier, this.currentAmount,
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
    valueTween = Tween<double>(
        begin: 0, end: widget.currentAmount / widget.savingsPlan.amount);
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: savingsPlanProgressMS))
      ..value = 0
      ..forward();
    curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) =>
                          Provider.of<SavingsPlanChangeNotifier>(context),
                    )
                  ],
                  child: SavingsPlanView(
                      allowEdit: false,
                      selectedSavingsPlan: widget.savingsPlan),
                ),
              )),
          highlightColor: Colors.transparent,
          splashColor: themeColor.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.all(customMargin),
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
                    const SpaceDivider(isVertical: true),
                    Text(getPercentage(), style: newMethod())
                  ],
                ),
                const SpaceDivider(customSpace: 10),
                AnimatedBuilder(
                    animation: curve,
                    builder: (context, child) => ClipRRect(
                          borderRadius: BorderRadius.circular(360),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white.withOpacity(0.5),
                            color: accentColor,
                            value: widget.animate
                                ? valueTween.evaluate(animationController)
                                : widget.currentAmount /
                                    widget.savingsPlan.amount,
                            minHeight: 12.5,
                          ),
                        )),
                const SpaceDivider(customSpace: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      widget.currentAmount is int
                          ? widget.currentAmount.toString()
                          : (widget.currentAmount as double)
                                  .toStringAsFixed(2) +
                              "€ de " +
                              widget.savingsPlan.amount.toString() +
                              "€",
                      style: newMethod(),
                      overflow: TextOverflow.ellipsis,
                    )),
                    const SpaceDivider(isVertical: true),
                    Text(getDaysToLimitDate(), style: newMethod())
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      actions: savingsPlansActions(),
      secondaryActions: savingsPlansActions(),
    );
  }

  List<Widget> savingsPlansActions() {
    return [
      IconSlideAction(
        caption: "Eliminar",
        foregroundColor: accentColor,
        color: Colors.transparent,
        icon: Icons.delete,
        onTap: () async =>
            await SavingsPlansController.deleteSavingsPlan(widget.savingsPlan)
                .then((value) async {
          if (value) {
            await widget.savingsPlanChangeNotifier.updateSavingsPlan();
            BinancyInfoDialog(
                context, "Meta de ahorros eliminada correctamente", [
              BinancyInfoDialogItem("Aceptar", () {
                Navigator.pop(context);
              })
            ]);
          } else {
            BinancyInfoDialog(context, "Error al eliminar la meta de ahorros", [
              BinancyInfoDialogItem("Aceptar", () => Navigator.pop(context))
            ]);
          }
        }),
      ),
      IconSlideAction(
        caption: "Editar",
        icon: Icons.edit,
        foregroundColor: accentColor,
        color: Colors.transparent,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) =>
                        Provider.of<SavingsPlanChangeNotifier>(context),
                  )
                ],
                child: SavingsPlanView(
                    allowEdit: true, selectedSavingsPlan: widget.savingsPlan),
              ),
            )),
      )
    ];
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
        ((widget.currentAmount / widget.savingsPlan.amount) * 100);
    return percentage >= 100 ? "100%" : percentage.toStringAsFixed(0) + "%";
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
          return "Finalizó hace " +
              days.toString().replaceAll("-", "") +
              " días";
        } else {
          return days.toString() + " días restatntes";
        }
      }
    } else {
      return "";
    }
  }
}
