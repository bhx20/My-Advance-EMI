import 'dart:math';

import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../component/toast/app_toast.dart';
import '../../../../core/app_colors.dart';
import '../../../../utils/num_converter/num_converter.dart';

class SimpleController extends GetxController {
  final GlobalKey boundaryKey = GlobalKey();
  var amountController = TextEditingController();
  var interestController = TextEditingController();
  var yearsController = TextEditingController();
  var monthsController = TextEditingController();
  var dayController = TextEditingController();
  final TextEditingController fromDateController =
      TextEditingController(text: DateTime.now().toString().split(' ').first);
  final TextEditingController toDateController = TextEditingController();
  var selectedIndex = 0.obs;

  var frequencyType = "Yearly".obs;
  List<String> frequencyValue = [
    "Yearly",
    "Quarterly",
    "Monthly",
    "Half Yearly",
  ];

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
    update();
  }

  List<String> toggleItem = [
    'Duration',
    'Date',
  ];

  Future<void> selectDate(BuildContext context, Rx<DateTime?> selectedDate,
      TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value!,
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.appColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.appColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  var selectedFromDate = Rx<DateTime?>(DateTime.now());
  var selectedToDate = Rx<DateTime?>(DateTime.now());

  var selectedInterestType = 0.obs;
  var isResultVisible = false.obs;

  double principalAmount = 0;
  double interestAmount = 0;
  double totalAmount = 0;

  // Method to validate the form
  bool validateFields() {
    if (amountController.text.isEmpty ||
        interestController.text.isEmpty ||
        (yearsController.text.isEmpty &&
            monthsController.text.isEmpty &&
            dayController.text.isEmpty)) {
      showToast('Please fill all required fields');
      return false;
    }
    return true;
  }

  bool validateDateFields() {
    if (amountController.text.isEmpty || interestController.text.isEmpty) {
      showToast('Please fill in the amount and interest rate.');
      return false;
    }

    if (fromDateController.text.isEmpty || toDateController.text.isEmpty) {
      showToast('Please select both From and To dates.');
      return false;
    }

    if (selectedToDate.value!.isBefore(selectedFromDate.value!)) {
      showToast('To date should be after From date.');
      return false;
    }
    return true;
  }

  void calculate() {
    if (selectedIndex.value == 1) {
      _calculateDate();
    } else {
      _calculateDuration();
    }
  }

  void _calculateDate() {
    if (!validateDateFields()) return;
    DateTime fromDate = selectedFromDate.value!;
    DateTime toDate = selectedToDate.value!;

    // Calculate the difference in years, months, and days between the dates
    int totalDays = toDate.difference(fromDate).inDays;
    if (totalDays < 0) {
      showToast('To date should be after From date');
      return;
    }

    // Convert total days into years, months, and days
    int years = totalDays ~/ 365;
    int remainingDaysAfterYears = totalDays % 365;
    int months = remainingDaysAfterYears ~/ 30;
    int days = remainingDaysAfterYears % 30;

    double totalPeriodInYears = years + (months / 12) + (days / 365);

    double principal = convertToDouble(amountController.text);
    double interestRate = convertToDouble(interestController.text);

    if (selectedInterestType.value == 0) {
      // Simple Interest: SI = (P * R * T) / 100
      interestAmount = (principal * interestRate * totalPeriodInYears) / 100;
    } else {
      // Compound Interest with frequency
      int frequency = _getFrequencyInYear();
      double compoundPeriod = totalPeriodInYears * frequency;

      // Compound Interest formula: CI = P * [(1 + (R / (100 * n)))^nT - 1]
      interestAmount = principal *
          (pow((1 + (interestRate / (100 * frequency))), compoundPeriod) - 1);
    }

    totalAmount = principal + interestAmount;
    principalAmount = principal;

    showAdAndNavigate(() {
      isResultVisible.value = true;
    });

    update();
  }

  // Method to calculate the interest and total amounts
  void _calculateDuration() {
    if (validateFields()) {
      double principal = convertToDouble(amountController.text);
      double interestRate = convertToDouble(interestController.text);
      int years = convertToInt(yearsController.text);
      int months = convertToInt(monthsController.text);
      int days = convertToInt(dayController.text);

      // Convert months and days to years
      double totalPeriodInYears = years + (months / 12) + (days / 365);

      if (selectedInterestType.value == 0) {
        // Simple Interest: SI = (P * R * T) / 100
        interestAmount = (principal * interestRate * totalPeriodInYears) / 100;
      } else {
        // Compound Interest with frequency
        int frequency = _getFrequencyInYear();
        double compoundPeriod = totalPeriodInYears * frequency;

        // Compound Interest formula: CI = P * [(1 + (R / (100 * n)))^nT - 1]
        interestAmount = principal *
            (pow((1 + (interestRate / (100 * frequency))), compoundPeriod) - 1);
      }

      totalAmount = principal + interestAmount;
      principalAmount = principal;

      showAdAndNavigate(() {
        isResultVisible.value = true;
      });

      update();
    }
  }

  // Get frequency based on the selected type
  int _getFrequencyInYear() {
    switch (frequencyType.value) {
      case "Quarterly":
        return 4;
      case "Monthly":
        return 12;
      case "Half Yearly":
        return 2;
      default:
        return 1; // Yearly
    }
  }

  // Method to reset the fields and hide the result
  void resetFields() {
    amountController.clear();
    interestController.clear();
    yearsController.clear();
    monthsController.clear();
    dayController.clear();
    selectedInterestType.value = 0;
    isResultVisible.value = false;
    fromDateController.clear();
    toDateController.clear();
    update();
  }
}
