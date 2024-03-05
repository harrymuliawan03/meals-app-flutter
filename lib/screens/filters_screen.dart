import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/modules/filters/widgets/switch_filter.dart';
import 'package:meals_app/providers/filters_provider.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filtersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yours Filters'),
      ),
      body: Column(
        children: [
          SwitchFilter(
            checkedValue: activeFilters[Filter.glutenFree]!,
            onChecked: (isChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.glutenFree, isChecked);
            },
            title: 'Gluten-free',
            subTitle: 'Only include gluten-free meals.',
          ),
          SwitchFilter(
            checkedValue: activeFilters[Filter.lactoseFree]!,
            onChecked: (isChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.lactoseFree, isChecked);
            },
            title: 'Lactose-free',
            subTitle: 'Only include lactose-free meals.',
          ),
          SwitchFilter(
            checkedValue: activeFilters[Filter.vegetarian]!,
            onChecked: (isChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.vegetarian, isChecked);
            },
            title: 'Vegetarian-free',
            subTitle: 'Only include vegetarian-free meals.',
          ),
          SwitchFilter(
            checkedValue: activeFilters[Filter.vegan]!,
            onChecked: (isChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.vegan, isChecked);
            },
            title: 'Vegan-free',
            subTitle: 'Only include vegan-free meals.',
          ),
        ],
      ),
    );
  }
}
