import 'package:flutter/material.dart';
import 'package:meals_app/modules/categories/models/category.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {super.key, this.category, required this.onSelectCategory});

  final Category? category;
  final void Function() onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectCategory,
      borderRadius: BorderRadius.circular(16),
      splashColor: Theme.of(context).primaryColor,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
              colors: category != null
                  ? [
                      category!.color.withOpacity(0.55),
                      category!.color.withOpacity(0.9)
                    ]
                  : [
                      Colors.pink.withOpacity(0.55),
                      Colors.pink.withOpacity(0.9),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Text(
          category?.title ?? 'All',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
    );
  }
}
