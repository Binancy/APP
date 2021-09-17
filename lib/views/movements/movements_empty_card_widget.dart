import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/utils/enums.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';
import 'movement_view.dart';

class MovememntEmptyCard extends StatelessWidget {
  final MovementType movementType;
  final bool isExpanded;

  const MovememntEmptyCard(this.movementType, {this.isExpanded = false});

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? expandedMovementEmptyCard(context)
        : collapsedMovementEmptyCard(context);
  }

  Widget expandedMovementEmptyCard(BuildContext context) {
    return GestureDetector(
      onTap: () => gotoAddMovement(context),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
                height: 100,
                width: 100,
                child: Icon(
                  Icons.add_rounded,
                  size: 100,
                  color: Colors.white,
                )),
            Text(
                movementType == MovementType.INCOME
                    ? "No hay ningun ingreso registrado"
                    : "No hay ningun gasto registrado",
                style: accentStyle(),
                textAlign: TextAlign.center),
            Text("Toca para añadir uno",
                style: accentStyle(), textAlign: TextAlign.center),
            const SizedBox(
              height: 100,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget collapsedMovementEmptyCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: () => gotoAddMovement(context),
        highlightColor: themeColor.withOpacity(0.1),
        splashColor: themeColor.withOpacity(0.1),
        child: Container(
          height: movementCardSize,
          padding:
              const EdgeInsets.only(left: customMargin, right: customMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.add_rounded, color: Colors.white, size: 50),
              const SpaceDivider(isVertical: true),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      movementType == MovementType.INCOME
                          ? "No hay ningun ingreso registrado"
                          : "No hay ningun gasto registrado",
                      style: accentStyle(),
                      textAlign: TextAlign.center),
                  Text("Toca para añadir uno",
                      style: accentStyle(), textAlign: TextAlign.center),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void gotoAddMovement(BuildContext context) {
    movementType == MovementType.INCOME
        ? Navigator.push(
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
                      child: const MovementView(
                        allowEdit: true,
                        movementType: MovementType.INCOME,
                      ),
                    )))
        : Navigator.push(
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
                      child: const MovementView(
                        allowEdit: true,
                        movementType: MovementType.EXPEND,
                      ),
                    )));
  }
}
