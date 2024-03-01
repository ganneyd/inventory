import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox(
      {required this.onChanged,
      required this.checkBoxName,
      required this.value,
      super.key});
  final void Function(bool?) onChanged;
  final String checkBoxName;
  final bool value;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      const Padding(padding: EdgeInsets.only(left: 10)),
      Checkbox(value: value, onChanged: onChanged),
      const Padding(padding: EdgeInsets.only(right: 10)),
      Text(
        checkBoxName,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    ]);
  }
}
