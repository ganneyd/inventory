import 'package:flutter/material.dart';
import 'package:inventory_v1/presentation/widgets/buttons/small_button_widget.dart';

AlertDialog getBackToHomeDialog(
    {required String message,
    required BuildContext context,
    required BuildContext dialogContext}) {
  return AlertDialog(
    title: const Text('Cancel Checkout'),
    content: SizedBox(
      width: 250,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          message,
          softWrap: true,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SmallButton(
                buttonName: 'No',
                onPressed: () => Navigator.of(context).pushNamed('/home_page')),
            SmallButton(
                buttonName: 'Yes',
                onPressed: () => Navigator.of(dialogContext).pop()),
          ],
        )
      ]),
    ),
  );
}
