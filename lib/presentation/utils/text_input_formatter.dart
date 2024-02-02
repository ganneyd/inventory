import 'package:flutter/services.dart';

class NSNInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters from the new value
    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Add hyphens to format the NSN
    StringBuffer formattedText = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      if (i == 4 || i == 6 || i == 9) {
        formattedText.write('-');
      }
      formattedText.write(newText[i]);
    }

    // Return the new formatted text with the cursor position adjusted
    return TextEditingValue(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
