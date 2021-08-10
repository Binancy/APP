import 'package:binancy/models/category.dart';
import 'package:binancy/utils/api/conn_api.dart';
import 'package:binancy/utils/api/endpoints.dart';

class CategoriesController {
  static Future<List<Category>> getCategories(int userID) async {
    List<Category> categoryList = [];

    ConnAPI connAPI =
        ConnAPI(APIEndpoints.READ_CATEGORIES, "POST", false, {"id": userID});
    await connAPI.callAPI();
    List<dynamic>? response = connAPI.getResponse();
    if (response != null) {
      for (var item in response) {
        categoryList.add(Category.fromJson(item));
      }
    }

    return categoryList;
  }

  static List<String> toStringList(List<Category> categoryList) {
    List<String> parsedCategoryList = [];
    categoryList.forEach((element) {
      parsedCategoryList.add(element.name);
    });
    return parsedCategoryList;
  }
}
