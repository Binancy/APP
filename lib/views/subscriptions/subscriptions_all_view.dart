import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/subscriptions/subscription_card_widget.dart';
import 'package:binancy/views/subscriptions/subscription_empty_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Consumer<SubscriptionsChangeNotifier>(
        builder: (context, provider, child) => Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
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
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(customMargin),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: customMargin, right: customMargin),
                      decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(customBorderRadius)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            provider.subscriptionsList.length.toString(),
                            style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 65),
                          ),
                          SpaceDivider(isVertical: true),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.subscriptionsList.length == 1
                                    ? "Suscripción activa"
                                    : "Suscripciones activas",
                                style: titleCardStyle(),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                    SpaceDivider(),
                    provider.subscriptionsList.length != 0
                        ? Container(
                            width: MediaQuery.of(context).size.width,
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
                                                .name +
                                            " - " +
                                            provider
                                                .getNextSubscriptionToPay()!
                                                .getNextPayDay(context)
                                        : "No tienes ninguna suscripción",
                                    style: titleCardStyle())
                              ],
                            ),
                          )
                        : SizedBox(),
                    provider.subscriptionsList.length != 0
                        ? SpaceDivider()
                        : SizedBox(),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 65,
                      decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(customBorderRadius),
                              topRight: Radius.circular(customBorderRadius))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(),
                          Padding(
                              padding: EdgeInsets.only(left: customMargin),
                              child: Text(
                                "Todas tus suscripciones",
                                style: titleCardStyle(),
                              )),
                          LinearDivider()
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(customBorderRadius),
                              bottomRight: Radius.circular(customBorderRadius)),
                          color: themeColor.withOpacity(0.1)),
                      child: provider.subscriptionsList.isEmpty
                          ? SubscriptionEmptyCard(isExpanded: true)
                          : ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: ListView.separated(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  itemBuilder: (context, index) =>
                                      SubscriptionCard(
                                        subscription: provider.subscriptionsList
                                            .elementAt(index),
                                        subscriptionsChangeNotifier: provider,
                                      ),
                                  separatorBuilder: (context, index) =>
                                      LinearDivider(),
                                  itemCount:
                                      provider.subscriptionsList.length)),
                    )),
                  ],
                ),
              ),
            )));
  }
}
