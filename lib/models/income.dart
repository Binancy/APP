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
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'idIncome': idIncome,
        'idUser': idUser,
        'value': value,
        'description': description,
      };
}
