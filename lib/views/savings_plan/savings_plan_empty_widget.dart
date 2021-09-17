import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class SavingsPlanEmptyWidget extends StatelessWidget {
  final bool isExpanded;

  const SavingsPlanEmptyWidget({this.isExpanded = false});

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? expandedSavingsPlanEmptyWidget(context)
        : collapsedSavingsPlanEmptyWidget(context);
  }

  Widget expandedSavingsPlanEmptyWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => gotoAddSavingsPlan(context),
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
            Text("No hay ninguna meta de ahorro registrada",
                style: accentStyle(), textAlign: TextAlign.center),
            Text("Toca para añadir una",
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

  Widget collapsedSavingsPlanEmptyWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: () => gotoAddSavingsPlan(context),
        highlightColor: themeColor.withOpacity(0.1),
        splashColor: themeColor.withOpacity(0.1),
        child: Container(
          height: subscriptionCardSize,
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
                  Text("No hay ninguna meta de ahorro registrada",
                      style: accentStyle(), textAlign: TextAlign.center),
                  Text("Toca para añadir una",
                      style: accentStyle(), textAlign: TextAlign.center),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void gotoAddSavingsPlan(BuildContext context) {}
}
