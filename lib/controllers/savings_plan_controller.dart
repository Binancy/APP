import 'package:binancy/models/savings_plan.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';

class SavingsPlansController {
  static Future<List<SavingsPlan>> getSavingsPlans(int idUser) async {
    List<SavingsPlan> savingsPlanList = [];
    ConnAPI connAPI =
        ConnAPI(APIEndpoints.READ_SAVINGS_PLAN, "POST", false, {"id": idUser});
    await connAPI.callAPI();
    if (connAPI.getStatus() == 200) {
      List<dynamic>? responseJSON = connAPI.getResponse();
      if (responseJSON != null) {
        for (var subscription in responseJSON) {
          savingsPlanList.add(SavingsPlan.fromJson(subscription));
        }
      }
    } else {
      print("[ERROR] - Error al obtener los savings plans");
    }

    return savingsPlanList;
  }

  static Future<bool> addSavingsPlan(SavingsPlan savingsPlan) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.CREATE_SAVINGS_PLAN, "POST", false,
        {"data": savingsPlan.toJson()});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> updateSavingsPlan(SavingsPlan savingsPlan) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.UPDATE_SAVINGS_PLAN, "PUT", false,
        {"data": savingsPlan.toJson()});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> deleteSavingsPlan(SavingsPlan savingsPlan) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.DELETE_SAVINGS_PLAN, "DELETE", false,
        {"id": savingsPlan.idSavingsPlan});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }
}
