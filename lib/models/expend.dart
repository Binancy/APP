import 'package:binancy/models/category.dart';

class Expend {
  int idExpend = 0;
  int idUser = 0;
  double value = 0;
  String description = "";
  Category category = Category();

  Expend();

  Expend.fromJson(Map<String, dynamic> json)
      : idExpend = json['idExpend'],
        idUser = json['idUser'],
        value = json['value'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'idExpend': idExpend,
        'idUser': idUser,
        'value': value,
        'description': description,
      };
}
