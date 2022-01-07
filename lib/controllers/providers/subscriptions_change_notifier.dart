// ignore_for_file: must_call_super

import 'package:binancy/controllers/subscriptions_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/subscription.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/material.dart';

class SubscriptionsChangeNotifier extends ChangeNotifier {
  List<Subscription> subscriptionsList = [];
  double totalSubscriptionsValue = 0;

  @override
  void dispose() {}

  Future<void> updateSubscriptions() async {
    if (await Utils.hasConnection().timeout(timeout)) {
      subscriptionsList = await SubscriptionsController.getSubscriptions();
      subscriptionsList.sort((a, b) => b.date!.isAfter(a.date!) ? 0 : 1);
      await getTotalSubscriptionsValue();
      notifyListeners();
    }
  }

  Future<void> getTotalSubscriptionsValue() async {
    totalSubscriptionsValue = 0;
    for (var subscription in subscriptionsList) {
      totalSubscriptionsValue += subscription.value;
    }
  }

  Subscription? getNextSubscriptionToPay() {
    Subscription nextSubscriptionToPay = Subscription()
      ..payDay = 0
      ..latestMonth = Month.NONE;

    for (var subscription in subscriptionsList) {
      if (nextSubscriptionToPay.date == null) {
        nextSubscriptionToPay = subscription;
      } else if (nextSubscriptionToPay.date!.isAfter(subscription.date!)) {
        nextSubscriptionToPay = subscription;
      }
    }

    if (nextSubscriptionToPay.payDay == 0 &&
        nextSubscriptionToPay.latestMonth == Month.NONE) {
      return null;
    }

    return nextSubscriptionToPay;
  }
}
