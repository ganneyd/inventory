import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_v1/presentation/utils/utils_bucket.dart';

class CustomTextField extends StatefulWidget {
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    widget.controller.addListener(() {
      final text = widget.controller.text.toUpperCase();
      if (text != widget.controller.text) {
        widget.controller.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    //widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.characters,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      inputFormatters: widget.isNumberInput
          ? [PositiveNumberInputFormatter()]
          : widget.inputFormatter,
      validator: widget.validation ??
          (value) {
            if (widget.isNumberInput) {
              return validatePositiveNumber(value, widget.numberGreaterThan);
            } else if (widget.maxLength != null && value != null) {
              if (value.length != widget.maxLength) {
                return 'Please enter a correct NSN';
              } else {
                return null;
              }
            } else if (value == null || value.isEmpty) {
              return 'Please enter a ${widget.hintText}.';
            }
            return null;
          },
      controller: widget.controller,
      decoration: InputDecoration(
          counterText: '',
          hintText: widget.hintText,
          border: const OutlineInputBorder()),
    );
  }
}
