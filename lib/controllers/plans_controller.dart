import 'package:binancy/models/announce.dart';
import 'package:binancy/models/offert.dart';
import 'package:binancy/models/plan.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:flutter_svg/svg.dart';

class PlansController {
  static Future<List<Plan>> getAvaiablePlans() async {
    List<Plan> plansList = [];

    ConnAPI connAPI = ConnAPI(APIEndpoints.READ_PLANS, "POST", false, {});
    await connAPI.callAPI();
    if (connAPI.getStatus() == 200) {
      List<dynamic>? responseJSON = connAPI.getResponse();
      if (responseJSON != null) {
        for (var plan in responseJSON) {
          plansList.add(Plan.fromJson(plan));
        }
      }
    } else {
      print("[ERROR] - Unable to get plans");
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
