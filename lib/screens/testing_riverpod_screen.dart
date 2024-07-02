import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/modules/meals/widgets/meal_item_list.dart';
import 'package:meals_app/providers/testing_riverpod_provider.dart';
import 'package:meals_app/screens/meal_add_screen.dart';
import 'package:meals_app/screens/meal_edit_screen.dart';
import 'package:meals_app/service/meals_service.dart';
import 'package:meals_app/widgets/custom_snackbar.dart';

class TestingRiverpodScreen extends ConsumerStatefulWidget {
  const TestingRiverpodScreen({super.key});

  @override
  ConsumerState<TestingRiverpodScreen> createState() =>
      _TestingRiverpodScreenState();
}

class _TestingRiverpodScreenState extends ConsumerState<TestingRiverpodScreen> {
  @override
  Widget build(BuildContext context) {
    final availableMealsAsyncValue = ref.watch(mealsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Riverpod'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 30),
            onPressed: () => _onAdd(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: availableMealsAsyncValue.when(
          data: (data) => _buildMealList(context, data),
          error: (error, stackTrace) => _buildError(error),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildMealList(BuildContext context, List<Meal> meals) {
    return ListView(
      children: meals
          .map((meal) => MealItemList(
                meal: meal,
                onEdit: _onEdit,
                onDelete: _onDelete,
              ))
          .toList(),
    );
  }

  Widget _buildError(Object error) {
    return Center(child: Text(error.toString()));
  }

  Future<void> _onDelete(int id) async {
    final bool result = await deleteMealService(id);
    if (result) {
      if (!mounted) return;
      showCustomSuccessSnackbar(context, 'Success Delete Data');
      ref.invalidate(mealsProvider);
    } else {
      if (!mounted) return;
      showCustomSnackbar(context, 'Failed to delete');
    }
  }

  Future<void> _onEdit(BuildContext context, Meal meal) async {
    final bool result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => MealEditScreen(meal: meal),
          ),
        ) ??
        false;

    if (result) {
      if (!mounted) return;
      showCustomSuccessSnackbar(context, 'Success Update Data');
      ref.invalidate(mealsProvider);
    }
  }

  Future<void> _onAdd(BuildContext context) async {
    final bool result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (context) => MealAddScreen()),
        ) ??
        false;

    if (result) {
      if (!mounted) return;
      showCustomSuccessSnackbar(context, 'Success Create Data');
      ref.invalidate(mealsProvider);
    }
  }
}
