double convertToDouble(String value) {
  String cleanValue = value.replaceAll(',', '');
  try {
    return double.parse(cleanValue);
  } catch (e) {
    print('Error parsing double: $e');
    return 0.0;
  }
}

int convertToInt(String value) {
  String cleanValue = value.replaceAll(',', '');
  try {
    return int.parse(cleanValue);
  } catch (e) {
    print('Error parsing double: $e');
    return 0;
  }
}
