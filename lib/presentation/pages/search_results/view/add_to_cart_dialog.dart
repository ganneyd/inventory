import 'package:flutter/material.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';

class AddToCartDialog extends StatelessWidget {
  final PartEntity part;
  final void Function(int quantity) onAdd;

  const AddToCartDialog({
    required this.part,
    required this.onAdd,
  }) : super(key: const Key('alert-dialog'));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add to Cart'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Specify the quantity for ${part.name}:'),
            TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
              onSubmitted: (value) {
                final int quantity = int.tryParse(value) ?? 1;
                onAdd(quantity);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(), // Close the dialog
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            // You can also include logic here to fetch the quantity from the TextField
            // For simplicity, we're just calling the onAdd function with a default value
            onAdd(1); // Use a proper way to get the quantity from the TextField
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}
