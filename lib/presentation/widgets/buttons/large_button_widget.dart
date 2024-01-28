import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  const LargeButton({required this.buttonName, required this.onPressed})
      : super(key: const Key('-button'));
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.0,
      height: 350.0,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(buttonName),
      ),
    );
  }
}
