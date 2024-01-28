import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback onPressed;
  final TextEditingController controller;
  const CustomSearchBar({required this.onPressed, required this.controller})
      : super(key: const Key('custom-search-bar'));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Search'),
        )),
        const SizedBox(
          width: 8,
        ), //add some spacing
        ElevatedButton(onPressed: onPressed, child: const Text('Search')),
      ],
    );
  }
}
