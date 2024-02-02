import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/util.dart';

class PartCardDisplay extends StatelessWidget {
  final String nsn;
  final String partName;
  final String location;
  final String checkedOutAmount;
  final UnitOfIssue unitOfIssue;

  const PartCardDisplay(
      {super.key,
      required this.nsn,
      required this.checkedOutAmount,
      required this.location,
      required this.partName,
      required this.unitOfIssue});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      child: Card(
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              Text('Checked out $checkedOutAmount ${unitOfIssue.displayValue}'),
            ]),
          )),
    );
  }
}
