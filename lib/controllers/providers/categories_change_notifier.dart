import 'package:binancy/controllers/categories_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/models/category.dart';
import 'package:flutter/material.dart';

class CategoriesChangeNotifier extends ChangeNotifier {
  bool updating = false;

  @override
  void dispose() {}

  void updateCategories() async {
    isUpdating(true);
    await getCategories();
    isUpdating(false);
  }

  void isUpdating(bool isUpdating) {
    updating = isUpdating;
    notifyListeners();
  }

  Future<void> getCategories() async {
    categoryList = await CategoriesController.getCategories(userData['idUser']);
  }
}
