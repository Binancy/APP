import 'package:binancy/models/category.dart';
import 'package:intl/intl.dart';

class Expend {
  int idExpend = 0;
  int idUser = 0;
  dynamic value = 0;
  String description = "";
  Category category = Category();
  DateTime date = DateTime.now();

  Expend();

  Expend.fromJson(Map<String, dynamic> json)
      : idExpend = json['idExpend'],
        idUser = json['idUser'],
        value = json['value'],
        description = json['description'],
        date = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['date']);

  Map<String, dynamic> toJson() => {
        'idExpend': idExpend,
        'idUser': idUser,
        'value': value,
        'description': description,
        'date': date.toIso8601String()
      };
}
