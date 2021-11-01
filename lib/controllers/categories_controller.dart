import 'package:binancy/models/category.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';
import 'package:flutter/cupertino.dart';

class CategoriesController {
  static Future<List<Category>> getPredefinedCategories(
      BuildContext context) async {
    List<Category> categoryList = [];

    ConnAPI connAPI =
        ConnAPI(APIEndpoints.READ_PREDEFINED_CATEGORIES, "POST", false, {});
    await connAPI.callAPI();
    List<dynamic>? response = connAPI.getResponse();
    if (response != null) {
      for (var item in response) {
        Category category = Category.fromJson(item);
        category.getTitleByKey(context);
        category.getDescriptionByKey(context);
        categoryList.add(category);
      }
    }

    return categoryList;
  }

  static Future<List<Category>> getUserCategories(int userID) async {
    List<Category> categoryList = [];

    ConnAPI connAPI = ConnAPI(
        APIEndpoints.READ_USER_CATEGORIES, "POST", false, {"id": userID});
    await connAPI.callAPI();
    List<dynamic>? response = connAPI.getResponse();
    if (response != null) {
      for (var item in response) {
        categoryList.add(Category.fromJson(item));
      }
    }

    return categoryList;
  }

  static Future<List<Category>> getAllCategories(
      int userID, BuildContext context) async {
    return List.from(await getPredefinedCategories(context))
      ..addAll(await getUserCategories(userID));
  }

  static Future<bool> createCategory(Category category) async {
    ConnAPI connAPI =
        ConnAPI(APIEndpoints.CREATE_CATEGORY, "POST", false, category.toJson());
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> updateCategory(Category category) async {
    ConnAPI connAPI =
        ConnAPI(APIEndpoints.UPDATE_CATEGORY, "PUT", false, category.toJson());
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static Future<bool> deleteCategory(Category category) async {
    ConnAPI connAPI = ConnAPI(APIEndpoints.DELETE_CATEGORY, "DELETE", false,
        {'id': category.idCategory});
    await connAPI.callAPI();
    return connAPI.getStatus() == 200;
  }

  static List<String> toStringList(List<Category> categoryList) {
    List<String> parsedCategoryList = [];
    for (var element in categoryList) {
      parsedCategoryList.add(element.title);
    }

    return parsedCategoryList;
  }
}
