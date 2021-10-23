// ignore_for_file: must_call_super

import 'package:binancy/controllers/categories_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/category.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/material.dart';

class CategoriesChangeNotifier extends ChangeNotifier {
  bool updating = false;

  List<Category> categoryList = [];
  List<Category> userCategoryList = [];
  List<Category> predefinedCategories = [];

  @override
  void dispose() {}

  Future<void> updateCategories() async {
    if (await Utils.hasConnection().timeout(timeout)) {
      await getCategories();
      notifyListeners();
    }
  }

  Future<void> getCategories() async {
    userCategoryList =
        await CategoriesController.getUserCategories(userData['idUser']);
    predefinedCategories = await CategoriesController.getPredefinedCategories();
    categoryList = List.from(predefinedCategories)..addAll(userCategoryList);
  }
}
