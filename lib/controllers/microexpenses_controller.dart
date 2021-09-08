import 'package:binancy/models/microexpend.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';

class MicroExpensesController {
  static Future<List<MicroExpend>> getMicroExpenses(int userID) async {
    List<MicroExpend> microExpensesList = [];

    /* ConnAPI connAPI =
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
      print(connAPI.getException()!.description);
    } */

    microExpensesList.add(MicroExpend()
      ..amount = 150
      ..title = "This is an exaple MicroExpend"
      ..idUser = 0
      ..idMicroExpend = 0);

    microExpensesList.add(MicroExpend()
      ..amount = 150
      ..title = "This is an exaple MicroExpend"
      ..idUser = 0
      ..idMicroExpend = 0);

    microExpensesList.add(MicroExpend()
      ..amount = 150
      ..title = "This is an exaple MicroExpend"
      ..idUser = 0
      ..idMicroExpend = 0);

    return microExpensesList;
  }
}
