import 'package:binancy/controllers/providers/savings_plans_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/advice/advice_card.dart';
import 'package:binancy/views/savings_plan/savings_plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SavingsPlanView extends StatefulWidget {
  @override
  _SavingsPlanViewState createState() => _SavingsPlanViewState();
}

class _SavingsPlanViewState extends State<SavingsPlanView> {
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
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
          title: Text("Metas de ahorro", style: appBarStyle())),
      body: Consumer<SavingsPlanChangeNotifier>(
          builder: (context, provider, child) {
        print(provider.savingsPlanList.length);
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
              showAllSavingsPlan
                  ? Expanded(child: buildSavingsPlansWidgetList(provider))
                  : buildSavingsPlansWidgetList(provider),
              provider.savingsPlanList.length <= savingsPlanMaxCount
                  ? SizedBox()
                  : SpaceDivider(),
              provider.savingsPlanList.length <= savingsPlanMaxCount
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

  Container buildSavingsPlansWidgetList(SavingsPlanChangeNotifier provider) {
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
                  provider.savingsPlanList.elementAt(index), provider,
                  animate: firstRun),
              separatorBuilder: (context, index) => LinearDivider(),
              itemCount: showAllSavingsPlan
                  ? provider.savingsPlanList.length
                  : provider.savingsPlanList.length > savingsPlanMaxCount
                      ? savingsPlanMaxCount
                      : provider.savingsPlanList.length)),
    );
  }
}
