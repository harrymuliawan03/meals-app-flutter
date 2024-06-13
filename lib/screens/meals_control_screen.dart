import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/modules/filters/widgets/switch_filter.dart';
import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/modules/meals/widgets/meal_item_list.dart';
import 'package:meals_app/providers/filters_provider.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/screens/meal_add_screen.dart';
import 'package:meals_app/screens/meal_edit_screen.dart';
import 'package:meals_app/service/meals_service.dart';
import 'package:meals_app/widgets/custom_snackbar.dart';

class MealsControlScreen extends ConsumerStatefulWidget {
  const MealsControlScreen({super.key});

  @override
  ConsumerState<MealsControlScreen> createState() => _MealsControlScreenState();
}

class _MealsControlScreenState extends ConsumerState<MealsControlScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ref.refresh(mealsProvider); // Refresh the provider to fetch updated data
  }

  @override
  Widget build(BuildContext context) {
    final availableMealsAsyncValue = ref.watch(mealsProvider);

    void onDelete(int id) async {
      final bool result = await deleteMealService(id);

      if (result == true) {
        if (context.mounted) {
          showCustomSuccessSnackbar(context, 'Success Delete Data');
          ref.refresh(mealsProvider);
        }
      } else {
        showCustomSnackbar(context, 'Gagal Menghapus');
      }
    }

    void onEdit(BuildContext context, Meal availableMeals) async {
      final bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealEditScreen(meal: availableMeals),
        ),
      );

      if (result == true) {
        if (context.mounted) {
          showCustomSuccessSnackbar(context, 'Success Update Data');
          ref.refresh(mealsProvider);
        }
      }
    }

    void onAdd() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MealAddScreen()),
      );
      if (result == true) {
        if (context.mounted) {
          showCustomSuccessSnackbar(context, 'Success Create Data');
          ref.refresh(
              mealsProvider); // Refresh the provider after returning from the add screen
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals Control'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 30),
            onPressed: onAdd,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: availableMealsAsyncValue.isNotEmpty
          ? Container(
              margin: const EdgeInsets.all(24),
              child: ListView(
                children: availableMealsAsyncValue
                    .map((availableMeals) => MealItemList(
                          meal: availableMeals,
                          onEdit: onEdit,
                          onDelete: onDelete,
                        ))
                    .toList(),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
