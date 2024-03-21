import 'package:flutter/material.dart';

class ResetPasswordDialog extends StatefulWidget {
  final String usernameToReset;
  final Future<bool> Function(String password) isUserCredentialsValid;
  final Function(String password) onCredentialsValid;
  const ResetPasswordDialog(
      {super.key,
      required this.onCredentialsValid,
      required this.usernameToReset,
      required this.isUserCredentialsValid});

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
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
      title: Text('Reset Password for ${widget.usernameToReset}'),
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
