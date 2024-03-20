import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/rank_enum.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/presentation/widgets/buttons/small_button_widget.dart';
import 'package:inventory_v1/presentation/widgets/form/form_fields_widget.dart';

class CreateNewUserForm extends StatefulWidget {
  const CreateNewUserForm({super.key, required this.onSubmit});

  final void Function(
      {required String firstName,
      required String lastName,
      required RankEnum rankEnum,
      required List<ViewRightsEnum> viewRights,
      required String password}) onSubmit;
  @override
  State<CreateNewUserForm> createState() => _CreateNewUserFormState();
}

class _CreateNewUserFormState extends State<CreateNewUserForm> {
  bool passwordMatches = false;
  bool isFormValid = false;
  RankEnum? selectedRank;
  final double paddingValue = 20.0;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmationController;
  late GlobalKey<FormState> formKey;
  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    passwordConfirmationController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    passwordConfirmationController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //method to return the text fields wrapped in a padding along with a sized box
  Widget _wrapWithPadding(List<Widget> widgets, double paddingValue) {
    List<Widget> wrappedWidgets = [];

    // Loop through the widgets and wrap each one with Padding and SizedBox
    for (int i = 0; i < widgets.length; i++) {
      wrappedWidgets.add(
        Expanded(
          flex: 3,
          child: widgets[i],
        ),
      );

      if (i != widgets.length - 1) {
        wrappedWidgets.add(const Expanded(flex: 1, child: SizedBox()));
      }
    }

    // Return a Column with the wrapped widgets
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: paddingValue, vertical: paddingValue),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: wrappedWidgets,
        ));
  }

  List<DropdownMenuItem<RankEnum>> _getDropdownRanks() {
    var ranks = RankEnum.values;
    List<DropdownMenuItem<RankEnum>> items = [];
    for (var rank in ranks) {
      if (rank == RankEnum.unknown) {
        continue;
      }
      items
          .add(DropdownMenuItem(value: rank, child: Text(rank.enumToString())));
    }
    return items;
  }

  void _apply() {
    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        setState(() {
          isFormValid = true;
          passwordMatches =
              passwordController.text == passwordConfirmationController.text;
        });
      }
    } else {
      setState(() {
        isFormValid = false;
      });
    }
  }

  void _clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    passwordConfirmationController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _wrapWithPadding([
            CustomTextField(
                autoUpperCase: false,
                controller: firstNameController,
                hintText: 'First Name'),
            CustomTextField(
                autoUpperCase: false,
                controller: lastNameController,
                hintText: 'Last Name'),
          ], paddingValue),
          _wrapWithPadding([
            DropdownButton<RankEnum>(
                menuMaxHeight: 200,
                value: selectedRank,
                hint: const Text('Rank'),
                items: _getDropdownRanks(),
                onChanged: (value) {
                  setState(() {
                    selectedRank = value;
                  });
                })
          ], paddingValue),
          _wrapWithPadding([
            CustomTextField(
                autoUpperCase: false,
                obscureText: true,
                controller: passwordController,
                hintText: 'Password'),
            CustomTextField(
                autoUpperCase: false,
                obscureText: true,
                validation: (value) {
                  if (value == null) {
                    return 'Please enter a password';
                  }
                  if (passwordController.text == value) {
                    return null;
                  }
                  return 'Passwords do not match';
                },
                controller: passwordConfirmationController,
                hintText: 'Confirm password'),
          ], paddingValue),
          _wrapWithPadding([
            SmallButton(
                buttonName: 'Submit',
                onPressed: () {
                  _apply();
                  if (isFormValid) {
                    widget.onSubmit(
                        firstName: firstNameController.value.text,
                        lastName: lastNameController.value.text,
                        rankEnum: selectedRank ?? RankEnum.unknown,
                        viewRights: [],
                        password: passwordController.value.text);
                    _clearForm();
                    Navigator.of(context).pop();
                  }
                }),
          ], paddingValue)
        ],
      ),
    );
  }
}
