import 'package:intl/intl.dart';

import 'category.dart';

class Income {
  int idIncome = 0;
  int idUser = 0;
  dynamic value = 0;
  String description = "";
  Category category = Category();
  DateTime date = DateTime.now();

  Income();

  Income.fromJson(Map<String, dynamic> json)
      : idIncome = json['idIncome'],
        idUser = json['idUser'],
        value = json['value'],
        description = json['description'],
        date = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['date']);

  Map<String, dynamic> toJson() => {
        'idIncome': idIncome,
        'idUser': idUser,
        'value': value,
        'description': description,
        'date': date.toIso8601String()
      };
}
