class Category {
  int idCategory = 0;
  String key = "";
  List categoryItems = [];

  Category();

  Category.fromJson(Map<String, dynamic> json)
      : idCategory = json['idCategory'],
        key = json['key'];

  Map<String, dynamic> toJson() => {
        'idCategory': idCategory,
        'idUser': key,
      };
}
