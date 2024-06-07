import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/screens/meals_control_screen.dart';
import 'package:meals_app/service/meals_service.dart';
import 'package:meals_app/widgets/checkbox_widget.dart';
import 'package:meals_app/widgets/custom_snackbar.dart';
import 'package:meals_app/widgets/input_widget.dart';

class MealEditScreen extends StatefulWidget {
  final Meal meal;
  const MealEditScreen({super.key, required this.meal});

  @override
  State<MealEditScreen> createState() => _MealEditScreenState();
}

class _MealEditScreenState extends State<MealEditScreen> {
  final List<String> categories = [];
  final List<String> characteristics = [];
  Complexity complexity = Complexity.simple;
  String complexityValue = 'simple';
  List<String> ingredients = [];
  List<String> steps = [];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController imageUrlController;
  late final TextEditingController durationController;
  late final TextEditingController ingredientsController;
  late final TextEditingController stepsController;

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    titleController = TextEditingController(text: widget.meal.title);
    imageUrlController = TextEditingController(text: widget.meal.imageUrl);
    durationController =
        TextEditingController(text: widget.meal.duration.toString());
    ingredientsController =
        TextEditingController(text: widget.meal.ingredients.join(', '));
    stepsController = TextEditingController(text: widget.meal.steps.join(', '));

    // Initialize the other fields with the values from the passed Meal object
    categories.addAll(widget.meal.categories);
    characteristics.addAll([
      if (widget.meal.isGlutenFree) 'isGlutenFree',
      if (widget.meal.isVegan) 'isVegan',
      if (widget.meal.isVegetarian) 'isVegetarian',
      if (widget.meal.isLactoseFree) 'isLactoseFree',
    ]);

    complexity = widget.meal.complexity;
    complexityValue = widget.meal.complexity.toString().split('.').last;
    ingredients = widget.meal.ingredients;
    steps = widget.meal.steps;
  }

  List<String> splitToArray(String input) {
    List<String> items = [];

    // Use regular expression to split the string while ignoring commas within parentheses
    RegExp regex = RegExp(r',(?![^(]*\))');

    List<String> matches = input.split(regex);

    // Trim each item to remove leading/trailing whitespaces
    for (String match in matches) {
      items.add(match.trim());
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    void handleSubmit() async {
      setState(() {
        _isLoading = true;
      });
      ingredients = splitToArray(ingredientsController.text);
      steps = splitToArray(stepsController.text);

      categories.sort((a, b) {
        // Extract the numerical part and convert to int for comparison
        int numA = int.parse(a.substring(1));
        int numB = int.parse(b.substring(1));
        return numA.compareTo(numB);
      });
      final body = jsonEncode({
        "categories": categories,
        "title": titleController.text,
        "affordability": "affordable",
        "complexity": complexityValue,
        "imageUrl": imageUrlController.text,
        "duration": int.parse(durationController.text),
        "ingredients": ingredients,
        "steps": steps,
        "isGlutenFree": characteristics.contains('isGlutenFree'),
        "isVegan": characteristics.contains('isVegan'),
        "isVegetarian": characteristics.contains('isVegetarian'),
        "isLactoseFree": characteristics.contains('isLactoseFree')
      });

      final res = await updateMealService(body, int.parse(widget.meal.id));

      setState(() {
        _isLoading = false;
      });

      if (res) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => MealsControlScreen()),
        // );
        Navigator.pop(context, true);
      } else {
        showCustomSnackbar(context, 'Gagal Menyimpan');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Meals'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              InputWidget(
                label: 'Title',
                controller: titleController,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.start,
                // spacing: 20,
                children: availableCategories
                    .map(
                      (category) => CheckboxItem(
                        categories: categories,
                        onPress: (val) {
                          setState(() {
                            if (val!) {
                              categories.add(category.id);
                            } else {
                              categories.remove(category.id);
                            }
                          });
                        },
                        name: category.title,
                        category_code: category.id,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Characteristics',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.start,
                // spacing: 20,
                children: [
                  CheckboxItem(
                    categories: characteristics,
                    onPress: (val) {
                      setState(() {
                        if (val!) {
                          characteristics.add('isGlutenFree');
                        } else {
                          characteristics.remove('isGlutenFree');
                        }
                      });
                    },
                    name: 'Gluten Free',
                    category_code: 'isGlutenFree',
                  ),
                  CheckboxItem(
                    categories: characteristics,
                    onPress: (val) {
                      setState(() {
                        if (val!) {
                          characteristics.add('isVegan');
                        } else {
                          characteristics.remove('isVegan');
                        }
                      });
                    },
                    name: 'Vegan',
                    category_code: 'isVegan',
                  ),
                  CheckboxItem(
                    categories: characteristics,
                    onPress: (val) {
                      setState(() {
                        if (val!) {
                          characteristics.add('isVegetarian');
                        } else {
                          characteristics.remove('isVegetarian');
                        }
                      });
                    },
                    name: 'Vegetarian',
                    category_code: 'isVegetarian',
                  ),
                  CheckboxItem(
                    categories: characteristics,
                    onPress: (val) {
                      setState(() {
                        if (val!) {
                          characteristics.add('isLactoseFree');
                        } else {
                          characteristics.remove('isLactoseFree');
                        }
                      });
                    },
                    name: 'Lactose Free',
                    category_code: 'isLactoseFree',
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Complexity',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                children: <Widget>[
                  ListTile(
                    title: const Text('Simple'),
                    leading: Radio<Complexity>(
                      value: Complexity.simple,
                      groupValue: complexity,
                      onChanged: (Complexity? value) {
                        setState(() {
                          complexity = value!;
                          complexityValue = 'simple';
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Hard'),
                    leading: Radio<Complexity>(
                      value: Complexity.hard,
                      groupValue: complexity,
                      onChanged: (Complexity? value) {
                        setState(() {
                          complexity = value!;
                          complexityValue = 'hard';
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Challenging'),
                    leading: Radio<Complexity>(
                      value: Complexity.challenging,
                      groupValue: complexity,
                      onChanged: (Complexity? value) {
                        setState(() {
                          complexity = value!;
                          complexityValue = 'challenging';
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InputWidget(
                label: 'Image Url',
                controller: imageUrlController,
              ),
              const SizedBox(
                height: 20,
              ),
              InputWidget(
                label: 'Duration',
                controller: durationController,
              ),
              const SizedBox(
                height: 20,
              ),
              InputWidget(
                label: 'Ingredients',
                controller: ingredientsController,
              ),
              const SizedBox(
                height: 20,
              ),
              InputWidget(
                label: 'Steps',
                controller: stepsController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    handleSubmit();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  // height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(56),
                    color: _isLoading ? Colors.grey : Colors.purple,
                  ),
                  child: Center(
                    child: !_isLoading
                        ? const Text(
                            'UPDATE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
