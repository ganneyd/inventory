import 'package:flutter/material.dart';

AppBar genericAppBar(BuildContext context, String title) {
  return AppBar(
      title: Text(title),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop()));
}
