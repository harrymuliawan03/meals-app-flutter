import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/service/meals_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'testing_riverpod_provider.g.dart';

@riverpod
Future<List<Meal>> meals(MealsRef ref) async {
  final res = await getMealsService();
  return res;
}
