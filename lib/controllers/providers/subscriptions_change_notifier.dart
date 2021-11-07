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
    DateTime today = DateTime.now();
    Subscription nextSubscriptionToPay = Subscription()
      ..payDay = 0
      ..latestMonth = Month.NONE;

    for (var subscription in subscriptionsList) {
      if (subscription.latestMonth.index < today.month) {
        if (subscription.payDay > today.day &&
                subscription.payDay > nextSubscriptionToPay.payDay ||
            nextSubscriptionToPay.payDay == 0) {
          nextSubscriptionToPay = subscription;
        }
      } else if (subscription.latestMonth.index == 12 && today.month == 1) {
        if (subscription.payDay < today.day &&
                subscription.payDay < nextSubscriptionToPay.payDay ||
            nextSubscriptionToPay.payDay == 0) {
          nextSubscriptionToPay = subscription;
        }
      } else if (subscription.latestMonth.index == today.month) {
        if (subscription.payDay > today.day &&
                subscription.payDay < nextSubscriptionToPay.payDay ||
            nextSubscriptionToPay.payDay == 0) {
          nextSubscriptionToPay = subscription;
        }
      }
    }

    if (nextSubscriptionToPay.payDay == 0 &&
        nextSubscriptionToPay.latestMonth == Month.NONE) {
      return null;
    }

    return nextSubscriptionToPay;
  }
}
