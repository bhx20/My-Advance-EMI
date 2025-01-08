import 'dart:math'; // Import this for pow function

import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/toast/app_toast.dart';
import '../../../../core/app_typography.dart';
import '../../../../model/local.dart';
import '../../../../utils/num_converter/num_converter.dart';

class CheckEligibilityController extends GetxController {
  TextEditingController grossMonthlyIncomeController = TextEditingController();
  TextEditingController totalMonthlyEmiController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  TextEditingController periodController = TextEditingController();

  TextStyle periodStyle = notoSans.copyWith(height: 1.2).get14.w600;
  RxBool isResultVisible = false.obs;
  var maxOfSalaryType = "35".obs;
  RxBool isCustomPeriod = false.obs;
  RxInt selectedPeriodType = 0.obs;
  List<ToggleList> advancePeriodItem = [
    ToggleList(true, 'Years'),
    ToggleList(false, 'Months')
  ];
  List<String> maxOfSalary = [
    "35",
    "40",
    "45",
    "50",
    "55",
    "60",
    "65",
    "70",
    "75",
    "80",
    "85",
    "90",
    "95",
  ];

  RxDouble eligibleEmi = 0.0.obs;
  RxDouble eligibleLoanAmount = 0.0.obs;

  void calculateEligibility() {
    try {
      if (grossMonthlyIncomeController.text.isEmpty) {
        showToast("Please enter your Gross Monthly Income.");
        return;
      }
      if (totalMonthlyEmiController.text.isEmpty) {
        showToast("Please enter your Total Monthly EMI.");
        return;
      }
      if (interestController.text.isEmpty) {
        showToast("Please enter the Interest Rate.");
        return;
      }
      if (periodController.text.isEmpty) {
        showToast("Please enter the Period.");
        return;
      }

      final grossMonthlyIncome =
          convertToDouble(grossMonthlyIncomeController.text);
      final totalMonthlyEmi = convertToDouble(totalMonthlyEmiController.text);
      final interestRate = convertToDouble(interestController.text) / 100;
      final period = convertToInt(periodController.text);

      if (totalMonthlyEmi >= grossMonthlyIncome) {
        showToast(
            "Please enter a Total Monthly EMI less than your Gross Monthly Income.");
        return;
      }

      if (totalMonthlyEmi < 0) {
        showToast(
            "Total Monthly EMI cannot be negative. Please enter a valid value.");
        return;
      }

      if (interestRate <= 0) {
        showToast(
            "Interest Rate cannot be 0 or less. Please enter a valid value.");
        return;
      }

      // Check if period is less than or equal to 0
      if (period <= 0) {
        showToast("Period cannot be 0 or less. Please enter a valid value.");
        return;
      }

      final foirPercentage = convertToDouble(maxOfSalaryType.value) / 100;
      final eligibleEmiValue =
          grossMonthlyIncome * foirPercentage - totalMonthlyEmi;

      if (eligibleEmiValue <= 0) {
        showToast("Your eligible EMI cannot be less than or equal to 0.");
        return;
      }
      final monthlyInterestRate = interestRate / 12;
      int numberOfPayments;

      if (selectedPeriodType.value == 0) {
        numberOfPayments = period * 12;
      } else {
        numberOfPayments = period;
      }

      final loanAmount = eligibleEmiValue *
          (1 - pow(1 + monthlyInterestRate, -numberOfPayments)) /
          monthlyInterestRate;

      eligibleEmi.value = eligibleEmiValue;
      eligibleLoanAmount.value = loanAmount;

      showAdAndNavigate(() {
        isResultVisible.value = true;
      });
      update();
    } catch (e) {
      showToast("An unexpected error occurred. Please try again.");
    }
  }

  void resetData() {
    grossMonthlyIncomeController.clear();
    totalMonthlyEmiController.clear();
    interestController.clear();
    periodController.clear();
    maxOfSalaryType.value = maxOfSalary.first;
    isCustomPeriod.value = false;
    eligibleEmi.value = 0.0;
    eligibleLoanAmount.value = 0.0;
    isResultVisible.value = false;
    update();
  }
}
