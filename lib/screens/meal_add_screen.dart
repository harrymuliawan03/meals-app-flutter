import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/providers/categories_provider.dart';
import 'package:meals_app/service/meals_service.dart';
import 'package:meals_app/shared/helpers/helpers.dart';
import 'package:meals_app/widgets/checkbox_widget.dart';
import 'package:meals_app/widgets/custom_snackbar.dart';
import 'package:meals_app/widgets/input_widget.dart';

class MealAddScreen extends ConsumerStatefulWidget {
  const MealAddScreen({super.key});

  @override
  ConsumerState<MealAddScreen> createState() => _MealAddScreenState();
}

class _MealAddScreenState extends ConsumerState<MealAddScreen>
    with SingleTickerProviderStateMixin {
  final List<String> categories = [];
  final List<String> characteristics = [];
  Complexity complexity = Complexity.simple;
  String complexityValue = 'simple';
  List<String> ingredients = [];
  List<String> steps = [];
  XFile? selectedImage;

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isAddingSuccess = false;

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController(text: '');
  final imageUrlController = TextEditingController(text: '');
  final durationController = TextEditingController(text: '');
  final ingredientsController = TextEditingController(text: '');
  final stepsController = TextEditingController(text: '');

  double valueProgress = 0.0;
  bool _isLoading = false;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: valueProgress,
    ).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && _isAddingSuccess) {
          Navigator.pop(context, true);
        }
      });
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    titleController.dispose();
    imageUrlController.dispose();
    durationController.dispose();
    ingredientsController.dispose();
    stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAvailable = ref.watch(categoriesProvider);

    void progressIndicator(int count, int total) {
      print(count / total);
      setState(() {
        valueProgress = count / total;
      });
    }

    void handleSubmit() async {
      setState(() {
        _isLoading = true;
      });
      _animationController.forward();
      ingredients = splitToArray(ingredientsController.text);
      steps = splitToArray(stepsController.text);

      if (categories.isEmpty) {
        categories.addAll(categoriesAvailable.map((e) => e.slug).toList());
      }

      if (characteristics.isEmpty) {
        characteristics.addAll(
            ['isGlutenFree', 'isVegan', 'isVegetarian', 'isLactoseFree']);
      }

      categories.sort((a, b) {
        return a.compareTo(b);
      });

      final body = jsonEncode({
        "categories": categories,
        "title": titleController.text,
        "affordability": "affordable",
        "complexity": complexityValue,
        "duration": int.parse(durationController.text),
        "ingredients": ingredients,
        "steps": steps,
        "image": selectedImage != null
            ? 'data:image/png;base64,${base64Encode(File(selectedImage!.path).readAsBytesSync())}'
            : null,
        "isGlutenFree": characteristics.contains('isGlutenFree'),
        "isVegan": characteristics.contains('isVegan'),
        "isVegetarian": characteristics.contains('isVegetarian'),
        "isLactoseFree": characteristics.contains('isLactoseFree')
      });

      final res = await createMealService(body, progressIndicator);

      setState(() {
        _isLoading = false;
      });
      if (res) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => MealsControlScreen()),
        // );
        // Navigator.pop(context, true);
        setState(() {
          _isAddingSuccess = true;
        });
      } else {
        showCustomSnackbar(context, 'Gagal Menyimpan');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meals'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  children: categoriesAvailable
                      .map(
                        (category) => CheckboxItem(
                          categories: categories,
                          onPress: (val) {
                            setState(() {
                              if (val) {
                                categories.add(category.slug);
                              } else {
                                categories.remove(category.slug);
                              }
                            });
                          },
                          name: category.name,
                          category_code: category.slug,
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
                GestureDetector(
                  onTap: () async {
                    final image = await selectImage();

                    setState(() {
                      selectedImage = image;
                    });
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.grey,
                      image: selectedImage == null
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(
                                  selectedImage!.path,
                                ),
                              ),
                            ),
                    ),
                    child: selectedImage != null
                        ? null
                        : Center(
                            child: Image.asset(
                              'assets/ic_upload.png',
                              width: 32,
                              height: 32,
                            ),
                          ),
                  ),
                ),
                // InputWidget(
                //   label: 'Image Url',
                //   controller: imageUrlController,
                // ),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0,
                      end: valueProgress,
                    ),
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      // backgroundColor: kLightBackgroundColor,
                      // valueColor: AlwaysStoppedAnimation(kGreenColor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      handleSubmit();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: !_isLoading
                          ? const Text(
                              'SUBMIT',
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
            )),
      ),
    );
    ;
  }
}
