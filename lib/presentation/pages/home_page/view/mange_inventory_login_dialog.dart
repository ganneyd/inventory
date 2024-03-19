import 'package:flutter/material.dart';
import 'package:inventory_v1/presentation/widgets/buttons/small_button_widget.dart';
import 'package:inventory_v1/presentation/widgets/form/form_fields_widget.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key, required this.onLogin});

  final void Function({required String user, required String password}) onLogin;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Login')),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          TextEditingController loginName = TextEditingController();
          TextEditingController loginPassword = TextEditingController();
          GlobalKey<FormState> formKey = GlobalKey<FormState>();
          return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomTextField(
                        controller: loginName, hintText: 'Name'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomTextField(
                      controller: loginPassword,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                  ),
                  SmallButton(
                      buttonName: 'Login',
                      onPressed: () {
                        if (formKey.currentState != null) {
                          if (formKey.currentState!.validate()) {
                            onLogin(
                                password: loginPassword.text,
                                user: loginName.text);
                          }
                        }
                      }),
                ],
              ));
        },
      ),
    );
  }
}
