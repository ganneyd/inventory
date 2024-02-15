import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/presentation/pages/search_results/cubit/search_results_cubit.dart';
import 'package:inventory_v1/presentation/widgets/buttons/small_button_widget.dart';

Widget buildDrawer(
    {required List<CheckedOutEntity> checkedOutParts,
    required void Function(int index, int newQuantity) addCallback,
    required void Function(int index, int newQuantity) subtractCallback,
    required BuildContext context}) {
  return Drawer(
    child: Column(
      children: <Widget>[
        // Smaller fixed header using a Container for custom height
        Container(
          height: 100, // Set your desired height for the header
          width: double.infinity,
          padding: const EdgeInsets.all(16.0), // Add some padding if needed
          color: Colors.blue, // Background color for the header
          alignment: Alignment.center, // Align the text to the center if needed
          child: const Text(
            'Cart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20, // Adjust font size according to your header size
            ),
          ),
        ),
        // Scrollable part of the drawer
        Expanded(
            child: checkedOutParts.isEmpty
                ? const Text('No Part in Cart')
                : ListView.builder(
                    itemCount: checkedOutParts.length,
                    itemBuilder: (context, index) {
                      CheckedOutEntity checkedOutPart =
                          checkedOutParts[index]; // Current part
                      int checkoutQuantity = checkedOutPart
                          .checkedOutQuantity; // Default checkout quantity

                      // Extract the last 4 characters of the NSN
                      String nsn = checkedOutPart.part.nsn;
                      String lastFour =
                          nsn.length > 4 ? nsn.substring(nsn.length - 4) : nsn;

                      return ExpansionTile(
                        backgroundColor: Colors.blueAccent,

                        // Display the last 4 characters of the NSN and the part name
                        title: Text("$lastFour - ${checkedOutPart.part.name}"),
                        // Display the intended checkout quantity
                        subtitle: Text("Checkout: $checkoutQuantity"),
                        children: <Widget>[
                          // Row for plus and minus buttons and quantity display
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => checkoutQuantity > 1
                                    ? subtractCallback(
                                        index, checkoutQuantity - 1)
                                    : null,
                              ),
                              Text(checkoutQuantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => checkoutQuantity <
                                        checkedOutPart.part.quantity
                                    ? addCallback(index, checkoutQuantity + 1)
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel_rounded),
                                onPressed: () =>
                                    BlocProvider.of<SearchPartCubit>(context)
                                        .removeCheckoutPart(index),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  )),
        checkedOutParts.isEmpty
            ? Container()
            : Flex(direction: Axis.horizontal, children: [
                SmallButton(
                    buttonName: 'Checkout',
                    onPressed: () {
                      BlocProvider.of<SearchPartCubit>(context).checkout();
                      Navigator.of(context)
                          .pushNamed('/checkout', arguments: checkedOutParts);
                    })
              ]),
      ],
    ),
  );
}
