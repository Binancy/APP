import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Category {
  int idCategory = 0;
  int? idUser;
  String title = "";
  String? description;
  bool isPredefined = false;
  Color color = Colors.white;

  List<Income> categoryIncomes = [];
  List<Expend> categoryExpenses = [];

  Category();

  Category.fromJson(Map<String, dynamic> json)
      : idCategory = json['idCategory'],
        idUser = json['idUser'],
        isPredefined = json['isPredefined'] == 1 ? true : false,
        description = json['description'],
        color = Color(int.parse(json['color'])),
        title = json['title'];

  Map<String, dynamic> toJson() => {
        'idCategory': idCategory,
        'idUser': idUser,
        'title': title,
        'color': Utils.parseColour(color),
        'description': description,
        'isPredefined': isPredefined ? 1 : 0
      };

  void getTitleByKey(BuildContext context) {
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
      }
    }
  }

  void getDescriptionByKey(BuildContext context) {
    if (isPredefined) {
      switch (title) {
        case "subscription":
          description =
              AppLocalizations.of(context)!.category_subscription_desc;
          break;
        case "vital_income":
          description =
              AppLocalizations.of(context)!.category_vital_income_desc;
          break;
        case "supplies":
          description = AppLocalizations.of(context)!.category_supplies_desc;
          break;
        case "fashion_beauty":
          description =
              AppLocalizations.of(context)!.category_fashion_beauty_desc;
          break;
        case "transport_travel":
          description =
              AppLocalizations.of(context)!.category_transport_travel_desc;
          break;
      }
    }
  }

  double getTotalAmountOfThisCategoryMovements() {
    double totalAmount = 0;
    for (var movement in categoryIncomes) {
      totalAmount += movement.value;
    }
    return totalAmount;
  }
}
