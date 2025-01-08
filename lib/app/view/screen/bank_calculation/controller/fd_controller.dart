import 'dart:math'; // Import the math library for pow function

import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../component/toast/app_toast.dart';
import '../../../../utils/num_converter/num_converter.dart';

class FDController extends GetxController {
  final GlobalKey boundaryKey = GlobalKey();
  final GlobalKey<FormState> fdValidateKey = GlobalKey<FormState>();
  TextEditingController depositAmountController = TextEditingController();
  TextEditingController fdInterestRateController = TextEditingController();
  TextEditingController yearsController = TextEditingController();
  TextEditingController monthsController = TextEditingController();
  TextEditingController dayController = TextEditingController();

  var frequencyType = "Reinvestment/Cumulative".obs;
  List<String> frequencyValue = [
    "Reinvestment/Cumulative",
    "Quarterly Payout",
    "Monthly Payout",
    "Short Term",
  ];

  double maturityAmount = 0;
  double totalInterest = 0;
  double maturityPercentage =
      0; // Percentage of maturity amount relative to the deposit
  double interestPercentage =
      0; // Percentage of interest amount relative to the deposit
  var maturityDate = ''.obs;
  RxBool isResultVisible = false.obs;

  void calculate() {
    if (fdValidateKey.currentState?.validate() ?? false) {
      // Validate if any field is empty
      if (depositAmountController.text.isEmpty) {
        showToast("Please enter the deposit amount");
        return;
      }

      if (fdInterestRateController.text.isEmpty ||
          convertToDouble(fdInterestRateController.text) == 0) {
        showToast("Please enter the interest rate");
        return;
      }

      if (yearsController.text.isEmpty &&
          monthsController.text.isEmpty &&
          dayController.text.isEmpty) {
        showToast("Please enter the period (years, months, or days)");
        return;
      }

      double depositAmount = convertToDouble(depositAmountController.text);
      double interestRate = convertToDouble(fdInterestRateController.text);
      int years = convertToInt(yearsController.text);
      int months = convertToInt(monthsController.text);
      int days = convertToInt(dayController.text);

      // Calculate the total months and days
      int totalMonths = (years * 12) + months;
      int totalDays = (years * 365) + (months * 30) + days;

      // Handle the short-term condition
      if (frequencyType.value == "Short Term") {
        if (totalDays > 180) {
          showToast("Enter Period up to 180 Days");
          yearsController.clear();
          monthsController.clear();
          dayController.clear();
          isResultVisible.value = false;
          update();
          return;
        }
      }

      // If no period is provided, return early
      if (totalMonths == 0 && days == 0) {
        isResultVisible.value = false;
        update();
        return;
      }

      // Determine the compounding frequency
      double compoundFrequency;
      switch (frequencyType.value) {
        case "Reinvestment/Cumulative":
          compoundFrequency = 4; // Quarterly compounding
          break;
        case "Quarterly Payout":
          compoundFrequency = 4; // Quarterly
          break;
        case "Monthly Payout":
          compoundFrequency = 12; // Monthly
          break;
        case "Short Term":
          compoundFrequency = 365; // Daily compounding
          break;
        default:
          compoundFrequency = 1; // Default to annually
          break;
      }

      // Determine the maturity amount and total interest
      double annualInterestRate = interestRate / 100;
      double maturityAmountValue = 0;
      double totalInterestValue = 0;

      if (frequencyType.value == "Reinvestment/Cumulative") {
        // Compound interest calculation
        double ratePerPeriod = annualInterestRate / compoundFrequency;
        maturityAmountValue = depositAmount *
            pow(1 + ratePerPeriod,
                (compoundFrequency * totalMonths + days / 30) / 12.0);
        totalInterestValue = maturityAmountValue - depositAmount;
      } else if (frequencyType.value == "Quarterly Payout" ||
          frequencyType.value == "Monthly Payout") {
        // Maturity amount remains the deposit amount, interest is paid out
        maturityAmountValue = depositAmount;
        double ratePerPeriod = annualInterestRate / compoundFrequency;
        totalInterestValue = depositAmount *
            ratePerPeriod *
            ((totalMonths + days / 30) / (12 / compoundFrequency));
      } else if (frequencyType.value == "Short Term") {
        maturityAmountValue =
            depositAmount * (1 + (annualInterestRate * totalDays / 365));
        totalInterestValue = maturityAmountValue - depositAmount;
      }

      // Calculate the maturity date
      DateTime maturityDateValue =
          DateTime.now().add(Duration(days: totalDays));
      maturityDate.value = DateFormat('dd MMM yyyy').format(maturityDateValue);

      maturityPercentage = (depositAmount / maturityAmountValue) * 100;
      interestPercentage = (totalInterestValue / maturityAmountValue) * 100;

      // Update the results
      maturityAmount = maturityAmountValue;
      totalInterest = totalInterestValue;
      showAdAndNavigate(() {
        isResultVisible.value = true;
      });

      update();
    }
  }

  void reset() {
    depositAmountController.clear();
    fdInterestRateController.clear();
    yearsController.clear();
    monthsController.clear();
    dayController.clear();
    maturityAmount = 0.0;
    totalInterest = 0.0;
    maturityPercentage = 0.0;
    interestPercentage = 0.0;
    maturityDate.value = '';
    isResultVisible.value = false;
    update();
  }
}
