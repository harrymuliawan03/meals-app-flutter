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
    await loadMeals();
  }
}

final mealsProvider = StateNotifierProvider<MealsNotifier, List<Meal>>((ref) {
  final notifier = MealsNotifier();
  notifier.loadMeals();
  return notifier;
});
