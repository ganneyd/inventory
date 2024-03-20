import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/rank_enum.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/presentation/widgets/widget_bucket.dart';

class CustomDrawerWidget extends StatelessWidget {
  CustomDrawerWidget(
      {super.key,
      required this.currentUser,
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
  final UserEntity currentUser;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Column(
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      ' ${currentUser.rank.enumToString()} ${currentUser.lastName.toUpperCase()}, ${currentUser.firstName.toUpperCase()}')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: currentUser.viewRights
                    .map((e) => Text(e.enumToString()))
                    .toList(),
              )
            ],
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
