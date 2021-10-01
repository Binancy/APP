// ignore_for_file: avoid_print

import 'package:binancy/controllers/categories_controller.dart';
import 'package:binancy/models/category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Testing "/api/incomes/latestIncomes" call', () async {
    List<Category> categoryList = await CategoriesController.getCategories(5);
    print(categoryList);
  });
}
