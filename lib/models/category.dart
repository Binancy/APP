class Category {
  int idCategory = 0;
  int idUser = 0;
  String name = "";

  Category();

  Category.fromJson(Map<String, dynamic> json)
      : idCategory = json['idCategory'],
        idUser = json['idUser'],
        name = json['name'];

  Map<String, dynamic> toJson() =>
      {'idCategory': idCategory, 'idUser': idUser, 'name': name};
}
