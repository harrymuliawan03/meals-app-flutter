import 'package:flutter/material.dart';
import 'package:meals_app/modules/filters/widgets/switch_filter.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key, required this.currentFilters});

  final Map<Filter, bool> currentFilters;

  @override
  State<FiltersScreen> createState() {
    return _FiltersScreenState();
  }
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _isGlutterFree = false;
  bool _isLactoseFree = false;
  bool _isVegetarianFree = false;
  bool _isVeganFree = false;

  @override
  void initState() {
    super.initState();
    _isGlutterFree = widget.currentFilters[Filter.glutenFree]!;
    _isLactoseFree = widget.currentFilters[Filter.lactoseFree]!;
    _isVegetarianFree = widget.currentFilters[Filter.vegetarian]!;
    _isVeganFree = widget.currentFilters[Filter.vegan]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yours Filters'),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          Navigator.of(context).pop(
            {
              Filter.glutenFree: _isGlutterFree,
              Filter.lactoseFree: _isLactoseFree,
              Filter.vegetarian: _isVegetarianFree,
              Filter.vegan: _isVeganFree,
            },
          );
        },
        child: Column(
          children: [
            SwitchFilter(
              checkedValue: _isGlutterFree,
              onChecked: (isChecked) {
                setState(() {
                  _isGlutterFree = isChecked;
                });
              },
              title: 'Gluten-free',
              subTitle: 'Only include gluten-free meals.',
            ),
            SwitchFilter(
              checkedValue: _isLactoseFree,
              onChecked: (isChecked) {
                setState(() {
                  _isLactoseFree = isChecked;
                });
              },
              title: 'Lactose-free',
              subTitle: 'Only include lactose-free meals.',
            ),
            SwitchFilter(
              checkedValue: _isVegetarianFree,
              onChecked: (isChecked) {
                setState(() {
                  _isVegetarianFree = isChecked;
                });
              },
              title: 'Vegetarian-free',
              subTitle: 'Only include vegetarian-free meals.',
            ),
            SwitchFilter(
              checkedValue: _isVeganFree,
              onChecked: (isChecked) {
                setState(() {
                  _isVeganFree = isChecked;
                });
              },
              title: 'Vegan-free',
              subTitle: 'Only include vegan-free meals.',
            ),
          ],
        ),
      ),
    );
  }
}
