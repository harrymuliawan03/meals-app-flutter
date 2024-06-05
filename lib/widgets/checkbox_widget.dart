import 'package:flutter/material.dart';

class CheckboxItem extends StatelessWidget {
  final List<String> categories;
  final String category_code;
  final String name;
  final void Function(bool val) onPress;

  const CheckboxItem({
    super.key,
    required this.categories,
    required this.onPress,
    required this.name,
    required this.category_code,
  });

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.white;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 1.2, // Set the scale factor to adjust the size
          child: Checkbox(
            checkColor: Colors.blue,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: categories.contains(category_code),
            onChanged: (bool? value) {
              onPress(value!);
              // setState(() {
              //   if (value!) {
              //     categories.add('data1');
              //   } else {
              //     categories.remove('data1');
              //   }
              // });
            },
          ),
        ),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
