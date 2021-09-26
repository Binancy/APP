import 'package:binancy/controllers/providers/categories_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      child: Container(
        padding: const EdgeInsets.all(customMargin),
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
                    ? AppLocalizations.of(context)!.no_incomes
                    : AppLocalizations.of(context)!.no_expends,
                style: accentStyle(),
                textAlign: TextAlign.center),
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
          padding: const EdgeInsets.all(customMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.add_rounded, color: Colors.white, size: 50),
              const SpaceDivider(isVertical: true),
              Expanded(
                child: Text(
                    movementType == MovementType.INCOME
                        ? AppLocalizations.of(context)!.no_incomes
                        : AppLocalizations.of(context)!.no_expends,
                    style: accentStyle(),
                    textAlign: TextAlign.start),
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
