import 'package:binancy/controllers/expenses_controller.dart';
import 'package:binancy/controllers/incomes_controller.dart';
import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../globals.dart';
import 'movement_view.dart';

class MovementCard extends StatelessWidget {
  final BuildContext parentContext;
  final dynamic movement;
  final MovementsChangeNotifier movementsProvider;

  const MovementCard({
    required this.parentContext,
    required this.movement,
    required this.movementsProvider,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  child: MultiProvider(
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
                    child: MovementView(
                      selectedMovement: movement,
                      movementType: movement is Income
                          ? MovementType.INCOME
                          : MovementType.EXPEND,
                    ),
                  ))),
          highlightColor: themeColor.withOpacity(0.1),
          splashColor: themeColor.withOpacity(0.1),
          child: Container(
            height: movementCardSize,
            padding:
                const EdgeInsets.only(left: customMargin, right: customMargin),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movement.title,
                      style: semititleStyle(),
                    ),
                    Text(Utils.toYMD(movement.date, context),
                        style: detailStyle()),
                    if (movement.category != null)
                      Text(movement.category.title, style: detailStyle())
                  ],
                ),
                Text(
                    (movement.value is int
                            ? movement.value.toString()
                            : (movement.value as double).toStringAsFixed(2)) +
                        currency,
                    style: accentTitleStyle())
              ],
            ),
          ),
        ),
      ),
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      actions: movementsActions(context),
      secondaryActions: movementsActions(context),
    );
  }

  List<Widget> movementsActions(BuildContext thisContext) {
    return [
      IconSlideAction(
        caption: AppLocalizations.of(parentContext)!.delete,
        foregroundColor: accentColor,
        color: Colors.transparent,
        icon: BinancyIcons.delete,
        onTap: () async {
          BinancyProgressDialog binancyProgressDialog =
              BinancyProgressDialog(context: parentContext)
                ..showProgressDialog();
          if (movement is Income) {
            await IncomesController.deleteIncome(movement as Income)
                .then((value) async {
              if (value) {
                await movementsProvider.updateMovements();
                binancyProgressDialog.dismissDialog();
                BinancyInfoDialog(parentContext,
                    AppLocalizations.of(parentContext)!.income_delete_success, [
                  BinancyInfoDialogItem(
                      AppLocalizations.of(parentContext)!.accept, () {
                    Navigator.of(parentContext, rootNavigator: true).pop();
                  })
                ]);
              } else {
                binancyProgressDialog.dismissDialog();
                BinancyInfoDialog(parentContext,
                    AppLocalizations.of(parentContext)!.income_delete_error, [
                  BinancyInfoDialogItem(
                      AppLocalizations.of(parentContext)!.accept,
                      () => Navigator.of(parentContext, rootNavigator: true)
                          .pop())
                ]);
              }
            });
          } else if (movement is Expend) {
            await ExpensesController.deleteExpend(movement as Expend)
                .then((value) async {
              if (value) {
                await movementsProvider.updateMovements();
                binancyProgressDialog.dismissDialog();
                BinancyInfoDialog(parentContext,
                    AppLocalizations.of(parentContext)!.expend_delete_success, [
                  BinancyInfoDialogItem(
                      AppLocalizations.of(parentContext)!.accept, () {
                    Navigator.of(parentContext).pop();
                  })
                ]);
              } else {
                binancyProgressDialog.dismissDialog();
                BinancyInfoDialog(parentContext,
                    AppLocalizations.of(parentContext)!.expend_delete_error, [
                  BinancyInfoDialogItem(
                      AppLocalizations.of(parentContext)!.accept,
                      () => Navigator.of(parentContext).pop())
                ]);
              }
            });
          }
        },
      ),
      IconSlideAction(
        caption: AppLocalizations.of(parentContext)!.edit,
        icon: BinancyIcons.edit,
        foregroundColor: accentColor,
        color: Colors.transparent,
        onTap: () => Navigator.push(
            thisContext,
            PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                child: MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) =>
                          Provider.of<MovementsChangeNotifier>(thisContext),
                    ),
                    ChangeNotifierProvider(
                      create: (_) =>
                          Provider.of<CategoriesChangeNotifier>(thisContext),
                    )
                  ],
                  child: MovementView(
                    allowEdit: true,
                    selectedMovement: movement,
                    movementType: movement is Income
                        ? MovementType.INCOME
                        : MovementType.EXPEND,
                  ),
                ))),
      )
    ];
  }
}
