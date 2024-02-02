import 'package:flutter/material.dart';

///Widget to show the user that the current view is loading
///
class LoadingView extends StatelessWidget {
  const LoadingView() : super(key: const Key('loading-view-widget'));

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
