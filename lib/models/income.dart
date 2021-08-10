import 'package:binancy/utils/utils.dart';

import 'category.dart';

class Income {
  int idIncome = 0;
  int idUser = 0;
  dynamic value = 0;
  String title = "";
  String? description = "";
  Category? category = Category();
  DateTime date = DateTime.now();

  Income();

  Income.fromJson(Map<String, dynamic> json)
      : idIncome = json['idIncome'],
        idUser = json['idUser'],
        value = json['value'],
        title = json['title'],
        description = json['description'],
        date = Utils.fromISOStandard(json['date']);

  Map<String, dynamic> toJson() => {
        'idIncome': idIncome,
        'idUser': idUser,
        'value': value,
        'title': title,
        'description': description,
        'date': Utils.toISOStandard(date)
      };
}
