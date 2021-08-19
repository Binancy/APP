import 'package:binancy/globals.dart';
import 'package:binancy/models/subscription.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';

class SubscriptionsController {
  static Future<List<Subscription>> getSubscriptions() async {
    List<Subscription> subscriptionsList = [];

    ConnAPI connAPI = ConnAPI(APIEndpoints.READ_SUBSCRIPTIONS, "POST", false,
        {"id": userData['idUser']});
    await connAPI.callAPI();
    List<dynamic>? responseJSON = connAPI.getResponse();
    if (responseJSON != null) {
      for (var subscription in responseJSON) {
        subscriptionsList.add(Subscription.fromJson(subscription));
      }
    }

    return subscriptionsList;
  }
}
