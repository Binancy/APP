import 'package:binancy/models/income.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';

class IncomesController {
  static Future<bool> insertIncome(Income income) async {
    ConnAPI connAPI = ConnAPI(
        APIEndpoints.CREATE_INCOME, "POST", false, {"data": income.toJson()});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> updateIncome(Income income) async {
    ConnAPI connAPI = ConnAPI(
        APIEndpoints.UPDATE_INCOME, "PUT", false, {"data": income.toJson()});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }
}
