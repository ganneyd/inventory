import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final VoidCallback? backButtonCallback;
  const CustomAppBar(
      {required Key key,
      required this.title,
      this.actions,
      this.bottom,
      this.backButtonCallback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        bottom: bottom,
        title: Center(child: Text(title)),
        actions: actions,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed:
                  backButtonCallback ?? () => Navigator.of(context).pop(),
            );
          },
        ));
  }

  @override
  Size get preferredSize {
    // Here, we provide the preferred size of the AppBar.
    // The default AppBar height is 56.0, and we add the bottom widget's preferred height if it exists.
    return Size.fromHeight(
      kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
    );
  }
}
