import 'package:binancy/controllers/providers/plans_change_notifier.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/plan.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:binancy/views/advice/advice_card.dart';
import 'package:binancy/views/premium/premium_carousel_widget.dart';
import 'package:binancy/views/premium/premium_plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PremiumPlansView extends StatelessWidget {
  const PremiumPlansView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text("Hazte premium", style: appBarStyle()),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => PlansChangeNotifier()
                ..updatePlans()
                ..updateCarousel())
        ],
        child: Consumer<PlansChangeNotifier>(
            builder: (context, provider, child) => Container(
                  padding: EdgeInsets.only(top: customMargin),
                  child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView(
                        children: [
                          provider.carouselList.length > 0
                              ? CarouselSlider(
                                  items: buildCarouselWidgets(
                                      provider.carouselList),
                                  options: CarouselOptions(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3.5,
                                      autoPlay: true,
                                      enlargeCenterPage: true,
                                      autoPlayCurve: Curves.easeInOut))
                              : SizedBox(),
                          provider.carouselList.length > 0
                              ? SpaceDivider()
                              : SizedBox(),
                          Center(
                              child: Text("Planes disponibles",
                                  style: titleCardStyle())),
                          ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(customMargin),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => PremiumPlanCard(
                                  plan: provider.plansList.elementAt(index)),
                              separatorBuilder: (context, index) =>
                                  SpaceDivider(),
                              itemCount: provider.plansList.length)
                        ],
                      )),
                )),
      ),
    ));
  }

  List<Widget> buildPlansWidgets(List<Plan> plansList) {
    List<Widget> plansWidgetList = [];
    for (var plan in plansList) {
      plansWidgetList.add(PremiumPlanCard(
        plan: plan,
      ));
    }
    return plansWidgetList;
  }

  List<Widget> buildCarouselWidgets(List carouselList) {
    List<Widget> carouselWidgetList = [];
    for (var item in carouselList) {
      carouselWidgetList.add(PlansCarouselWidget(carouselWidget: item));
    }
    return carouselWidgetList;
  }
}
