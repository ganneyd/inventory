import 'package:flutter/material.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/presentation/utils/number_input_formatter.dart';

class AddToCartDialog extends StatefulWidget {
  final PartEntity part;

  final void Function(int quantity) onAdd;

  const AddToCartDialog({
    required this.part,
    required this.onAdd,
  }) : super(key: const Key('alert-dialog'));

  @override
  State<AddToCartDialog> createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  late FocusNode _focusNode;

  int quantity = 1;
  late TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController(text: '$quantity');
    _focusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Add to Cart')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Specify the quantity for'),
          Text(
            "${widget.part.name}: $quantity",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    focusNode: _focusNode,
                    inputFormatters: [PositiveNumberInputFormatter()],
                    controller: controller,
                    onTapOutside: (event) => setState(() {
                          controller.text = quantity.toString();
                        }),
                    onEditingComplete: () => setState(() {
                          controller.text = quantity.toString();
                        }),
                    onChanged: (value) {
                      var updatedQuantity = int.tryParse(value) ??
                          1; // Update the quantity based on input}
                      if (updatedQuantity <= widget.part.quantity) {
                        // Use the 'setState' provided by StatefulBuilder to update the quantity
                        setState(() {
                          quantity = updatedQuantity;
                        });
                      } else {
                        setState(() {
                          quantity = widget.part.quantity;
                        });
                      }
                    }),
              ),
              IconButton(
                  onPressed: quantity < widget.part.quantity
                      ? () => setState(() {
                            quantity++;
                            controller.text = quantity.toString();
                          })
                      : null,
                  icon: const Icon(Icons.add)),
            ],
          ),
        ],
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
              child: const Text('Add'),
              onPressed: () {
                // Use the local 'quantity' variable when 'Add' is pressed
                widget.onAdd(quantity);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      ],
    );
  }
}
