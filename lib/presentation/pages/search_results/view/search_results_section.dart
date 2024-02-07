import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/models/part/part_model.dart';
import 'package:inventory_v1/presentation/widgets/part_display_card_widget.dart';

Widget buildSection(String title, List<Part> parts) {
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
