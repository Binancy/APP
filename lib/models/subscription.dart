import 'package:binancy/utils/enums.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class Subscription {
  int idSubscription = 0;
  int idUser = 0;
  String name = "";
  String description = "";
  double value = 0;
  int payDay = 0;
  Month latestMonth = Month.NONE;

  Subscription();

  String getNextPayDay(BuildContext context) {
    return name +
        " - " +
        Utils.toMMD(
            DateTime(
                2021,
                latestMonth.index == 12
                    ? Month.JANUARY.index
                    : latestMonth.index + 1,
                payDay),
            context);
  }

  Subscription.fromJson(Map<String, dynamic> json)
      : idSubscription = json['idSubscription'],
        idUser = json['idUser'],
        name = json['name'],
        description = json['description'],
        value = json['value'],
        payDay = json['payDay'],
        latestMonth = Month.values[json['latestMonth']];

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
