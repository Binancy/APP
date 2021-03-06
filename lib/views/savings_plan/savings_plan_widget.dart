import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/controllers/savings_plan_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/savings_plan.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/savings_plan/savings_plan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavingsPlanWidget extends StatefulWidget {
  final BuildContext parentContext;
  final SavingsPlan savingsPlan;
  final SavingsPlanChangeNotifier savingsPlanChangeNotifier;
  final bool animate;
  final dynamic currentAmount;

  const SavingsPlanWidget(this.parentContext, this.savingsPlan,
      this.savingsPlanChangeNotifier, this.currentAmount,
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
              PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                child: MultiProvider(
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
          highlightColor: themeColor.withOpacity(0.1),
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
                          : AppLocalizations.of(context)!.goal_amount_of_total(
                              (widget.currentAmount as double).toStringAsFixed(
                                  widget.currentAmount % 1 == 0 ? 0 : 2),
                              currency,
                              widget.savingsPlan.amount.toString()),
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
        caption: AppLocalizations.of(context)!.delete,
        foregroundColor: accentColor,
        color: Colors.transparent,
        icon: BinancyIcons.delete,
        onTap: () async {
          BinancyProgressDialog binancyProgressDialog =
              BinancyProgressDialog(context: context)..showProgressDialog();
          await SavingsPlansController.deleteSavingsPlan(widget.savingsPlan)
              .then((value) async {
            if (value) {
              await widget.savingsPlanChangeNotifier.updateSavingsPlan();
              binancyProgressDialog.dismissDialog();
              BinancyInfoDialog(
                  context, AppLocalizations.of(context)!.goal_delete_success, [
                BinancyInfoDialogItem(AppLocalizations.of(context)!.accept, () {
                  Navigator.of(widget.parentContext, rootNavigator: true).pop();
                })
              ]);
            } else {
              binancyProgressDialog.dismissDialog();
              BinancyInfoDialog(
                  context, AppLocalizations.of(context)!.goal_delete_error, [
                BinancyInfoDialogItem(
                    AppLocalizations.of(context)!.accept,
                    () =>
                        Navigator.of(widget.parentContext, rootNavigator: true)
                            .pop())
              ]);
            }
          });
        },
      ),
      IconSlideAction(
        caption: AppLocalizations.of(context)!.edit,
        icon: BinancyIcons.edit,
        foregroundColor: accentColor,
        color: Colors.transparent,
        onTap: () => Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              child: MultiProvider(
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
        return AppLocalizations.of(context)!.today;
      } else if (widget.savingsPlan.limitDate!
              .difference(DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day))
              .inDays ==
          1) {
        return AppLocalizations.of(context)!.tomorrow;
      } else {
        int days =
            widget.savingsPlan.limitDate!.difference(DateTime.now()).inDays;
        if (days.isNegative) {
          return AppLocalizations.of(context)!
              .goal_overdue(days.toString().replaceAll("-", ""));
        } else {
          return AppLocalizations.of(context)!.goal_due_date(days.toString());
        }
      }
    } else {
      return "";
    }
  }
}
