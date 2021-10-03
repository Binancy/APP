// ignore_for_file: prefer_const_constructors

import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/ui/widgets.dart';
import 'package:binancy/utils/utils.dart';
import 'package:binancy/views/advice/advice_binancy_view.dart';
import 'package:binancy/views/advice/advice_card.dart';
import 'package:binancy/views/advice/support_view.dart';
import 'package:binancy/views/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mailto/mailto.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../globals.dart';

class AdviceView extends StatefulWidget {
  const AdviceView({Key? key}) : super(key: key);

  @override
  State<AdviceView> createState() => _AdviceViewState();
}

class _AdviceViewState extends State<AdviceView> {
  bool singletonAutoPass = false;
  int adviceCurrentPage = 0;

  final InAppReview inAppReview = InAppReview.instance;
  List<AdviceCard> adviceCardList = [];
  late PageController advicePageController, registerPageController;

  @override
  void initState() {
    super.initState();
    advicePageController = PageController(initialPage: adviceCurrentPage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adviceCardList = Utils.getAllAdviceCards(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!singletonAutoPass) {
      autoForwardAdvices();
    }
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.help_advice,
            style: appBarStyle()),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SpaceDivider(),
            SizedBox(
                height: 125,
                child: PageView(
                    controller: advicePageController,
                    onPageChanged: (value) => adviceCurrentPage = value,
                    children: adviceCardList)),
            const SpaceDivider(),
            Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.only(
                    left: customMargin, right: customMargin),
                decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(customBorderRadius)),
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        buildAdviceRows().elementAt(index),
                    separatorBuilder: (context, index) => const LinearDivider(),
                    itemCount: buildAdviceRows().length)),
            const SpaceDivider(),
            reviewAppWidget()
          ],
        ),
      ),
    ));
  }

  Widget reviewAppWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: customMargin, right: customMargin),
      child: Material(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(customBorderRadius),
        child: InkWell(
          onTap: () async {
            inAppReview.openStoreListing();
          },
          borderRadius: BorderRadius.circular(customBorderRadius),
          child: Container(
            padding: EdgeInsets.only(top: customMargin, bottom: customMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                      5,
                      (index) => Icon(
                            Icons.star_rounded,
                            color: accentColor,
                          )),
                ),
                SpaceDivider(customSpace: 15),
                Text("¿Que te parece " + appName + "?",
                    style: titleCardStyle()),
                SpaceDivider(customSpace: 5),
                Text("Deja tu opinión en la Play Store", style: accentStyle()),
                SpaceDivider(customSpace: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                      5,
                      (index) => Icon(
                            Icons.star_rounded,
                            color: accentColor,
                          )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void autoForwardAdvices() async {
    singletonAutoPass = true;
    await Future.delayed(const Duration(seconds: autoPassAdviceInterval));
    adviceCurrentPage < adviceCardList.length - 1
        ? adviceCurrentPage++
        : adviceCurrentPage = 0;
    if (mounted) {
      advicePageController.animateToPage(adviceCurrentPage,
          duration: const Duration(milliseconds: adviceTransitionDuration),
          curve: Curves.easeOut);
      autoForwardAdvices();
    }
  }

  List<Widget> buildAdviceRows() {
    List<Widget> actionsRowList = [];
    actionsRowList
        .add(BinancyHeaderRow(text: AppLocalizations.of(context)!.actions));

    actionsRowList.add(BinancyActionRow(
        text: "Acerca de " + appName,
        action: () => Navigator.push(
            context,
            PageTransition(
                child: AdviceBinancyView(),
                type: PageTransitionType.rightToLeftWithFade))));
    actionsRowList.add(
        BinancyActionRow(text: "Preguntas frecuentes (FAQ)", action: () {}));
    actionsRowList.add(BinancyActionRow(
        text: "Enviar sugerencias",
        action: () => launch(
            Mailto(to: [supportEmail], subject: "Suggestion - " + appName)
                .toString())));
    actionsRowList.add(BinancyActionRow(
        text: AppLocalizations.of(context)!.support,
        action: () => Navigator.push(
            context,
            PageTransition(
                child: SupportView(),
                type: PageTransitionType.rightToLeftWithFade))));

    return actionsRowList;
  }
}
