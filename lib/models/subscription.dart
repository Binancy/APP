import 'package:binancy/controllers/subscriptions_controller.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class Subscription {
  int idSubscription = 0;
  int idUser = 0;
  String name = "";
  String? description;
  dynamic value = 0;
  int payDay = 0;
  Month latestMonth = Month.NONE;
  DateTime? date;

  Subscription();

  String getNextPayDay(BuildContext context) {
    DateTime today = Utils.getTodayDate();
    return Utils.toMD(
        DateTime(
            latestMonth.index == 12
                ? payDay >= today.day
                    ? today.year
                    : today.year + 1
                : today.year,
            latestMonth.index == 12
                ? Month.JANUARY.index
                : latestMonth.index + 1,
            payDay),
        context);
  }

  DateTime? getPayDayDate() {
    if (latestMonth == Month.NONE) {
      return null;
    } else {
      DateTime today = Utils.getTodayDate();
      return DateTime(
          latestMonth.index == 12
              ? payDay >= today.day
                  ? today.year
                  : today.year + 1
              : today.year,
          latestMonth.index == 12 ? Month.JANUARY.index : latestMonth.index + 1,
          payDay);
    }
  }

  Subscription.fromJson(Map<String, dynamic> json)
      : idSubscription = json['idSubscription'],
        idUser = json['idUser'],
        name = json['name'],
        description = json['description'],
        value = json['value'],
        payDay = json['payDay'],
        latestMonth = Month.values[json['latestMonth']] {
    date = getPayDayDate();
  }

  Map<String, dynamic> toJson() => {
        'idSubscription': idSubscription,
        'idUser': idUser,
        'name': name,
        'description': description,
        'value': value,
        'payDay': payDay,
        'latestMonth': latestMonth.index
      };
}
