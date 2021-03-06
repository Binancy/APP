import 'package:binancy/controllers/expenses_controller.dart';
import 'package:binancy/controllers/microexpenses_controller.dart';
import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/microexpenses_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/microexpend.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/icons.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/microexpenses/microexpend_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'microexpenses_dialog_widget.dart';

class MicroExpendCard extends StatelessWidget {
  final BuildContext parentContext;
  final MicroExpend microExpend;
  final MicroExpensesChangeNotifier microExpensesChangeNotifier;
  final MovementsChangeNotifier movementsChangeNotifier;
  final CategoriesChangeNotifier categoriesChangeNotifier;

  const MicroExpendCard(
      {Key? key,
      required this.parentContext,
      required this.microExpend,
      required this.microExpensesChangeNotifier,
      required this.movementsChangeNotifier,
      required this.categoriesChangeNotifier})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: themeColor.withOpacity(0.1),
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: BorderRadius.circular(customBorderRadius),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                          create: (_) => microExpensesChangeNotifier),
                      ChangeNotifierProvider(
                          create: (_) => categoriesChangeNotifier),
                      ChangeNotifierProvider(
                          create: (_) => movementsChangeNotifier)
                    ],
                    child: MicroExpendView(
                        allowEdit: false, selectedMicroExpend: microExpend)))),
        highlightColor: themeColor.withOpacity(0.1),
        splashColor: themeColor.withOpacity(0.1),
        child: Slidable(
          child: Container(
            padding: const EdgeInsets.all(customMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(microExpend.title,
                    style: appBarStyle(), textAlign: TextAlign.center),
                const SpaceDivider(customSpace: 10),
                microExpend.description != null
                    ? Text(
                        microExpend.description ?? "",
                        style: dashboardActionButtonStyle(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      )
                    : const SizedBox(),
                microExpend.description != null
                    ? const SpaceDivider(customSpace: 10)
                    : const SizedBox(),
                Text(Utils.parseAmount(microExpend.amount),
                    style: detailStyle(), textAlign: TextAlign.center),
                const SpaceDivider(customSpace: 10),
                addButton(context)
              ],
            ),
          ),
          actionPane: const SlidableDrawerActionPane(),
          actionExtentRatio: 1,
          actions: [
            IconSlideAction(
              caption: AppLocalizations.of(parentContext)!.delete,
              onTap: () {
                BinancyProgressDialog binancyProgressDialog =
                    BinancyProgressDialog(context: context)
                      ..showProgressDialog();
                MicroExpensesController.deleteMicroExpend(microExpend)
                    .then((value) async {
                  if (value) {
                    await microExpensesChangeNotifier.updateMicroExpenses();
                    binancyProgressDialog.dismissDialog();
                    BinancyInfoDialog(
                        context,
                        AppLocalizations.of(parentContext)!
                            .microexpend_delete_success,
                        [
                          BinancyInfoDialogItem(
                              AppLocalizations.of(parentContext)!.accept, () {
                            Navigator.of(parentContext, rootNavigator: true)
                                .pop();
                          })
                        ]);
                  } else {
                    binancyProgressDialog.dismissDialog();
                    BinancyInfoDialog(
                        context,
                        AppLocalizations.of(parentContext)!
                            .microexpend_delete_error,
                        [
                          BinancyInfoDialogItem(
                              AppLocalizations.of(parentContext)!.accept,
                              () => Navigator.of(parentContext,
                                      rootNavigator: true)
                                  .pop())
                        ]);
                  }
                });
              },
              iconWidget:
                  Icon(BinancyIcons.delete, size: 50, color: accentColor),
              foregroundColor: accentColor,
              color: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  Widget addButton(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(customBorderRadius),
      elevation: 0,
      color: accentColor,
      child: InkWell(
        onTap: () => showCustomModalBottomSheet(
            context: context,
            barrierColor: themeColor.withOpacity(0.65),
            containerWidget: (_, animation, child) => MicroExpendDialogCard(
                  microExpend: microExpend,
                  action: () async {
                    BinancyProgressDialog binancyProgressDialog =
                        BinancyProgressDialog(context: context)
                          ..showProgressDialog();

                    await ExpensesController.insertExpend(Expend()
                          ..idUser = userData['idUser']
                          ..title = microExpend.title
                          ..value = microExpend.amount
                          ..description = microExpend.description
                          ..idCategory = microExpend.category != null
                              ? microExpend.category!.idCategory
                              : null
                          ..category = microExpend.category
                          ..date = DateTime.now())
                        .then((value) async {
                      binancyProgressDialog.dismissDialog();
                      if (value) {
                        BinancyInfoDialog(
                            context,
                            AppLocalizations.of(parentContext)!
                                .expend_add_success,
                            [
                              BinancyInfoDialogItem(
                                  AppLocalizations.of(parentContext)!.accept,
                                  () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              })
                            ]);
                      } else {
                        BinancyInfoDialog(
                            context,
                            AppLocalizations.of(parentContext)!.expend_add_fail,
                            [
                              BinancyInfoDialogItem(
                                  AppLocalizations.of(parentContext)!.accept,
                                  () => Navigator.pop(context))
                            ]);
                      }
                      movementsChangeNotifier.updateMovements();
                    });
                  },
                ),
            builder: (context) => Container()),
        highlightColor: themeColor.withOpacity(0.1),
        splashColor: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(customBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width,
          child: Center(
              child: Text(
            AppLocalizations.of(parentContext)!.add,
            style: TextStyle(
                color: themeColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "OpenSans"),
          )),
        ),
      ),
    );
  }
}
