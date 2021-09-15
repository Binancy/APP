import 'package:binancy/models/subscription.dart';
import 'package:flutter/material.dart';

class SubscriptionView extends StatefulWidget {
  final bool allowEdit;
  final Subscription? selectedSubscription;
  const SubscriptionView({this.selectedSubscription, this.allowEdit = false});

  @override
  _SubscriptionViewState createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
