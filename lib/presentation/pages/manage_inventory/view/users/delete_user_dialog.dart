import 'package:flutter/material.dart';

class DeleteUserDialog extends StatefulWidget {
  final String userToDelete;
  final Future<bool> Function(String password) isUserCredentialsValid;
  final Function(String password) onCredentialsValid;
  const DeleteUserDialog(
      {super.key,
      required this.onCredentialsValid,
      required this.userToDelete,
      required this.isUserCredentialsValid});

  @override
  State<DeleteUserDialog> createState() => _DeleteUserDialogState();
}

class _DeleteUserDialogState extends State<DeleteUserDialog> {
  final _passwordController = TextEditingController();
  String _errorText = '';

  void _resetPassword() async {
    final String enteredPassword = _passwordController.text;
    bool isValid = await widget.isUserCredentialsValid(enteredPassword);
    if (isValid) {
      widget.onCredentialsValid(enteredPassword);
      Navigator.of(context).pop(true); // Assuming success closes the dialog
    } else {
      // Inform the user of the invalid password and let them try again.
      setState(() {
        _errorText = 'Incorrect password. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete ${widget.userToDelete}'),
      content: TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Your Password',
          errorText: _errorText.isEmpty ? null : _errorText,
        ),
        obscureText: true, // Use for password inputs
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _resetPassword,
          child: Text('OK'),
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
