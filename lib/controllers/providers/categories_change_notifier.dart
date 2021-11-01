// ignore_for_file: must_call_super

import 'package:binancy/controllers/categories_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/category.dart';
import 'package:binancy/models/expend.dart';
import 'package:binancy/models/income.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/material.dart';

class CategoriesChangeNotifier extends ChangeNotifier {
  bool updating = false;

  List<Category> categoryList = [];
  List<Category> userCategoryList = [];
  List<Category> predefinedCategories = [];

  List<Income> incomesWithoutCategory = [];
  List<Expend> expensesWithoutCategory = [];

  @override
  void dispose() {}

  Future<void> updateCategories(BuildContext context) async {
    if (await Utils.hasConnection().timeout(timeout)) {
      await getCategories(context);
      notifyListeners();
    }
  }

  Future<void> getCategories(BuildContext context) async {
    userCategoryList =
        await CategoriesController.getUserCategories(userData['idUser']);
    predefinedCategories =
        await CategoriesController.getPredefinedCategories(context);
    categoryList = List.from(predefinedCategories)..addAll(userCategoryList);
  }
}
