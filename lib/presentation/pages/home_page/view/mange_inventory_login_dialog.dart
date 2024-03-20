import 'package:flutter/material.dart';
import 'package:inventory_v1/presentation/widgets/buttons/small_button_widget.dart';
import 'package:inventory_v1/presentation/widgets/form/form_fields_widget.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key, required this.onLogin, required this.onSignUp});

  final void Function({required String username, required String password})
      onLogin;
  final VoidCallback onSignUp;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        TextEditingController loginName = TextEditingController();
        TextEditingController loginPassword = TextEditingController();
        GlobalKey<FormState> formKey = GlobalKey<FormState>();
        return Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomTextField(
                    controller: loginName,
                    hintText: 'Username (firstname.lastname)',
                    autoUpperCase: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomTextField(
                    autoUpperCase: false,
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
                              username: loginName.text);
                        }
                      }
                    }),
                InkWell(
                  onTap: onSignUp,
                  child: const Text(
                    'Create an account',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }
}
