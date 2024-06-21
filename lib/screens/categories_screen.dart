import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/modules/categories/models/category.dart';
import 'package:meals_app/modules/categories/models/category_model.dart';
import 'package:meals_app/modules/categories/widgets/category_item.dart';
import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/providers/categories_provider.dart';
import 'package:meals_app/screens/meals_screen.dart';
import 'package:meals_app/service/categories_service.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.availableMeals,
  });

  final List<Meal> availableMeals;

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCategories();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _getCategories() async {
    setState(() {
      isLoading = true;
    });
    final res = await getCategoriesService();
    if (res.isNotEmpty) {
      ref.read(categoriesProvider.notifier).updateCategories(res);
    }
    setState(() {
      isLoading = false;
    });
  }

  void _selectedCategoty(BuildContext context, CategoryModel? category) {
    if (category == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => MealsScreen(
            meals: widget.availableMeals,
            title: 'All',
          ),
        ),
      );
    } else {
      final filteredMeals = widget.availableMeals
          .where(
            (meal) => meal.categories.contains(category.id),
          )
          .toList();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => MealsScreen(
            meals: filteredMeals,
            title: category.name,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableCategories = ref.watch(categoriesProvider);

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : AnimatedBuilder(
            animation: _animationController,
            child: GridView(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              children: [
                CategoryItem(
                    category: null,
                    onSelectCategory: () {
                      _selectedCategoty(context, null);
                    }),
                for (final category in availableCategories)
                  CategoryItem(
                      category: category,
                      onSelectCategory: () {
                        _selectedCategoty(context, category);
                      })
              ],
            ),
            builder: (ctx, child) => SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.3),
                end: const Offset(0, 0),
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: child,
            ),
          );
  }
}
