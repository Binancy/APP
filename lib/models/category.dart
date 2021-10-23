class Category {
  int idCategory = 0;
  int? idUser;
  String title = "";
  String? description;
  bool isPredefined = false;

  Category();

  Category.fromJson(Map<String, dynamic> json)
      : idCategory = json['idCategory'],
        idUser = json['idUser'],
        isPredefined = json['isPredefined'] == 1 ? true : false,
        description = json['description'],
        title = json['title'];

  Map<String, dynamic> toJson() => {
        'idCategory': idCategory,
        'idUser': idUser,
        'title': title,
        'description': description,
        'isPredefined': isPredefined ? 1 : 0
      };
}
