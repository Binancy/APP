import 'package:binancy/controllers/expenses_controller.dart';
import 'package:binancy/controllers/microexpenses_controller.dart';
import 'package:binancy/controllers/providers/microexpenses_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/microexpend.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/microexpenses/microexpend_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'microexpenses_dialog_widget.dart';

class MicroExpendCard extends StatelessWidget {
  final MicroExpend microExpend;
  final MicroExpensesChangeNotifier microExpensesChangeNotifier;
  final MovementsChangeNotifier movementsChangeNotifier;

  const MicroExpendCard(
      {Key? key,
      required this.microExpend,
      required this.microExpensesChangeNotifier,
      required this.movementsChangeNotifier})
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
            MaterialPageRoute(
                builder: (_) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                              create: (_) => microExpensesChangeNotifier),
                          ChangeNotifierProvider(
                              create: (_) => movementsChangeNotifier)
                        ],
                        child: MicroExpendView(
                            allowEdit: false,
                            selectedMicroExpend: microExpend)))),
        highlightColor: Colors.transparent,
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
              caption: "Eliminar",
              onTap: () =>
                  MicroExpensesController.deleteMicroExpend(microExpend)
                      .then((value) async {
                if (value) {
                  await microExpensesChangeNotifier.updateMicroExpenses();
                  BinancyInfoDialog(
                      context, "Gasto frecuente eliminado correctamente", [
                    BinancyInfoDialogItem("Aceptar", () {
                      Navigator.of(context).pop();
                    })
                  ]);
                } else {
                  BinancyInfoDialog(
                      context, "Error al eliminar el gasto frecuente", [
                    BinancyInfoDialogItem(
                        "Aceptar", () => Navigator.of(context).pop())
                  ]);
                }
              }),
              iconWidget: Icon(Icons.delete, size: 50, color: accentColor),
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
                    await ExpensesController.insertExpend(Expend()
                          ..idUser = userData['idUser']
                          ..title = microExpend.title
                          ..value = microExpend.amount
                          ..description = microExpend.description
                          ..date = DateTime.now())
                        .then((value) async {
                      if (value) {
                        BinancyInfoDialog(
                            context, "Se ha añadido el gasto correctamente!", [
                          BinancyInfoDialogItem("Aceptar", () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          })
                        ]);
                      } else {
                        BinancyInfoDialog(context,
                            "Ha ocurrido un error al añadir el gasto...", [
                          BinancyInfoDialogItem(
                              "Aceptar", () => Navigator.pop(context))
                        ]);
                      }
                      movementsChangeNotifier.updateMovements();
                    });
                  },
                ),
            builder: (context) => Container()),
        highlightColor: Colors.transparent,
        splashColor: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(customBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width,
          child: Center(
              child: Text(
            "Añadir",
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
