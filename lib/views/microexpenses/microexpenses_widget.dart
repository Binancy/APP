import 'package:binancy/controllers/expenses_controller.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/microexpend.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/microexpenses/microexpend_view.dart';
import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'microexpenses_dialog_widget.dart';

class MicroExpendCard extends StatelessWidget {
  final MicroExpend microExpend;
  final MovementsChangeNotifier movementsChangeNotifier;

  const MicroExpendCard(
      {Key? key,
      required this.microExpend,
      required this.movementsChangeNotifier})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: themeColor.withOpacity(0.1),
      elevation: 0,
      borderRadius: BorderRadius.circular(customBorderRadius),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MicroExpendView(
                    allowEdit: false, selectedMicroExpend: microExpend))),
        highlightColor: Colors.transparent,
        splashColor: themeColor.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.all(customMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(microExpend.title,
                  style: appBarStyle(), textAlign: TextAlign.center),
              SpaceDivider(customSpace: 10),
              microExpend.description != null
                  ? Text(
                      microExpend.description ?? "",
                      style: dashboardActionButtonStyle(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    )
                  : SizedBox(),
              microExpend.description != null
                  ? SpaceDivider(customSpace: 10)
                  : SizedBox(),
              Text(
                  microExpend.amount is int
                      ? microExpend.amount.toString() + "€"
                      : (microExpend.amount as double).toStringAsFixed(2) + "€",
                  style: detailStyle(),
                  textAlign: TextAlign.center),
              SpaceDivider(customSpace: 10),
              addButton(context)
            ],
          ),
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
            containerWidget: (context, animation, child) =>
                MicroExpendDialogCard(
                  microExpend: microExpend,
                  action: () async {
                    await ExpensesController.insertExpend(Expend()
                          ..idUser = userData['idUser']
                          ..title = microExpend.title
                          ..value = microExpend.amount
                          ..description = microExpend.description
                          ..date = DateTime.now())
                        .then((value) {
                      if (value) {
                        movementsChangeNotifier.updateMovements();
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
                    });
                  },
                ),
            builder: (context) => Container()),
        highlightColor: Colors.transparent,
        splashColor: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(customBorderRadius),
        child: Container(
          padding: EdgeInsets.all(5),
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
