import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/savings_plan/savings_plan_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../globals.dart';

class SavingsPlanEmptyWidget extends StatelessWidget {
  final bool isExpanded;

  const SavingsPlanEmptyWidget({this.isExpanded = false});

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? expandedSavingsPlanEmptyWidget(context)
        : collapsedSavingsPlanEmptyWidget(context);
  }

  Widget expandedSavingsPlanEmptyWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => gotoAddSavingsPlan(context),
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

  Widget collapsedSavingsPlanEmptyWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: () => gotoAddSavingsPlan(context),
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

  void gotoAddSavingsPlan(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                        create: (_) =>
                            Provider.of<SavingsPlanChangeNotifier>(context))
                  ],
                  child: const SavingsPlanView(allowEdit: true),
                )));
  }
}
