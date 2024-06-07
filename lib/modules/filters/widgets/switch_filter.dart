import 'package:flutter/material.dart';

class SwitchFilter extends StatelessWidget {
  const SwitchFilter(
      {super.key,
      required this.checkedValue,
      required this.onChecked,
      required this.title,
      required this.subTitle});

  final bool checkedValue;
  final void Function(bool isChecked) onChecked;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: checkedValue,
      onChanged: (isChecked) {
        onChecked(isChecked);
      },
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
      subtitle: Text(
        subTitle,
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
      activeColor: Colors.blue,
      contentPadding: const EdgeInsets.only(left: 34, right: 22),
    );
  }
}
