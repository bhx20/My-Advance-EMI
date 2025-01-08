import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formatNumber(dynamic value) {
  final formatter = NumberFormat('#,##,###');
  return formatter.format(value.round());
}

String formatText(dynamic value) {
  final formatter = NumberFormat('#,##,###');
  return formatter.format(value);
}

class AmountFormatter extends TextInputFormatter {
  static const int maxAmount = 10000000000;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(
          text: '', selection: const TextSelection.collapsed(offset: 0));
    }

    try {
      int value = int.parse(newText);
      if (value > maxAmount) {
        return oldValue;
      }
      String formattedText = formatNumber(value);
      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    } catch (e) {
      return oldValue;
    }
  }
}

class Max100Formatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    try {
      double amount = double.parse(newValue.text);
      if (amount > 100) {
        return const TextEditingValue(
          text: '100',
          selection: TextSelection.collapsed(offset: '100'.length),
        );
      }
    } catch (e) {
      return oldValue;
    }

    return newValue;
  }
}

class NumericInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Use a regular expression to match only numeric characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
