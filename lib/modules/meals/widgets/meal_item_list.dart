import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/screens/meal_edit_screen.dart';

class MealItemList extends StatelessWidget {
  final Meal meal;
  final void Function(BuildContext context, Meal meal) onEdit;
  final void Function(String id) onDelete;
  const MealItemList(
      {super.key,
      required this.meal,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    List<String> categoriesFilter = availableCategories
        .where((v) => meal.categories.contains(v.id))
        .map((v) => v.title)
        .toList();

    print('categ $categoriesFilter');
    String categories = categoriesFilter.join(' ');

    void _showDeleteConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Confirm Deletion',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Are you sure you want to delete this ${meal.title}',
              style: const TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  onDelete(meal.id); // Perform the delete action
                },
              ),
            ],
          );
        },
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25.0), // Set the radius here
            child: Image.network(
              meal.imageUrl,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  categories,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              onEdit(context, meal);
            },
            child: const Icon(
              Icons.edit,
              size: 30,
              color: Colors.blue,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () => _showDeleteConfirmationDialog(context),
            child: const Icon(
              Icons.delete,
              size: 30,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
