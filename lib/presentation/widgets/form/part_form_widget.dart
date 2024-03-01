import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/unit_of_issue.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/presentation/utils/text_input_formatter.dart';
import 'package:inventory_v1/presentation/widgets/buttons/small_button_widget.dart';
import 'package:inventory_v1/presentation/widgets/form/form_fields_widget.dart';

class PartForm extends StatefulWidget {
  PartForm({
    super.key,
    PartEntity? partEntity,
    required this.formKey,
    required this.addPart,
  })  : nsnController = TextEditingController(text: partEntity?.nsn),
        nomenclatureController = TextEditingController(text: partEntity?.name),
        partNumberController =
            TextEditingController(text: partEntity?.partNumber),
        locationController = TextEditingController(text: partEntity?.location),
        serialNumberController =
            TextEditingController(text: partEntity?.serialNumber),
        quantityController =
            TextEditingController(text: partEntity?.quantity.toString()),
        requisitionPointController = TextEditingController(
            text: partEntity?.requisitionPoint.toString()),
        requisitionQuantityController = TextEditingController(
            text: partEntity?.requisitionQuantity.toString());

  final GlobalKey<FormState> formKey;
  final TextEditingController nsnController;
  final TextEditingController nomenclatureController;
  final TextEditingController partNumberController;
  final TextEditingController locationController;
  final TextEditingController serialNumberController;
  final TextEditingController quantityController;
  final TextEditingController requisitionPointController;
  final TextEditingController requisitionQuantityController;

  //callback functions
  final void Function({
    required String nsn,
    required String name,
    required String partNumber,
    required String location,
    required String quantity,
    required String requisitionPoint,
    required String requisitionQuantity,
    required String serialNumber,
    required UnitOfIssue unitOfIssue,
  }) addPart;

  @override
  State<PartForm> createState() => _PartFormState();
}

class _PartFormState extends State<PartForm> {
  final double paddingValue = 200.0;
  bool isFormValid = false;

  UnitOfIssue unitOfIssue = UnitOfIssue.NOT_SPECIFIED;
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

  void apply() {
    if (widget.formKey.currentState != null) {
      if (widget.formKey.currentState!.validate()) {
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
    widget.nsnController.clear();
    widget.nomenclatureController.clear();
    widget.partNumberController.clear();
    widget.locationController.clear();
    widget.serialNumberController.clear();
    widget.requisitionPointController.clear();
    widget.requisitionQuantityController.clear();
    widget.quantityController.clear();
  }

  @override
  void dispose() {
    // Dispose of your TextEditingControllers and any other resources here
    widget.locationController.dispose();
    widget.nomenclatureController.dispose();
    widget.nsnController.dispose();
    widget.partNumberController.dispose();
    widget.quantityController.dispose();
    widget.requisitionPointController.dispose();
    widget.requisitionQuantityController.dispose();
    widget.serialNumberController.dispose();

    // Always call super.dispose() at the end of the dispose method
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _wrapWithPadding([
          CustomTextField(
              maxLength: 16,
              inputFormatter: [NSNInputFormatter()],
              controller: widget.nsnController,
              hintText: 'NSN'),
          CustomTextField(
              controller: widget.nomenclatureController,
              hintText: 'NOMENCLATURE'),
        ], paddingValue),
        _wrapWithPadding([
          CustomTextField(
              controller: widget.partNumberController, hintText: 'PART NO.'),
          CustomTextField(
              controller: widget.locationController, hintText: 'LOCATION'),
        ], paddingValue),
        _wrapWithPadding([
          CustomTextField(
              validation: (value) => null,
              controller: widget.serialNumberController,
              hintText: 'SERIAL NUMBER'),
          DropdownMenu<UnitOfIssue>(
              initialSelection: UnitOfIssue.EA,
              onSelected: (value) {
                setState(() {
                  unitOfIssue = value ?? UnitOfIssue.NOT_SPECIFIED;
                });
              },
              dropdownMenuEntries:
                  UnitOfIssueExtension.enumToDropDownEntries()),
        ], paddingValue),
        _wrapWithPadding([
          CustomTextField(
              isNumberInput: true,
              controller: widget.quantityController,
              hintText: 'QUANTITY'),
          CustomTextField(
              isNumberInput: true,
              controller: widget.requisitionQuantityController,
              hintText: 'REQUISITION OBJ'),
          CustomTextField(
              isNumberInput: true,
              controller: widget.requisitionPointController,
              hintText: 'REQUISITION POINT'),
        ], paddingValue),
        _wrapWithPadding([
          SmallButton(
              isDisabled: !isFormValid,
              buttonName: 'Add Part',
              onPressed: () {
                widget.addPart(
                  nsn: widget.nsnController.text,
                  partNumber: widget.partNumberController.text,
                  name: widget.nomenclatureController.text,
                  location: widget.locationController.text,
                  quantity: widget.quantityController.text,
                  requisitionPoint: widget.requisitionPointController.text,
                  requisitionQuantity:
                      widget.requisitionQuantityController.text,
                  unitOfIssue: unitOfIssue,
                  serialNumber: widget.serialNumberController.text.isEmpty
                      ? 'N/A'
                      : widget.serialNumberController.text,
                );

                setState(() {
                  _clearForm();
                });
              }),
          SmallButton(buttonName: 'Apply', onPressed: () => apply()),
        ], paddingValue)
      ]),
    );
  }
}
