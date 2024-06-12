import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/service/local_storage_service.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  final favoriteMealIds =
      LocalStorage.getStringListData('favoriteMealIds') ?? [];
  Future<bool> toggleMealFavoriteStatus(Meal meal) async {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      await LocalStorage.saveData(
          'favoriteMealIds', favoriteMealIds.remove(meal.id));
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      await LocalStorage.saveData(
          'favoriteMealIds', [...favoriteMealIds, meal.id]);
      state = [...state, meal];
      return true;
    }
  }

  Future<void> initializeFavorites(List<Meal> allMeals) async {
    if (favoriteMealIds.isEmpty) {
      return;
    }
    final favoriteMeals =
        allMeals.where((meal) => favoriteMealIds.contains(meal.id)).toList();
    state = favoriteMeals;
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>(
  (ref) {
    return FavoriteMealsNotifier();
  },
);
