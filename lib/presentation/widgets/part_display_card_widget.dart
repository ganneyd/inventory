import 'package:flutter/material.dart';

class PartCardDisplay extends StatelessWidget {
  final String nsn;
  final String partName;
  final String location;
  final String checkedOutAmount;

  const PartCardDisplay(
      {super.key,
      required this.nsn,
      required this.checkedOutAmount,
      required this.location,
      required this.partName});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Row(
          children: [
            Text(nsn),
            const SizedBox(
              width: 10,
            ),
            Text(partName),
            const SizedBox(
              width: 10,
            ),
            Text('Location: $location'),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(checkedOutAmount),
      ]),
    );
  }
}
