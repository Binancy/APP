import 'package:binancy/controllers/expenses_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/subscription.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';

enum Month {
  NONE,
  JANUARY,
  FEBRUARY,
  MARCH,
  APRIL,
  MAY,
  JUNE,
  JULY,
  AUGUST,
  SEPTEMBER,
  OCTOBER,
  NOVEMBER,
  DECEMEBER
}

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

  static Future<bool> paySubscription(Subscription subscription) async {
    Expend subscriptionToExpend = Expend()
      // ..category = Category.subscriptionCategory()
      ..date = subscription.getPayDayDate()!
      ..description = subscription.description
      ..idUser = userData['idUser']
      ..title = subscription.name
      ..value = subscription.value;

    return await ExpensesController.insertExpend(subscriptionToExpend);
  }

  static Future<bool> updateSubscriptionLatestMonth(
      Subscription subscription) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.UPDATE_SUBSCRIPTION, "PUT", false,
        {"data": subscription.toJson()});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> checkSubscriptions(
      List<Subscription> subscriptionList) async {
    DateTime today = DateTime.now();
    bool notifyListeners = false;

    for (var subscription in subscriptionList) {
      bool update = false;
      Subscription backup = subscription;

      if (today.month == 1 && subscription.latestMonth.index == 12) {
        // ESTAMOS EN ENERO Y EL ULTIMO MES PAGADO ES DICIEMBRE (DEL AÑO PASADO)
        if (subscription.payDay <= today.day) {
          if (await paySubscription(subscription)) {
            subscription.latestMonth = Month.JANUARY;
            update = true;
          }
        }
      } else if (today.month == 2) {
        // ES FEBRERO
        if (today.year % 4 == 0) {
          if (subscription.payDay >= 29 &&
                  subscription.latestMonth.index == today.month - 1 ||
              subscription.latestMonth.index == 0) {
            // ES BISIESTO Y ES 29 O MÁS ADELANTE
            if (today.day >= 29 &&
                    subscription.latestMonth.index == today.month - 1 ||
                subscription.latestMonth.index == 0) {
              if (await paySubscription(subscription)) {
                subscription.latestMonth = Month.FEBRUARY;
                update = true;
              }
            }
          } else {
            // ES BISIESTO Y ES ANTES DEL 29
            if (today.day < 29 &&
                    subscription.latestMonth.index == today.month - 1 ||
                subscription.latestMonth.index == 0) {
              if (await paySubscription(subscription)) {
                subscription.latestMonth = Month.FEBRUARY;
                update = true;
              }
            }
          }
        } else {
          if (subscription.payDay >= 28 &&
                  subscription.latestMonth.index == today.month - 1 ||
              subscription.latestMonth.index == 0) {
            // NO ES BISIESTO Y ES 28 O MÁS ADELANTE
            if (today.day >= 28 &&
                    subscription.latestMonth.index == today.month - 1 ||
                subscription.latestMonth.index == 0) {
              if (await paySubscription(subscription)) {
                subscription.latestMonth = Month.FEBRUARY;
                update = true;
              }
            }
          } else {
            // NO ES BISIESTO Y ES ANTES DEL 28
            if (today.day < 28 &&
                    subscription.latestMonth.index == today.month - 1 ||
                subscription.latestMonth.index == 0) {
              if (await paySubscription(subscription)) {
                subscription.latestMonth = Month.FEBRUARY;
                update = true;
              }
            }
          }
        }
      } else {
        if (today.month == 12) {
          if (subscription.payDay <= today.day &&
                  subscription.latestMonth.index == today.month - 1 ||
              subscription.latestMonth.index == 0) {
            if (await paySubscription(subscription)) {
              subscription.latestMonth = Month.DECEMEBER;
              update = true;
            }
          }
        } else {
          if (DateTime(today.year, today.month + 1, 0).day == 31) {
            // ESTE MES ACABA EN 31
            if (subscription.payDay <= today.day &&
                    subscription.latestMonth.index == today.month - 1 ||
                subscription.latestMonth.index == 0) {
              if (await paySubscription(subscription)) {
                subscription.latestMonth = Month.values[today.month];
                update = true;
              }
            }
          } else {
            // ESTE MES ACABA EN 30
            if (subscription.payDay > 30 ||
                subscription.payDay <= today.day &&
                    subscription.latestMonth.index == today.month - 1 ||
                subscription.latestMonth.index == 0) {
              if (await paySubscription(subscription)) {
                subscription.latestMonth = Month.values[today.month];
                update = true;
              }
            }
          }
        }
      }

      if (update) {
        if (await updateSubscriptionLatestMonth(subscription)) {
          notifyListeners = true;
        } else {
          subscription = backup;
        }
      }
    }

    return notifyListeners;
  }

  static Future<bool> deleteSubscription(Subscription subscription) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.DELETE_SUBSCRIPTION, "DELETE", false,
        {"id": subscription.idSubscription});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> addSubscription(Subscription subscription) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.CREATE_SUBSCRIPTION, "POST", false,
        {"data": subscription.toJson()});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> updateSubscription(Subscription subscription) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.UPDATE_SUBSCRIPTION, "PUT", false,
        {"data": subscription.toJson()});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }
}
