import 'package:binancy/controllers/plans_controller.dart';
import 'package:binancy/models/offert.dart';
import 'package:binancy/models/plan.dart';
import 'package:flutter/widgets.dart';

class PlansChangeNotifier extends ChangeNotifier {
  bool updating = false;
  List<Plan> plansList = [];
  List<dynamic> carouselList = [];

  Future<void> updatePlans() async {
    plansList = await PlansController.getAvaiablePlans();
    notifyListeners();
  }

  Future<void> updateCarousel() async {
    carouselList = await PlansController.getAvaiableAnnounces();
    carouselList += await PlansController.getAvaiableAnnounces();
    notifyListeners();
  }
}
