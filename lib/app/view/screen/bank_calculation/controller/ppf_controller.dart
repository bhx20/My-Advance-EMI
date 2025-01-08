import 'dart:math';

import 'package:advance_emi/app/component/toast/app_toast.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../utils/num_converter/num_converter.dart';

class PPFController extends GetxController {
  final GlobalKey boundaryKey = GlobalKey();
  final GlobalKey<FormState> ppfValidateKey = GlobalKey<FormState>();

  TextEditingController investmentController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  TextEditingController tenureController = TextEditingController(text: '15');

  var frequencyType = "Yearly".obs;
  List<String> frequencyValue = [
    "Yearly",
    "Quarterly",
    "Monthly",
    "Half Yearly",
  ];

  double totalInvestment = 0.0;
  double totalInterest = 0.0;
  double maturityAmount = 0.0;
  double totalInterestRatio = 0.0; // New variable
  double totalInvestmentRatio = 0.0; // New variable
  RxBool isResultVisible = false.obs;

  void calculatePPF() {
    if (ppfValidateKey.currentState!.validate()) {
      // Validation for investment value
      double investment = convertToDouble(investmentController.text);
      if (investment <= 0) {
        showToast(
          "Please enter a valid investment amount greater than 0.",
        );
        return; // Exit the method if validation fails
      }

      // Validation for interest rate
      double interestRate = convertToDouble(interestRateController.text);
      if (interestRate <= 0) {
        showToast(
          "Please enter a valid interest rate greater than 0.",
        );
        return; // Exit the method if validation fails
      }

      // Validation for tenure
      int tenure = convertToInt(tenureController.text);
      if (tenure < 15) {
        showToast(
          "Period must be or grater then 15 years.",
        );
        return; // Exit the method if validation fails
      }

      double n = _getCompoundingFrequency();
      double r = interestRate / 100 / n;
      double totalPeriods = tenure * n;

      maturityAmount = _calculateMaturityAmount(investment, r, totalPeriods, n);
      totalInvestment = investment * tenure * _getContributionFrequency();
      totalInterest = maturityAmount - totalInvestment;

      totalInterestRatio =
          maturityAmount > 0 ? (totalInterest / maturityAmount) * 100 : 0.0;
      totalInvestmentRatio =
          maturityAmount > 0 ? (totalInvestment / maturityAmount) * 100 : 0.0;
      showAdAndNavigate(() {
        isResultVisible.value = true;
      });

      update();
    }
  }

  double _calculateMaturityAmount(
      double investment, double r, double totalPeriods, double n) {
    return investment * ((pow(1 + r, totalPeriods) - 1) / r) * (1 + r);
  }

  double _getCompoundingFrequency() {
    switch (frequencyType.value) {
      case 'Monthly':
        return 12;
      case 'Quarterly':
        return 4;
      case 'Half Yearly':
        return 2;
      case 'Yearly':
      default:
        return 1;
    }
  }

  double _getContributionFrequency() {
    switch (frequencyType.value) {
      case 'Monthly':
        return 12;
      case 'Quarterly':
        return 4;
      case 'Half Yearly':
        return 2;
      case 'Yearly':
      default:
        return 1;
    }
  }

  void resetFields() {
    investmentController.clear();
    interestRateController.clear();
    tenureController.text = '15';
    frequencyType.value = "Yearly";
    totalInvestment = 0.0;
    totalInterest = 0.0;
    maturityAmount = 0.0;
    totalInterestRatio = 0.0;
    totalInvestmentRatio = 0.0;
    isResultVisible.value = false;
    update();
  }
}
