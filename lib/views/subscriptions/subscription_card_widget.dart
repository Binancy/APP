import 'package:binancy/controllers/providers/subscriptions_change_notifier.dart';
import 'package:binancy/controllers/subscriptions_controller.dart';
import 'package:binancy/models/subscription.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/dialogs/progress_dialog.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/views/subscriptions/subscription_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';

class SubscriptionCard extends StatelessWidget {
  final BuildContext parentContext;
  final Subscription subscription;
  final SubscriptionsChangeNotifier subscriptionsChangeNotifier;
  const SubscriptionCard(
      {required this.parentContext,
      required this.subscription,
      required this.subscriptionsChangeNotifier});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) =>
                            Provider.of<SubscriptionsChangeNotifier>(context),
                      )
                    ],
                    child: SubscriptionView(
                      selectedSubscription: subscription,
                    ),
                  ))),
          highlightColor: themeColor.withOpacity(0.1),
          splashColor: themeColor.withOpacity(0.1),
          child: Container(
            height: subscriptionCardSize,
            padding:
                const EdgeInsets.only(left: customMargin, right: customMargin),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: semititleStyle(),
                    ),
                    Text(subscription.getNextPayDay(context),
                        style: detailStyle()),
                  ],
                ),
                Text(
                    (subscription.value is int
                            ? subscription.value.toString()
                            : (subscription.value as double)
                                .toStringAsFixed(2)) +
                        "€",
                    style: accentTitleStyle())
              ],
            ),
          ),
        ),
      ),
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      actions: subscriptionActions(context),
      secondaryActions: subscriptionActions(context),
    );
  }

  List<Widget> subscriptionActions(BuildContext context) {
    return [
      IconSlideAction(
        caption: "Eliminar",
        foregroundColor: accentColor,
        color: Colors.transparent,
        icon: Icons.delete,
        onTap: () async {
          BinancyProgressDialog binancyProgressDialog =
              BinancyProgressDialog(context: context)..showProgressDialog();
          await SubscriptionsController.deleteSubscription(subscription)
              .then((value) async {
            if (value) {
              await subscriptionsChangeNotifier.updateSubscriptions();
              binancyProgressDialog.dismissDialog();
              BinancyInfoDialog(
                  context, "Suscripción eliminada correctamente", [
                BinancyInfoDialogItem(
                    "Aceptar",
                    () =>
                        Navigator.of(parentContext, rootNavigator: true).pop())
              ]);
            } else {
              BinancyInfoDialog(context, "Error al eliminar la suscripcion", [
                BinancyInfoDialogItem(
                    "Aceptar",
                    () =>
                        Navigator.of(parentContext, rootNavigator: true).pop())
              ]);
            }
          });
        },
      ),
      IconSlideAction(
        caption: "Editar",
        icon: Icons.edit,
        foregroundColor: accentColor,
        color: Colors.transparent,
        onTap: () => Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                child: MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) =>
                          Provider.of<SubscriptionsChangeNotifier>(context),
                    )
                  ],
                  child: SubscriptionView(
                      allowEdit: true, selectedSubscription: subscription),
                ))),
      )
    ];
  }
}
