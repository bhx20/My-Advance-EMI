import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/emi_result_model.dart';
import '../../../../utils/num_converter/num_converter.dart';
import '../../../../utils/num_formater/num_formater.dart';

class QuickCalculatorController extends GetxController {
  final TextEditingController amountController =
      TextEditingController(text: formatNumber(100000));
  final TextEditingController interestController =
      TextEditingController(text: "6");
  final TextEditingController periodController =
      TextEditingController(text: "5");
  final TextEditingController monthlyEmiController =
      TextEditingController(text: formatNumber(1425));

  CalculateResult? emiResult;

  var selectedIndex = 0.obs;

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
    calculateEmi();
    update();
  }

  List<String> toggleItem = [
    'EMI',
    'Amount',
    'Period',
    'Interest',
  ];

  bool sliderFieldShow(String sliderType) {
    switch (selectedIndex.value) {
      case 0: // EMI selected
        return sliderType == 'Amount' ||
            sliderType == 'Interest' ||
            sliderType == 'Period';
      case 1: // Amount selected
        return sliderType == 'Interest' ||
            sliderType == 'Period' ||
            sliderType == 'MonthlyEMI';
      case 2: // Period selected
        return sliderType == 'Amount' ||
            sliderType == 'Interest' ||
            sliderType == 'MonthlyEMI';
      case 3: // Interest selected
        return sliderType == 'Amount' ||
            sliderType == 'Period' ||
            sliderType == 'MonthlyEMI';
      default:
        return false;
    }
  }

  int touchedIndex = -1;
  var minimumAmount = 100000.0.obs;
  var maximumAmount = 10000000.0.obs;
  var amountValue = 100000.0.obs;
  var minimumInterest = 1.0.obs;
  var maximumInterest = 30.0.obs;
  var interest = 6.0.obs;
  var minimumPeriod = 1.0.obs;
  var maximumPeriod = 99.0.obs;
  var period = 8.0.obs;
  var minimumMonthlyEmi = 1000.0.obs;
  var maximumMonthlyEmi = 100000.0.obs;
  var monthlyEmi = 1425.0.obs;

//==============================================================================
//   **    Calculate Slider value   **
//==============================================================================

  void updateAmount(double value) {
    if (value >= minimumAmount.value && value <= maximumAmount.value) {
      amountValue.value = value;
    } else {
      if (value >= minimumAmount.value) {
        amountValue.value = maximumAmount.value;
      }
      if (value <= maximumAmount.value) {
        amountValue.value = minimumAmount.value;
      }
    }

    amountController.text = formatNumber(value);
    calculateEmi();
    manageResult();
    update();
  }

  void updateInterest(double value) {
    // double value = convertToDouble(interestValue);
    if (value >= minimumInterest.value && value <= maximumInterest.value) {
      interest.value = value;
    } else {
      if (value >= minimumInterest.value) {
        interest.value = maximumInterest.value;
      }
      if (value <= maximumInterest.value) {
        interest.value = minimumInterest.value;
      }
    }

    interestController.text = formatNumber(value);
    calculateEmi();
    manageResult();
    update();
  }

  void updatePeriod(double value) {
    if (value >= minimumPeriod.value && value <= maximumPeriod.value) {
      period.value = value;
    } else {
      if (value >= minimumPeriod.value) {
        period.value = maximumPeriod.value;
      }
      if (value <= maximumPeriod.value) {
        period.value = minimumPeriod.value;
      }
    }
    periodController.text = value.round().toString();
    calculateEmi();
    manageResult();
    update();
  }

  void updateMonthlyEmi(double value) {
    if (value >= minimumMonthlyEmi.value && value <= maximumMonthlyEmi.value) {
      monthlyEmi.value = value;
    } else {
      if (value >= minimumMonthlyEmi.value) {
        monthlyEmi.value = maximumMonthlyEmi.value;
      }
      if (value <= maximumMonthlyEmi.value) {
        monthlyEmi.value = minimumMonthlyEmi.value;
      }
    }
    monthlyEmiController.text = formatNumber(value);
    calculateEmi();
    manageResult();
    update();
  }

//==============================================================================
//   **    Calculate EMI   **
//==============================================================================
  calculateEmi() {
    amountController.text = formatNumber(amountValue.value);
    interestController.text = interest.value.round().toString();
    periodController.text = period.value.round().toString();
    monthlyEmiController.text = formatNumber(monthlyEmi.value);

    double principal = convertToDouble(amountController.text);
    double rate = convertToDouble(interestController.text) / 12 / 100;
    double emiAmount = convertToDouble(monthlyEmiController.text);
    double time = period.value * 12;
    if (selectedIndex.value == 0) {
      calculateMonthlyEmi(principal, rate, time);
    }
    if (selectedIndex.value == 1) {
      calculateAmount(rate, time, emiAmount);
    }
    if (selectedIndex.value == 2) {
      calculatePeriod(principal, rate, emiAmount);
    }
    if (selectedIndex.value == 3) {
      calculateInterestRate(principal, time, emiAmount);
    }
    manageResult();

    update();
  }

//==============================================================================
//   **    Calculate Functions   **
//==============================================================================

  calculateMonthlyEmi(principal, rate, time) {
    double emi =
        (principal * rate * pow(1 + rate, time)) / (pow(1 + rate, time) - 1);
    monthlyEmiController.text = formatNumber(emi);
  }

  calculateAmount(rate, time, emiAmount) {
    double principal =
        emiAmount * (pow(1 + rate, time) - 1) / (rate * pow(1 + rate, time));
    amountController.text = formatNumber(principal);
  }

  void calculatePeriod(double principal, double rate, double emiAmount) {
    double calculatedTime =
        (log(emiAmount) - log(emiAmount - (principal * rate))) / log(1 + rate);
    periodController.text = calculatedTime.truncate().toStringAsFixed(0);
  }

  calculateInterestRate(double principal, double time, double emiAmount) {
    double lowerBound = 0.0;
    double upperBound = 1.0;
    double epsilon = 0.0000001;
    double rate = 0.0;

    while ((upperBound - lowerBound) > epsilon) {
      rate = (lowerBound + upperBound) / 2;
      var ratePow = pow(1 + rate, time);
      double calculatedEmi = (principal * rate * ratePow) / (ratePow - 1);

      if (calculatedEmi > emiAmount) {
        upperBound = rate;
      } else {
        lowerBound = rate;
      }
    }

    // Calculate annual interest rate
    double data = rate * 12 * 100;

    // Round and format the result to an integer value
    int roundedInterestRate = data.round();

    // Set the result in the interestController, making sure it's an integer string
    interestController.text = roundedInterestRate.toString();
  }

//==============================================================================
//   **    Calculate Result Functions   **
//==============================================================================
  void manageResult() {
    List<Map<String, dynamic>> emiSchedule = [];
    var amount = convertToDouble(amountController.text);
    var interestRate = convertToDouble(interestController.text);
    var monthlyEmi = convertToDouble(monthlyEmiController.text);
    var monthTenor = selectedIndex.value == 2
        ? int.parse(periodController.text)
        : (period.value * 12).toInt();

    double totalInterest = (monthlyEmi * monthTenor) - amount;
    double totalPayment = amount + totalInterest;
    double loanPercentage = (amount / totalPayment) * 100;
    double interestPercentage = (totalInterest / totalPayment) * 100;

    for (int i = 1; i <= monthTenor; i++) {
      var interestPayment = amount * (interestRate / (12 * 100));
      var principalPayment = monthlyEmi - interestPayment;
      amount = amount - principalPayment;
      emiSchedule.add({
        'month': i,
        'principal': principalPayment < amount
            ? principalPayment > 0
                ? principalPayment.round()
                : 0
            : monthlyEmi,
        'interest': interestPayment > 0 ? interestPayment.round() : 0,
        'balance': amount > 0 ? amount.round() : 0,
      });
    }

    Map<String, dynamic> finalResult = {
      "created_at": DateTime.now().toString(),
      "monthly_emi": formatNumber(monthlyEmi),
      "total_interest": formatNumber(totalInterest),
      "processing_fees": "0",
      "total_payment": formatNumber(totalPayment),
      "loan_amount": amountController.text,
      "interest": interestController.text,
      "period": monthTenor.toString(),
      "loan_ratio": loanPercentage,
      "interest_ratio": interestPercentage,
      "emi_list": emiSchedule
    };

    emiResult = CalculateResult.fromJson(finalResult);
  }

  void resetData() {
    amountController.clear();
    interestController.clear();
    periodController.clear();
    monthlyEmiController.clear();
  }

  @override
  void onInit() {
    calculateEmi();
    super.onInit();
  }
}
