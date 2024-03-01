import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final bool isDisabled;
  final String buttonName;
  final VoidCallback onPressed;
  const SmallButton(
      {super.key,
      required this.buttonName,
      required this.onPressed,
      this.isDisabled = false});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0))),
        onPressed: isDisabled ? null : onPressed,
        child: Padding(
          padding: const EdgeInsetsDirectional.all(10),
          child: Text(buttonName),
        ));
  }
}
