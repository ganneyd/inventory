import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  const SmallButton(
      {super.key, required this.buttonName, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.0,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0))),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsetsDirectional.all(10),
            child: Text(buttonName),
          )),
    );
  }
}
