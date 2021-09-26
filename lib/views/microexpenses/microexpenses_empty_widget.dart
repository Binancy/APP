import 'package:binancy/controllers/providers/microexpenses_change_notifier.dart';
import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';
import 'microexpend_view.dart';

class MicroExpendEmptyCard extends StatelessWidget {
  final bool isExpanded;
  const MicroExpendEmptyCard({Key? key, this.isExpanded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? expandedMicroExpendEmptyCard(context)
        : collapsedMicroExpendEmptyCard(context);
  }

  Widget expandedMicroExpendEmptyCard(BuildContext context) {
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
            Text(AppLocalizations.of(context)!.no_goals,
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

  Widget collapsedMicroExpendEmptyCard(BuildContext context) {
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
                  child: Text(AppLocalizations.of(context)!.no_goals,
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
        MaterialPageRoute(
            builder: (_) => MultiProvider(providers: [
                  ChangeNotifierProvider(
                      create: (_) =>
                          Provider.of<MicroExpensesChangeNotifier>(context)),
                  ChangeNotifierProvider(
                      create: (_) => Provider.of<MovementsChangeNotifier>(
                          context,
                          listen: false))
                ], child: const MicroExpendView())));
  }
}
