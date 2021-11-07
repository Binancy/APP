import '../globals.dart';
import 'category.dart';

class MicroExpend {
  int idUser = 0;
  int idMicroExpend = 0;
  String title = "";
  String? description;
  dynamic amount = 0;
  Category? category;
  int? idCategory;

  MicroExpend();

  MicroExpend.fromJson(Map<String, dynamic> json)
      : idUser = json['idUser'],
        idMicroExpend = json['idMicroExpend'],
        title = json['title'],
        amount = json['amount'],
        idCategory = json['idCategory'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'idMicroExpend': idMicroExpend,
        'title': title,
        'amount': amount,
        'idCategory': idCategory,
        'description': description
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
