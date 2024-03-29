import 'package:flutter/material.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/presentation/utils/number_input_formatter.dart';

class RestockPartDialog extends StatelessWidget {
  final PartEntity part;

  final void Function(int quantity, PartEntity partEntity) onOrder;

  const RestockPartDialog({
    required this.part,
    required this.onOrder,
  }) : super(key: const Key('restock-part-alert-dialog'));

  @override
  Widget build(BuildContext context) {
    int quantity = 1;
    final TextEditingController controller =
        TextEditingController(text: '$quantity');
    return AlertDialog(
      title: const Center(child: Text('Restock Part')),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Specify the quantity for'),
              Text(
                "${part.name}: $quantity",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: quantity > 1
                          ? () => setState(() {
                                quantity--;
                                controller.text = quantity.toString();
                              })
                          : null,
                      icon: const Icon(Icons.minimize)),
                  SizedBox(
                    width: 20,
                    child: TextField(
                        inputFormatters: [PositiveNumberInputFormatter()],
                        controller: controller,
                        onChanged: (value) {
                          var updatedQuantity = int.tryParse(value) ??
                              1; // Update the quantity based on input}
                          if (updatedQuantity <= part.quantity) {
                            // Use the 'setState' provided by StatefulBuilder to update the quantity
                            setState(() {
                              quantity = updatedQuantity;
                            });
                          }
                        }),
                  ),
                  IconButton(
                      onPressed: () => setState(() {
                            quantity++;
                            controller.text = quantity.toString();
                          }),
                      icon: const Icon(Icons.add)),
                ],
              ),
            ],
          );
        },
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
            ),
            TextButton(
              child: const Text('Restock'),
              onPressed: () {
                // Use the local 'quantity' variable when 'Add' is pressed
                onOrder(quantity, part);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      ],
    );
  }
}
