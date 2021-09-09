import 'package:binancy/models/microexpend.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';

class MicroExpensesController {
  static Future<List<MicroExpend>> getMicroExpenses(int userID) async {
    List<MicroExpend> microExpensesList = [];

    ConnAPI connAPI =
        ConnAPI(APIEndpoints.READ_MICROEXPENSES, "POST", false, {"id": userID});
    await connAPI.callAPI();
    if (connAPI.getStatus() == 200) {
      List<dynamic>? responseJSON = connAPI.getResponse();
      if (responseJSON != null) {
        for (var microexpend in responseJSON) {
          microExpensesList.add(MicroExpend.fromJson(microexpend));
        }
      }
    } else {
      print("[ERROR] - Error al obtener los microexpends del usuario...");
    }

    return microExpensesList;
  }

  static Future<bool> addMicroExpend(MicroExpend microExpend) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.CREATE_MICROEXPEND, "POST", false,
        {"data": microExpend.toJson()});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> updateMicroExpend(MicroExpend microExpend) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.UPDATE_MICROEXPEND, "PUT", false,
        {"data": microExpend.toJson()});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> deleteMicroExpend(MicroExpend microExpend) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.DELETE_MICROEXPEND, "DELETE", false,
        {"id": microExpend.idMicroExpend});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }
}
