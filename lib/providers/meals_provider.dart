import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/service/meals_service.dart';
// import 'package:riverpod/riverpod.dart';

class MealsNotifier extends StateNotifier<List<Meal>> {
  MealsNotifier() : super([]);

  Future<void> loadMeals() async {
    final meals = await getMealsService();
    state = meals;
  }

  Future<void> addMeal(Meal meal) async {
    // Add the meal to the server or database here
    // For example: await addMealService(meal);
    // After adding the meal, refresh the list
    await loadMeals();
  }
}

final mealsProvider = StateNotifierProvider<MealsNotifier, List<Meal>>((ref) {
  final notifier = MealsNotifier();
  notifier.loadMeals();
  return notifier;
});
