import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/microexpend.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

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
        onTap: () {},
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
        onTap: () {},
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
