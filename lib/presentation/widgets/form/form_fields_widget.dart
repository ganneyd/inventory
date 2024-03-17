import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_v1/presentation/utils/utils_bucket.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validation;
  final List<TextInputFormatter>? inputFormatter;
  final bool isNumberInput;
  final int? maxLength;
  final FocusNode? focusNode;
  final int numberGreaterThan;
  const CustomTextField(
      {super.key,
      this.numberGreaterThan = 1,
      this.focusNode,
      required this.controller,
      required this.hintText,
      this.validation,
      this.inputFormatter,
      this.isNumberInput = false,
      this.maxLength});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      maxLength: maxLength,
      inputFormatters:
          isNumberInput ? [PositiveNumberInputFormatter()] : inputFormatter,
      validator: validation ??
          (value) {
            if (isNumberInput) {
              return validatePositiveNumber(value, numberGreaterThan);
            } else if (maxLength != null && value != null) {
              if (value.length != maxLength) {
                return 'Please enter a correct NSN';
              } else {
                return null;
              }
            } else if (value == null || value.isEmpty) {
              return 'Please enter a $hintText.';
            }
            return null;
          },
      controller: controller,
      decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          border: const OutlineInputBorder()),
    );
  }
}
