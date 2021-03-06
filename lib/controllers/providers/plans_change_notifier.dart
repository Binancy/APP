// ignore_for_file: must_call_super

import 'package:binancy/controllers/plans_controller.dart';
import 'package:binancy/models/plan.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/widgets.dart';

import '../../globals.dart';

class PlansChangeNotifier extends ChangeNotifier {
  bool updating = false;
  List<Plan> plansList = [];
  List<dynamic> carouselList = [];

  @override
  void dispose() {}

  Future<void> updateAll() async {
    if (await Utils.hasConnection().timeout(timeout)) {
      await updatePlans();
      await updateCarousel();
    }
  }

  Future<void> updatePlans() async {
    plansList = await PlansController.getAvaiablePlans();
    plansList.sort((a, b) => b.planAmount.compareTo(a.planAmount));
    notifyListeners();
  }

  Future<void> updateCarousel() async {
    carouselList = await PlansController.getAvaiableAnnounces();
    List<dynamic> offertsList = await PlansController.getAvaiableOfferts();
    for (var offert in offertsList) {
      carouselList.add(offert);
    }
    notifyListeners();
  }
}
