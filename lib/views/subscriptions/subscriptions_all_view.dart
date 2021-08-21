import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/subscription.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/subscriptions/subscription_card.dart';
import 'package:binancy/views/subscriptions/subscription_empty_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Consumer<SubscriptionsChangeNotifier>(
        builder: (context, provider, child) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                brightness: Brightness.dark,
                centerTitle: true,
                title: Text("Tus suscripciones", style: appBarStyle()),
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                      icon: Icon(Icons.more_horiz_rounded, color: Colors.white),
                      onPressed: () {})
                ],
              ),
              body: Container(
                padding: EdgeInsets.all(customMargin),
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(customBorderRadius)),
                      padding: EdgeInsets.all(customMargin),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Tu próxima subscripción a renovar:",
                              style: accentStyle()),
                          Text(
                              provider.getNextSubscriptionToPay() != null
                                  ? provider
                                      .getNextSubscriptionToPay()!
                                      .getNextPayDay(context)
                                  : "No tienes ninguna suscripción",
                              style: titleCardStyle())
                        ],
                      ),
                    ),
                    SpaceDivider(),
                    Container(
                      child: ListView(
                        children: buildSubscriptionsCards(
                            provider.subscriptionsList, provider),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  List<Widget> buildSubscriptionsCards(List<Subscription> subscriptionsList,
      SubscriptionsChangeNotifier provider) {
    List<Widget> subscriptionsWidgets = [];

    if (subscriptionsList.isEmpty) {
      subscriptionsWidgets.add(SubscriptionEmptyCard());
    } else {
      for (var subscription in subscriptionsList) {
        subscriptionsWidgets.add(SubscriptionCard(subscription, provider));
      }
    }

    return subscriptionsWidgets;
  }
}
