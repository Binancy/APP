import 'package:binancy/utils/utils.dart';

class SavingsPlan {
  int idSavingsPlan = 0;
  int idUser = 0;
  String name = "";
  String description = "";
  dynamic amount = 0;
  dynamic total = 0;
  DateTime? limitDate;

  SavingsPlan();

  SavingsPlan.fromJson(Map<String, dynamic> json)
      : idSavingsPlan = json['idSavingsPlan'],
        idUser = json['idUser'],
        name = json['name'],
        description = json['description'],
        amount = json['amount'],
        total = json['total'],
        limitDate = Utils.fromISOStandard(json['limitDate']);

  Map<String, dynamic> toJson() => {
        'idSavingsPlan': idSavingsPlan,
        'idUser': idUser,
        'name': name,
        'description': description,
        'amount': amount,
        'total': total,
        'limitDate': Utils.toISOStandard(limitDate ?? DateTime.now())
      };
}
