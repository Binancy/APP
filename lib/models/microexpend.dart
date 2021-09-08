class MicroExpend {
  int idUser = 0;
  int idMicroExpend = 0;
  String title = "";
  String? description;
  dynamic amount = 0;

  MicroExpend();

  MicroExpend.fromJson(Map<String, dynamic> json)
      : idUser = json['idUser'],
        idMicroExpend = json['idMicroExpend'],
        title = json['title'],
        amount = json['amount'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'idMicroExpend': idMicroExpend,
        'title': title,
        'amount': amount,
        'description': description
      };
}
