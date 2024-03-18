import 'package:flutter/material.dart';
import 'package:inventory_v1/presentation/widgets/widget_bucket.dart';

class CustomDrawerWidget extends StatelessWidget {
  CustomDrawerWidget(
      {super.key,
      required this.onPressed,
      required this.clearDatabase,
      required this.exportToExcel,
      required this.importFromExcel})
      : textEditingController = TextEditingController();
  final TextEditingController textEditingController;
  final VoidCallback onPressed;
  final VoidCallback importFromExcel;
  final VoidCallback exportToExcel;
  final VoidCallback clearDatabase;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        CustomSearchBar(
          textFieldKey: const Key('drawer-search-field'),
          controller: textEditingController,
          padding: 10,
          onPressed: onPressed,
        ),
        ListTile(
          leading: const Icon(Icons.file_open_rounded),
          title: const Text('Import from Excel'),
          onTap: () {
            importFromExcel.call();
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.save_alt_rounded),
          title: const Text('Export to Excel'),
          onTap: () {
            exportToExcel.call();
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('ClearDatabase'),
          onTap: () {
            clearDatabase.call();
            Navigator.of(context).pop();
          },
        ),
      ],
    ));
  }
}
