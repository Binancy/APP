import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class SubscriptionEmptyCard extends StatelessWidget {
  final bool isExpanded;
  SubscriptionEmptyCard({this.isExpanded = false});

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? expandedSubscriptionEmptyCard(context)
        : collapsedSubscriptionEmptyCard(context);
  }

  Widget expandedSubscriptionEmptyCard(BuildContext context) {
    return GestureDetector(
      onTap: () => gotoAddSubscription(context),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 100,
                width: 100,
                child: Icon(
                  Icons.add_rounded,
                  size: 100,
                  color: Colors.white,
                )),
            Text("No hay ninguna suscripcion registrada",
                style: accentStyle(), textAlign: TextAlign.center),
            Text("Toca para añadir una",
                style: accentStyle(), textAlign: TextAlign.center),
            SizedBox(
              height: 100,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget collapsedSubscriptionEmptyCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: () => gotoAddSubscription(context),
        highlightColor: Colors.transparent,
        splashColor: themeColor.withOpacity(0.1),
        child: Container(
          height: subscriptionCardSize,
          padding: EdgeInsets.only(left: customMargin, right: customMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, color: Colors.white, size: 50),
              SpaceDivider(isVertical: true),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("No hay ninguna suscripción registrada",
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

  void gotoAddSubscription(BuildContext context) {}
}
