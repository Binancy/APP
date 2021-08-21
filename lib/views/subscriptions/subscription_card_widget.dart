import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/models/subscription.dart';
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final SubscriptionsChangeNotifier subscriptionsChangeNotifier;
  SubscriptionCard(this.subscription, this.subscriptionsChangeNotifier);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
