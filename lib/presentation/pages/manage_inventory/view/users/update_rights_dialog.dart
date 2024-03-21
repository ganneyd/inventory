import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';

class UpdateViewRightsDialog extends StatefulWidget {
  final String usernameToUpdate;
  final List<ViewRightsEnum> currentUserRights;
  final Future<bool> Function(String password) isUserCredentialsValid;
  final Function(List<ViewRightsEnum> updatedRights, String password)
      onRightsUpdated;

  const UpdateViewRightsDialog({
    super.key,
    required this.usernameToUpdate,
    required this.currentUserRights,
    required this.isUserCredentialsValid,
    required this.onRightsUpdated,
  });

  @override
  State<UpdateViewRightsDialog> createState() => _UpdateViewRightsDialogState();
}

class _UpdateViewRightsDialogState extends State<UpdateViewRightsDialog> {
  final _passwordController = TextEditingController();
  String _errorText = '';
  List<ViewRightsEnum> _selectedRights = [];

  @override
  void initState() {
    super.initState();
    _selectedRights = widget.currentUserRights.toList();
  }

  void _updateRights() async {
    final String enteredPassword = _passwordController.text;
    bool isValid = await widget.isUserCredentialsValid(enteredPassword);
    if (isValid) {
      widget.onRightsUpdated(_selectedRights, enteredPassword);
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _errorText = 'Incorrect password. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Rights for ${widget.usernameToUpdate}'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ...ViewRightsEnum.values
                .where((right) => right != ViewRightsEnum.admin)
                .map((right) {
              return CheckboxListTile(
                title: Text(right.enumToString()),
                value: _selectedRights.contains(right),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedRights.add(right);
                    } else {
                      _selectedRights.remove(right);
                    }
                  });
                },
              );
            }),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Your Password',
                errorText: _errorText.isEmpty ? null : _errorText,
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _updateRights,
          child: const Text('Update'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
