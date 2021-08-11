import 'package:binancy/models/category.dart';
import 'package:binancy/utils/utils.dart';

class Expend {
  int idExpend = 0;
  int idUser = 0;
  dynamic value = 0;
  String title = "";
  String? description;
  Category? category;
  DateTime date = DateTime.now();

  Expend();

  Expend.fromJson(Map<String, dynamic> json)
      : idExpend = json['idExpend'],
        idUser = json['idUser'],
        value = json['value'],
        title = json['title'],
        description = json['description'],
        date = Utils.fromISOStandard(json['date']);

  Map<String, dynamic> toJson() => {
        'idExpend': idExpend,
        'idUser': idUser,
        'value': value,
        'title': title,
        'description': description,
        'date': Utils.toISOStandard(date)
      };
}
