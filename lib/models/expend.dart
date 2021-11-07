import 'package:binancy/models/category.dart';
import 'package:binancy/utils/utils.dart';

import '../globals.dart';

class Expend {
  int idExpend = 0;
  int idUser = 0;
  dynamic value = 0;
  String title = "";
  String? description;
  Category? category;
  int? idCategory;

  DateTime date = DateTime.now();

  Expend();

  Expend.fromJson(Map<String, dynamic> json)
      : idExpend = json['idExpend'],
        idUser = json['idUser'],
        value = json['value'],
        title = json['title'],
        description = json['description'],
        idCategory = json['idCategory'],
        date = Utils.fromISOStandard(json['date']);

  Map<String, dynamic> toJson() => {
        'idExpend': idExpend,
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
