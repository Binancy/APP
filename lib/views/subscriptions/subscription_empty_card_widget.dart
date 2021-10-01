import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/subscriptions/subscription_view.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../globals.dart';

class SubscriptionEmptyCard extends StatelessWidget {
  final bool isExpanded;
  const SubscriptionEmptyCard({this.isExpanded = false});

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
            Text(AppLocalizations.of(context)!.no_subscriptions,
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

  Widget collapsedSubscriptionEmptyCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: () => gotoAddSubscription(context),
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
                  child: Text(AppLocalizations.of(context)!.no_subscriptions,
                      style: accentStyle(), textAlign: TextAlign.start))
            ],
          ),
        ),
      ),
    );
  }

  void gotoAddSubscription(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                    create: (_) =>
                        Provider.of<SubscriptionsChangeNotifier>(context))
              ],
              child: const SubscriptionView(),
            )));
  }
}
