import 'package:binancy/controllers/subscriptions_controller.dart';
import 'package:binancy/models/subscription.dart';
import 'package:flutter/material.dart';

class SubscriptionsChangeNotifier extends ChangeNotifier {
  List<Subscription> subscriptionsList = [];
  double totalSubscriptionsValue = 0;

  @override
  void dispose() {}

  Future<void> updateSubscriptions() async {
    subscriptionsList = await SubscriptionsController.getSubscriptions();
    await getTotalSubscriptionsValue();
    notifyListeners();
  }

  Future<void> getTotalSubscriptionsValue() async {
    totalSubscriptionsValue = 0;
    for (var subscription in subscriptionsList) {
      totalSubscriptionsValue += subscription.value;
    }
  }
}
