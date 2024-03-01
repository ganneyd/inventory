import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/main_section_enum.dart';
import 'package:inventory_v1/presentation/widgets/widget_bucket.dart';

class CheckoutPartDialog extends StatefulWidget {
  const CheckoutPartDialog({required this.updateCheckout})
      : super(key: const Key('checkout-part-dialog'));
  final void Function(
      {required MaintenanceSection section,
      required String tailNumber,
      required String taskName,
      required String checkoutUser}) updateCheckout;

  @override
  State<CheckoutPartDialog> createState() => _CheckoutPartDialogState();
}

class _CheckoutPartDialogState extends State<CheckoutPartDialog> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _tailNumberController;
  late TextEditingController _taskNameController;
  late TextEditingController _checkoutUserController;
  final double paddingValue = 20.0;
  bool isFormValid = false;
  MaintenanceSection? sectionSelection;
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
        padding: EdgeInsets.symmetric(horizontal: paddingValue),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: wrappedWidgets,
        ));
  }

  List<DropdownMenuItem<MaintenanceSection>> _getDropdownItems() {
    var maintenanceSections = MaintenanceSection.values;
    List<DropdownMenuItem<MaintenanceSection>> items = [];
    for (var section in maintenanceSections) {
      if (section == MaintenanceSection.unknown) {
        continue;
      }
      items.add(DropdownMenuItem<MaintenanceSection>(
          value: section, child: Text(section.enumToString())));
    }
    return items;
  }

  void _apply() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isFormValid = true;
        });
      }
    } else {
      setState(() {
        isFormValid = false;
      });
    }
  }

  void _clearForm() {
    _checkoutUserController.clear();
    _tailNumberController.clear();
    _taskNameController.clear();
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _checkoutUserController = TextEditingController();
    _tailNumberController = TextEditingController();
    _taskNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _checkoutUserController.dispose();
    _tailNumberController.dispose();
    _taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
          key: _formKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _wrapWithPadding([
                  CustomTextField(
                      controller: _checkoutUserController,
                      hintText: 'Rank-Last Name'),
                  CustomTextField(
                      controller: _taskNameController, hintText: 'Task')
                ], paddingValue),
                _wrapWithPadding([
                  CustomTextField(
                      controller: _tailNumberController,
                      hintText: 'ACFT Tail Number'),
                  DropdownButton<MaintenanceSection>(
                      hint: const Text('Maint Section'),
                      value: sectionSelection,
                      items: _getDropdownItems(),
                      onChanged: (value) {
                        setState(() {
                          sectionSelection = value;
                        });
                      })
                ], paddingValue),
                _wrapWithPadding([
                  SmallButton(
                      isDisabled: !isFormValid,
                      buttonName: 'Update',
                      onPressed: () {
                        widget.updateCheckout(
                            checkoutUser: _checkoutUserController.text,
                            section:
                                sectionSelection ?? MaintenanceSection.unknown,
                            tailNumber: _tailNumberController.text,
                            taskName: _taskNameController.text);

                        setState(() {
                          _clearForm();
                        });

                        Navigator.of(context).pop();
                      }),
                  SmallButton(buttonName: 'Apply', onPressed: _apply)
                ], paddingValue),
              ],
            ),
          )),
    );
  }
}
