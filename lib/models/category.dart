import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  void getTitleFromKey(BuildContext context) {
    if (isPredefined) {
      switch (title) {
        case "subscription":
          title = AppLocalizations.of(context)!.category_subscription;
          break;
        case "vital_income":
          title = AppLocalizations.of(context)!.category_vital_income;
          break;
        case "supplies":
          title = AppLocalizations.of(context)!.category_supplies;
          break;
        case "fashion_beauty":
          title = AppLocalizations.of(context)!.category_fashion_beauty;
          break;
        case "transport_travel":
          title = AppLocalizations.of(context)!.category_transport_travel;
          break;
        default:
      }
    }
  }
}
