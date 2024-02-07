import 'package:flutter/material.dart';
import 'package:inventory_v1/presentation/widgets/widget_bucket.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onPressed;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Key textFieldKey;
  const CustomSearchBar(
      {this.focusNode,
      required this.textFieldKey,
      this.onPressed,
      required this.controller})
      : super(key: const Key('custom-search-bar'));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
                focusNode: focusNode,
                controller: controller,
                key: textFieldKey,
                hintText: 'Search by NSN, Part Number, Serial Number'),
          ),
          const SizedBox(
            width: 8,
          ), //add some spacing
          ElevatedButton(onPressed: onPressed, child: const Text('Search')),
        ],
      ),
    );
  }
}
