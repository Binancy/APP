import 'package:binancy/controllers/expenses_controller.dart';
import 'package:binancy/controllers/incomes_controller.dart';
import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';
import 'movement_view.dart';

class MovementCard extends StatelessWidget {
  final dynamic movement;
  final MovementsChangeNotifier movementsProvider;

  const MovementCard({
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
              MaterialPageRoute(
                  builder: (_) => MultiProvider(
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
          highlightColor: Colors.transparent,
          splashColor: themeColor.withOpacity(0.1),
          child: Container(
            height: 75,
            padding: EdgeInsets.only(left: customMargin, right: customMargin),
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
                      Text(movement.category.name, style: detailStyle())
                  ],
                ),
                Text(
                    (movement.value is int
                            ? movement.value.toString()
                            : (movement.value as double).toStringAsFixed(2)) +
                        "€",
                    style: accentTitleStyle())
              ],
            ),
          ),
        ),
      ),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      actions: [
        IconSlideAction(
          caption: "Eliminar",
          foregroundColor: accentColor,
          color: Colors.transparent,
          icon: Icons.delete,
          onTap: () async {
            if (movement is Income) {
              await IncomesController.deleteIncome(movement as Income)
                  .then((value) {
                if (value) {
                  BinancyInfoDialog(
                      context, "Ingreso eliminado correctamente", [
                    BinancyInfoDialogItem("Aceptar", () async {
                      await movementsProvider.updateMovements();
                      Navigator.pop(context);
                    })
                  ]);
                } else {
                  BinancyInfoDialog(context, "Error al eliminar el ingreso", [
                    BinancyInfoDialogItem(
                        "Aceptar", () => Navigator.pop(context))
                  ]);
                }
              });
            } else if (movement is Expend) {
              await ExpensesController.deleteExpend(movement as Expend)
                  .then((value) {
                if (value) {
                  BinancyInfoDialog(context, "Gasto eliminado correctamente", [
                    BinancyInfoDialogItem("Aceptar", () async {
                      await movementsProvider.updateMovements();
                      Navigator.pop(context);
                    })
                  ]);
                } else {
                  BinancyInfoDialog(context, "Error al eliminar el gasto", [
                    BinancyInfoDialogItem(
                        "Aceptar", () => Navigator.pop(context))
                  ]);
                }
              });
            }
          },
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
                                Provider.of<MovementsChangeNotifier>(context),
                          ),
                          ChangeNotifierProvider(
                            create: (_) =>
                                Provider.of<CategoriesChangeNotifier>(context),
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
      ],
      secondaryActions: [
        IconSlideAction(
          caption: "Eliminar",
          foregroundColor: accentColor,
          color: Colors.transparent,
          icon: Icons.delete,
          onTap: () async {
            if (movement is Income) {
              await IncomesController.deleteIncome(movement as Income)
                  .then((value) {
                if (value) {
                  BinancyInfoDialog(
                      context, "Ingreso eliminado correctamente", [
                    BinancyInfoDialogItem("Aceptar", () async {
                      await movementsProvider.updateMovements();
                      Navigator.pop(context);
                    })
                  ]);
                } else {
                  BinancyInfoDialog(context, "Error al eliminar el ingreso", [
                    BinancyInfoDialogItem(
                        "Aceptar", () => Navigator.pop(context))
                  ]);
                }
              });
            } else if (movement is Expend) {
              await ExpensesController.deleteExpend(movement as Expend)
                  .then((value) {
                if (value) {
                  BinancyInfoDialog(context, "Gasto eliminado correctamente", [
                    BinancyInfoDialogItem("Aceptar", () async {
                      await movementsProvider.updateMovements();
                      Navigator.pop(context);
                    })
                  ]);
                } else {
                  BinancyInfoDialog(context, "Error al eliminar el gasto", [
                    BinancyInfoDialogItem(
                        "Aceptar", () => Navigator.pop(context))
                  ]);
                }
              });
            }
          },
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
                                Provider.of<MovementsChangeNotifier>(context),
                          ),
                          ChangeNotifierProvider(
                            create: (_) =>
                                Provider.of<CategoriesChangeNotifier>(context),
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
      ],
    );
  }
}
