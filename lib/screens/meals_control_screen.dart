import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meals_app/modules/filters/widgets/switch_filter.dart';
import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/modules/meals/widgets/meal_item_list.dart';
import 'package:meals_app/screens/meal_add_screen.dart';
import 'package:meals_app/screens/meal_edit_screen.dart';
import 'package:meals_app/service/meals_service.dart';
import 'package:meals_app/widgets/custom_snackbar.dart';

class MealsControlScreen extends StatefulWidget {
  const MealsControlScreen({super.key});

  @override
  _MealsControlScreenState createState() => _MealsControlScreenState();
}

class _MealsControlScreenState extends State<MealsControlScreen> {
  late Future<List<Meal>> _availableMealsFuture;

  @override
  void initState() {
    super.initState();
    _availableMealsFuture = fetchMeals();
  }

  Future<List<Meal>> fetchMeals() async {
    // Replace this with your actual service call
    return await getMealsService();
  }

  void onDelete(int id) async {
    final bool result = await deleteMealService(id);

    if (result == true) {
      if (context.mounted) {
        showCustomSuccessSnackbar(context, 'Success Delete Data');
        setState(() {
          _availableMealsFuture = fetchMeals();
        });
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
        setState(() {
          _availableMealsFuture = fetchMeals();
        });
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
        setState(() {
          _availableMealsFuture = fetchMeals();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<Meal>>(
        future: _availableMealsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No meals available'),
            );
          } else {
            final availableMeals = snapshot.data!;
            return Container(
              margin: const EdgeInsets.all(24),
              child: ListView(
                children: availableMeals
                    .map((availableMeals) => MealItemList(
                          meal: availableMeals,
                          onEdit: onEdit,
                          onDelete: onDelete,
                        ))
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
