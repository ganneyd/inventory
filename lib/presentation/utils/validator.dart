String? validateSerialNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'N/A'; // Return "N/A" if the field is empty
  }
  // You can add additional validation logic here if needed
  return null; // Return null if the input is valid
}

String? validatePositiveNumber(String? value, int greaterThan) {
  if (value == null || value.isEmpty) {
    return 'Please enter a number.';
  }
  int? number = int.tryParse(value);
  if (number == null || number < greaterThan) {
    return 'Must be greater than $greaterThan.';
  }
  return null; // Input is valid
}
