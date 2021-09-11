import 'package:binancy/models/announce.dart';
import 'package:binancy/models/offert.dart';
import 'package:binancy/models/plan.dart';
import 'package:flutter_svg/svg.dart';

class PlansController {
  static Future<List<Plan>> getAvaiablePlans() async {
    List<Plan> plansList = [];
    for (var i = 0; i < 3; i++) {
      plansList.add(Plan()
        ..amount = 3.99
        ..title = "Example Plan"
        ..description = "This is an example plan"
        ..idPlan = "example_plan");
    }
    return plansList;
  }

  static Future<List<Offert>> getAvaiableOfferts() async {
    return [];
  }

  static Future<List<Announce>> getAvaiableAnnounces() async {
    List<Announce> announceList = [];
    announceList.add(Announce()
      ..description =
          "Mejora tu experiencia adquiriendo uno de los planes disponibles y desbloquea nuevas funciones"
      ..icon = SvgPicture.asset("assets/svg/dashboard_premium.svg"));

    return announceList;
  }
}
