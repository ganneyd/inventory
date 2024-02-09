import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/presentation/pages/search_results/cubit/search_results_cubit.dart';
import 'package:inventory_v1/presentation/pages/search_results/view/add_to_cart_dialog.dart';
import 'package:inventory_v1/presentation/widgets/part_display_card_widget.dart';

Widget buildSection(
    String title, List<PartEntity> parts, BuildContext context) {
  // Obtain the cubit instance here
  final cubit = BlocProvider.of<SearchPartCubit>(context);
  //if the list is empty don't  show the section
  if (parts.isEmpty) {
    return Container();
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: parts.length,
          itemBuilder: (context, index) {
            return PartCardDisplay(
                callback: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AddToCartDialog(
                          part: parts[index],
                          onAdd: (int quantity) {
                            cubit.addPartToCart(parts[index], quantity);
                          },
                        );
                      });
                },
                left: parts[index].nsn,
                center: parts[index].name,
                right: parts[index].partNumber,
                bottom:
                    "Quantity: ${parts[index].quantity} ${parts[index].unitOfIssue.displayValue}",
                centerBottom: false);
          }),
      const Divider(),
    ],
  );
}
