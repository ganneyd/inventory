import 'package:flutter/material.dart';

class PartNotFound extends StatelessWidget {
  const PartNotFound() : super(key: const Key('part-not-found'));

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'PART NOT FOUND',
        style: TextStyle(fontSize: 100, color: Color.fromRGBO(0, 0, 0, .15)),
      ),
    );
  }
}
