import 'package:flutter/material.dart';

class PartCardDisplay extends StatelessWidget {
  final String left;
  final String center;
  final String right;
  final String bottom;
  final bool centerBottom;
  final VoidCallback? callback;
  final Color? color;
  const PartCardDisplay(
      {super.key,
      this.callback,
      required this.left,
      required this.center,
      required this.right,
      required this.bottom,
      this.centerBottom = true,
      this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                left,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                right,
                style: Theme.of(context).textTheme.titleSmall,
              )
            ],
          ),
          subtitle: centerBottom ? Text(bottom) : null,
          trailing: centerBottom ? null : Text(bottom),
          tileColor: color ?? Colors.blueAccent,
          titleAlignment: ListTileTitleAlignment.center,
          contentPadding: const EdgeInsets.all(10.0),
          onTap: callback,
        ));
  }
}
