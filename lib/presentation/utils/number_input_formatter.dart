import 'package:flutter/services.dart';

class PositiveNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters from the new value
    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Return the new text value
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
