import 'package:binancy/models/category.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/subscription.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';

import '../globals.dart';

class ExpensesController {
  static Future<bool> insertExpend(Expend expend) async {
    ConnAPI connAPI = ConnAPI(
        APIEndpoints.CREATE_EXPEND, "POST", false, {"data": expend.toJson()});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> updateExpend(Expend expend) async {
    ConnAPI connAPI = ConnAPI(
        APIEndpoints.UPDATE_EXPEND, "PUT", false, {"data": expend.toJson()});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> deleteExpend(Expend expend) async {
    ConnAPI connAPI = ConnAPI(
        APIEndpoints.DELETE_EXPEND, "DELETE", false, {"id": expend.idExpend});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }
}
