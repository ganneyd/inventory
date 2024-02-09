import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/data/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/presentation/pages/search_results/cubit/search_results_cubit.dart';
import 'package:inventory_v1/presentation/widgets/buttons/small_button_widget.dart';

Widget buildDrawer(
    {required List<CheckedOutEntity> checkedOutParts,
    required VoidCallback addCallback,
    required VoidCallback subtractCallback}) {
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
                                onPressed: () =>
                                    BlocProvider.of<SearchPartCubit>(context)
                                        .updateCheckoutQuantity(
                                            checkoutPartIndex: index,
                                            newQuantity: checkoutQuantity - 1),
                              ),
                              Text(checkoutQuantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () =>
                                    BlocProvider.of<SearchPartCubit>(context)
                                        .updateCheckoutQuantity(
                                            checkoutPartIndex: index,
                                            newQuantity: checkoutQuantity + 1),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  )),
        checkedOutParts.isEmpty
            ? Container()
            : SizedBox(
                width: 350,
                height: 60,
                child: SmallButton(buttonName: 'Checkout', onPressed: () {})),
      ],
    ),
  );
}