import 'package:binancy/globals.dart';
import 'package:binancy/models/plan.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:flutter/material.dart';

class PremiumPlanCard extends StatelessWidget {
  final Plan plan;

  const PremiumPlanCard({Key? key, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity:
            !Utils.showIfPlanIsEqualOrHigher(userData['idPlan'], plan.idPlan)
                ? 1
                : 0.65,
        child: Material(
          borderRadius: BorderRadius.circular(customBorderRadius),
          elevation: 0,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: themeColor.withOpacity(0.1),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(customBorderRadius),
            highlightColor: themeColor.withOpacity(0.1),
            splashColor: themeColor.withOpacity(0.1),
            child: Container(
              padding: const EdgeInsets.all(customMargin),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.planTitle, style: titleCardStyle()),
                      Text(getDescriptionOfPlan(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: miniAccentStyle())
                    ],
                  )),
                  const SpaceDivider(isVertical: true),
                  Material(
                    borderRadius: BorderRadius.circular(customBorderRadius),
                    elevation: 0,
                    color: accentColor,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(customBorderRadius),
                      highlightColor: themeColor.withOpacity(0.1),
                      splashColor: themeColor.withOpacity(0.1),
                      child: Container(
                        padding: const EdgeInsets.all(customMargin / 1.5),
                        child: Center(
                          child: Text(
                              !Utils.showIfPlanIsEqualOrHigher(
                                      userData['idPlan'], plan.idPlan)
                                  ? Utils.parseAmount(plan.planAmount)
                                  : "Adquirido",
                              style: plansButtonStyle()),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  String getDescriptionOfPlan() {
    switch (plan.idPlan) {
      case "member":
        return "Obtiene todas las funciones en todos los productos de Appxs. Un solo pago y de por vida";
      case "binancy":
        return "Obtiene todas las funciones disponibles de Binancy. Un solo pago y de por vida";
      case "free":
        return "Plan estándard, algunas funciones están bloqueadas";
      default:
        return "";
    }
  }
}
