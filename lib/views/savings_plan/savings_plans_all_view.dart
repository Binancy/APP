import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/views/advice/advice_card.dart';
import 'package:binancy/views/savings_plan/savings_plan_empty_widget.dart';
import 'package:binancy/views/savings_plan/savings_plan_view.dart';
import 'package:binancy/views/savings_plan/savings_plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavingsPlanAllView extends StatefulWidget {
  @override
  _SavingsPlanAllViewState createState() => _SavingsPlanAllViewState();
}

class _SavingsPlanAllViewState extends State<SavingsPlanAllView> {
  bool showAllSavingsPlan = false;
  bool firstRun = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => firstRun = false);
  }

  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                              create: (_) =>
                                  Provider.of<SavingsPlanChangeNotifier>(
                                      context),
                            )
                          ],
                          child: const SavingsPlanView(),
                        ))),
                icon: const Icon(Icons.add))
          ],
          title:
              Text(AppLocalizations.of(context)!.goals, style: appBarStyle())),
      body: Consumer2<SavingsPlanChangeNotifier, MovementsChangeNotifier>(
          builder: (context, savingsProvider, movementsProvider, child) {
        return Column(
          children: [
            const SpaceDivider(),
            AdviceCard(
                icon: SvgPicture.asset("assets/svg/dashboard_vault.svg"),
                text: AppLocalizations.of(context)!.goals_ad_description),
            const SpaceDivider(),
            Center(
                child: Text(AppLocalizations.of(context)!.your_goals,
                    style: titleCardStyle())),
            const SpaceDivider(),
            savingsProvider.savingsPlanList.isEmpty
                ? Expanded(child: buildEmptySavingsPlanWidget())
                : showAllSavingsPlan
                    ? Expanded(
                        child: buildSavingsPlansWidgetList(
                            savingsProvider, movementsProvider))
                    : buildSavingsPlansWidgetList(
                        savingsProvider, movementsProvider),
            savingsProvider.savingsPlanList.isEmpty
                ? const SizedBox()
                : savingsProvider.savingsPlanList.length <= savingsPlanMaxCount
                    ? const SizedBox()
                    : const SpaceDivider(),
            savingsProvider.savingsPlanList.isEmpty
                ? const SizedBox()
                : savingsProvider.savingsPlanList.length <= savingsPlanMaxCount
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: customMargin, right: customMargin),
                        child: BinancyButton(
                            context: context,
                            text: showAllSavingsPlan
                                ? AppLocalizations.of(context)!.see_less
                                : AppLocalizations.of(context)!.see_more,
                            action: () => setState(() {
                                  showAllSavingsPlan = !showAllSavingsPlan;
                                })))
          ],
        );
      }),
    ));
  }

  Container buildEmptySavingsPlanWidget() {
    return Container(
      margin: const EdgeInsets.only(
          left: customMargin, right: customMargin, bottom: customMargin),
      padding: const EdgeInsets.all(customMargin),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: const SavingsPlanEmptyWidget(isExpanded: true),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(customBorderRadius),
          color: themeColor.withOpacity(0.1)),
    );
  }

  Container buildSavingsPlansWidgetList(
      SavingsPlanChangeNotifier savingsProvider,
      MovementsChangeNotifier movementsProvider) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.separated(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shrinkWrap: !showAllSavingsPlan,
              itemBuilder: (_, index) => SavingsPlanWidget(
                  context,
                  savingsProvider.savingsPlanList.elementAt(index),
                  savingsProvider,
                  movementsProvider.totalHeritage,
                  animate: firstRun),
              separatorBuilder: (context, index) => const LinearDivider(),
              itemCount: showAllSavingsPlan
                  ? savingsProvider.savingsPlanList.length
                  : savingsProvider.savingsPlanList.length > savingsPlanMaxCount
                      ? savingsPlanMaxCount
                      : savingsProvider.savingsPlanList.length)),
    );
  }
}
