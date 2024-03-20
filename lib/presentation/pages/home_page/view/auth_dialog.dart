import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/rank_enum.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/presentation/pages/home_page/view/create_new_user.dart';
import 'package:inventory_v1/presentation/pages/home_page/view/mange_inventory_login_dialog.dart';

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key, required this.onLogin, required this.onSubmit});
  final void Function({required String username, required String password})
      onLogin;
  final void Function(
      {required String firstName,
      required String lastName,
      required RankEnum rankEnum,
      required List<ViewRightsEnum> viewRights,
      required String password}) onSubmit;
  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  bool toggleForm = true; // Initial state shows the login form
  String title = 'Login';
  void _toggleForm() {
    setState(() {
      toggleForm = !toggleForm;
      title = toggleForm ? 'Login' : 'Sign Up';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(title)),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * .50,
        width: MediaQuery.of(context).size.height * .50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (toggleForm) ...[
              LoginForm(
                  onSignUp: _toggleForm,
                  onLogin:
                      widget.onLogin), // Assuming LoginForm accepts a function
            ] else ...[
              CreateNewUserForm(
                  onSubmit: widget.onSubmit), // Your signup form widget
              InkWell(
                onTap: _toggleForm,
                child: const Text(
                  'Already have an account?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
