import 'package:binancy/controllers/providers/plans_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/views/advice/advice_card.dart';
import 'package:binancy/views/payments/premium_plans_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PremiumAdWidget extends StatelessWidget {
  const PremiumAdWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: customMargin),
      child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) =>
                            Provider.of<PlansChangeNotifier>(context),
                      )
                    ],
                    child: const PremiumPlansView(),
                  ))),
          child: AdviceCard(
              icon: SvgPicture.asset("assets/svg/dashboard_premium.svg"),
              text:
                  "Desbloquea más gráficos y opciones comprando un plan premium")),
    );
  }
}
