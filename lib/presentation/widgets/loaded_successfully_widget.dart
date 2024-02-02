import 'package:flutter/material.dart';

///Visually show the user that the data required for the current UI was loaded
///successfully, by showing a sliver of green at the bottom of the UI
class LoadedSuccessfullyWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const LoadedSuccessfullyWidget()
      : super(key: const Key('loaded-successfully-widget'));
  final double height = 20;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.green,
      child: const Center(child: Text('Success!')),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
