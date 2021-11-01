import 'package:binancy/globals.dart';
import 'package:binancy/utils/utils.dart';

import 'category.dart';

class Income {
  int idIncome = 0;
  int idUser = 0;
  dynamic value = 0;
  String title = "";
  String? description;
  int? idCategory;
  Category? category;
  DateTime date = DateTime.now();

  Income();

  Income.fromJson(Map<String, dynamic> json)
      : idIncome = json['idIncome'],
        idUser = json['idUser'],
        value = json['value'],
        title = json['title'],
        description = json['description'],
        idCategory = json['idCategory'],
        date = Utils.fromISOStandard(json['date']);

  Map<String, dynamic> toJson() => {
        'idIncome': idIncome,
        'idUser': idUser,
        'value': value,
        'title': title,
        'description': description,
        'idCategory': idCategory,
        'date': Utils.toISOStandard(date)
      };

  void parseCategory() {
    for (var category in categoryList) {
      if (category.idCategory == idCategory) {
        this.category = category;
        break;
      }
    }
  }
}
