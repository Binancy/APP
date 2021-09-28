// ignore_for_file: must_call_super

import 'package:binancy/controllers/categories_controller.dart';
import 'package:binancy/globals.dart';
import 'package:binancy/utils/utils.dart';
import 'package:flutter/material.dart';

class CategoriesChangeNotifier extends ChangeNotifier {
  bool updating = false;

  @override
  void dispose() {}

  Future<void> updateCategories() async {
    if (await Utils.hasConnection().timeout(timeout)) {
      await getCategories();
      notifyListeners();
    }
  }

  Future<void> getCategories() async {
    categoryList = await CategoriesController.getCategories(userData['idUser']);
  }
}
