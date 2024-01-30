import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  const LargeButton(
      {super.key, required this.buttonName, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.0,
      height: 350.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0))),
        onPressed: onPressed,
        child: Text(buttonName),
      ),
    );
  }
}
