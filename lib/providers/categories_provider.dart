import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/modules/categories/models/category_model.dart';

class CategoryProvider extends StateNotifier<List<CategoryModel>> {
  CategoryProvider() : super([]);

  void updateCategories(List<CategoryModel> categories) {
    state = categories;
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoryProvider, List<CategoryModel>>((ref) {
  return CategoryProvider();
});
