import 'package:binancy/globals.dart';
import 'package:binancy/models/plan.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

class PremiumPlanCard extends StatelessWidget {
  final Plan plan;

  const PremiumPlanCard({Key? key, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(customBorderRadius),
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: themeColor.withOpacity(0.1),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(customBorderRadius),
        highlightColor: Colors.transparent,
        splashColor: themeColor.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.all(customMargin),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.title, style: titleCardStyle()),
                  Text(
                      "Obtiene todas las funciones en todos los productos de Appxs, un solo pago y de por vida",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: miniAccentStyle())
                ],
              )),
              SpaceDivider(isVertical: true),
              Material(
                borderRadius: BorderRadius.circular(customBorderRadius),
                elevation: 0,
                color: accentColor,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(customBorderRadius),
                  highlightColor: Colors.transparent,
                  splashColor: themeColor.withOpacity(0.1),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(customMargin * 1.5,
                        customMargin / 2, customMargin * 1.5, customMargin / 2),
                    child: Center(
                      child: Text(Utils.parseAmount(plan.amount),
                          style: plansButtonStyle()),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
