import 'package:binancy/controllers/providers/movements_change_notifier.dart';
import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/advice/advice_card.dart';
import 'package:binancy/views/savings_plan/savings_plan_empty_widget.dart';
import 'package:binancy/views/savings_plan/savings_plan_view.dart';
import 'package:binancy/views/savings_plan/savings_plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (_) =>
                                      Provider.of<SavingsPlanChangeNotifier>(
                                          context),
                                )
                              ],
                              child: SavingsPlanView(),
                            ))),
                icon: Icon(Icons.add))
          ],
          title: Text("Metas de ahorro", style: appBarStyle())),
      body: Consumer2<SavingsPlanChangeNotifier, MovementsChangeNotifier>(
          builder: (context, savingsProvider, movementsProvider, child) {
        print(savingsProvider.savingsPlanList.length);
        return Container(
          child: Column(
            children: [
              SpaceDivider(),
              AdviceCard(
                  icon: SvgPicture.asset("assets/svg/dashboard_vault.svg"),
                  text:
                      "Establece metas de ahorro para cumplir en un tiempo determinado"),
              SpaceDivider(),
              Center(
                  child: Text("Tus metas de ahorro", style: titleCardStyle())),
              SpaceDivider(),
              savingsProvider.savingsPlanList.isEmpty
                  ? buildEmptySavingsPlanWidget()
                  : showAllSavingsPlan
                      ? Expanded(
                          child: buildSavingsPlansWidgetList(
                              savingsProvider, movementsProvider))
                      : buildSavingsPlansWidgetList(
                          savingsProvider, movementsProvider),
              savingsProvider.savingsPlanList.isEmpty
                  ? SizedBox()
                  : savingsProvider.savingsPlanList.length <=
                          savingsPlanMaxCount
                      ? SizedBox()
                      : SpaceDivider(),
              savingsProvider.savingsPlanList.isEmpty
                  ? SizedBox()
                  : savingsProvider.savingsPlanList.length <=
                          savingsPlanMaxCount
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(
                              left: customMargin, right: customMargin),
                          child: BinancyButton(
                              context: context,
                              text: showAllSavingsPlan
                                  ? "Ver menos"
                                  : "Ver todas tus metas de ahorro",
                              action: () => setState(() {
                                    showAllSavingsPlan = !showAllSavingsPlan;
                                  })))
            ],
          ),
        );
      }),
    ));
  }

  Container buildEmptySavingsPlanWidget() {
    return Container(
      margin: EdgeInsets.only(left: customMargin, right: customMargin),
      padding: EdgeInsets.all(customMargin),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: SavingsPlanEmptyWidget(isExpanded: true),
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
      margin: EdgeInsets.only(left: customMargin, right: customMargin),
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(customBorderRadius)),
      child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.separated(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shrinkWrap: !showAllSavingsPlan,
              itemBuilder: (context, index) => SavingsPlanWidget(
                  savingsProvider.savingsPlanList.elementAt(index),
                  savingsProvider,
                  movementsProvider.totalHeritage,
                  animate: firstRun),
              separatorBuilder: (context, index) => LinearDivider(),
              itemCount: showAllSavingsPlan
                  ? savingsProvider.savingsPlanList.length
                  : savingsProvider.savingsPlanList.length > savingsPlanMaxCount
                      ? savingsPlanMaxCount
                      : savingsProvider.savingsPlanList.length)),
    );
  }
}
