import 'dart:math';

import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/toast/app_toast.dart';
import '../../../../model/prePyament_roiChange_model.dart';
import '../../../../utils/num_converter/num_converter.dart';

class RevisedEmiAndTenureController extends GetxController {
  final TextEditingController outstandingAmountController =
      TextEditingController();
  final TextEditingController currentRateController = TextEditingController();
  final TextEditingController currentEmiController = TextEditingController();
  final TextEditingController revisedRateController = TextEditingController();
  final TextEditingController prePaymentAmountController =
      TextEditingController();

  double newEmi = 0.0;
  double emiDifference = 0.0;
  double oldEmi = 0.0;
  double newInterest = 0.0;
  double interestDifference = 0.0;
  double interestDifferenceTenure = 0.0;
  double oldInterest = 0.0;
  double oldInterestEmi = 0.0;
  double oldMonths = 0.0;
  double newMonths = 0.0;
  double monthsDifference = 0.0;
  bool isResultVisible = false;

  var selectedIndex = 0.obs;
  List<CalculationHistory> historyList = [];

  List<String> toggleItem = [
    'Pre Payment',
    'ROI Change',
  ];
  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
    update();
  }

  void calculate() {
    if (_areFieldsEmpty()) {
      showToast('Please fill all the fields.');
      return;
    }

    showAdAndNavigate(() {
      if (selectedIndex.value == 1) {
        _calculateROIChange();
      } else {
        _calculatePrePayment();
      }
      // _storeCalculationHistory();
    });
  }

  bool _areFieldsEmpty() {
    return outstandingAmountController.text.isEmpty ||
        currentRateController.text.isEmpty ||
        currentEmiController.text.isEmpty ||
        (selectedIndex.value == 1
            ? revisedRateController.text.isEmpty
            : prePaymentAmountController.text.isEmpty);
  }

  void _calculatePrePayment() {
    double outstandingAmount =
        convertToDouble(outstandingAmountController.text);
    double currentRate = convertToDouble(currentRateController.text);
    double currentEmi = convertToDouble(currentEmiController.text);
    double prePaymentAmount = convertToDouble(prePaymentAmountController.text);

    if (outstandingAmount <= 0) {
      showToast('Outstanding Amount must be greater than zero.');
      isResultVisible = false;
      update();
      return;
    }

    if (prePaymentAmount <= 0) {
      showToast('Pre Payment Amount must be greater than zero.');
      isResultVisible = false;
      update();
      return;
    }

    if (prePaymentAmount > outstandingAmount) {
      showToast(
          'Pre Payment Amount cannot be greater than Outstanding Amount.');
      isResultVisible = false;
      update();
      return;
    }

    if (currentEmi > outstandingAmount) {
      showToast(
          'Current Emi Amount cannot be greater than Outstanding Amount.');
      isResultVisible = false;
      update();
      return;
    }

    if (currentEmi <= 0) {
      showToast('Current EMI must be greater than zero.');
      isResultVisible = false;
      update();
      return;
    }

    if (currentRate <= 0) {
      showToast('currentRate must be greater than zero.');
      isResultVisible = false;
      update();
      return;
    }

    double principal = outstandingAmount - prePaymentAmount;
    double monthlyRate = currentRate / 12 / 100;

    if (monthlyRate > 0 && currentEmi > outstandingAmount * monthlyRate) {
      oldMonths = (log(currentEmi) -
              log(currentEmi - (outstandingAmount * monthlyRate))) /
          log(1 + monthlyRate);
    } else {
      oldMonths = 0.0;
    }

    oldEmi = currentEmi;

    if (monthlyRate > 0 && currentEmi > principal * monthlyRate) {
      newMonths =
          (log(currentEmi) - log(currentEmi - (principal * monthlyRate))) /
              log(1 + monthlyRate);
    } else {
      newMonths = 0.0;
    }

    if (monthlyRate > 0 && oldMonths > 0) {
      newEmi = (principal * monthlyRate * pow(1 + monthlyRate, oldMonths)) /
          (pow(1 + monthlyRate, oldMonths) - 1);
    } else if (oldMonths > 0) {
      newEmi = principal / oldMonths;
    } else {
      newEmi = 0.0;
    }

    if (oldMonths > 0) {
      oldInterest = (currentEmi * oldMonths) - principal;
    } else {
      oldInterest = 0.0;
    }

    if (oldMonths > 0) {
      oldInterestEmi = (newEmi * oldMonths) - principal;
    } else {
      oldInterestEmi = 0.0;
    }

    if (newMonths > 0) {
      newInterest = (currentEmi * newMonths) - principal;
    } else {
      newInterest = 0.0;
    }

    emiDifference = oldEmi - newEmi;
    interestDifference = oldInterest - oldInterestEmi;
    interestDifferenceTenure = newInterest - oldInterest;
    monthsDifference = oldMonths - newMonths;

    isResultVisible = true;
    update();
  }

  void _calculateROIChange() {
    double outstandingAmount =
        convertToDouble(outstandingAmountController.text);
    double currentEmi = convertToDouble(currentEmiController.text);
    double currentRate = convertToDouble(currentRateController.text);
    double revisedRate = convertToDouble(revisedRateController.text);

    // Validate input
    if (outstandingAmount <= 0) {
      showToast('Outstanding Amount must be greater than zero.');
      isResultVisible = false;
      update();
      return;
    }

    if (currentEmi > outstandingAmount) {
      showToast(
          'Current EMI Amount cannot be greater than Outstanding Amount.');
      isResultVisible = false;
      update();
      return;
    }

    if (revisedRate <= 0) {
      showToast('Revised Rate must be greater than zero.');
      isResultVisible = false;
      update();
      return;
    }

    if (currentEmi <= 0) {
      showToast('Current EMI must be greater than zero.');
      isResultVisible = false;
      update();
      return;
    }

    if (currentRate <= 0) {
      showToast('Current Rate must be greater than zero.');
      isResultVisible = false;
      update();
      return;
    }

    double monthlyRateRoi = currentRate / 12 / 100;
    double monthlyRate = revisedRate / 12 / 100;
    double oldEmi = currentEmi;

    // Calculate old months
    if (monthlyRateRoi > 0 && currentEmi > outstandingAmount * monthlyRateRoi) {
      oldMonths = (log(currentEmi) -
              log(currentEmi - (outstandingAmount * monthlyRateRoi))) /
          log(1 + monthlyRateRoi);
      if (oldMonths.isInfinite || oldMonths.isNaN) {
        showToast('Invalid input, check EMI or Rate.');
        isResultVisible = false;
        update();
        return;
      }
    } else {
      oldMonths = 0.0;
    }

    // Calculate new EMI, interest, and tenure
    if (monthlyRate > 0) {
      newEmi =
          (outstandingAmount * monthlyRate * pow(1 + monthlyRate, oldMonths)) /
              (pow(1 + monthlyRate, oldMonths) - 1);

      if (newEmi.isInfinite || newEmi.isNaN) {
        showToast('Invalid input, check EMI or Rate.');
        isResultVisible = false;
        update();
        return;
      }

      oldInterest = (oldEmi * oldMonths) - outstandingAmount;
      oldInterestEmi = (newEmi * oldMonths) - outstandingAmount;
      newInterest = (oldEmi * newMonths) - outstandingAmount;

      newMonths =
          (log(oldEmi) - log(oldEmi - outstandingAmount * monthlyRate)) /
              log(1 + monthlyRate);

      if (newMonths.isInfinite || newMonths.isNaN) {
        showToast('Invalid input, tenure calculation error.');
        isResultVisible = false;
        update();
        return;
      }

      // Calculate differences in EMI and interest
      emiDifference = oldEmi - newEmi;
      interestDifference = oldInterest - oldInterestEmi;
      interestDifferenceTenure = newInterest - oldInterest;
      monthsDifference = oldMonths - newMonths;

      update();
    } else {
      // Handle case where new rate is zero
      newEmi = 0.0;
      newInterest = 0.0;
      emiDifference = 0.0;
      interestDifference = 0.0;
      interestDifferenceTenure = 0.0;
      newMonths = 0;
    }

    isResultVisible = true;
    update();
  }

  void _storeCalculationHistory() {
    historyList.add(
      CalculationHistory(
        createdAt: DateTime.now(),
        outstandingAmount: convertToDouble(outstandingAmountController.text),
        currentRate: convertToDouble(currentRateController.text),
        currentEmi: convertToDouble(currentEmiController.text),
        revisedRate: selectedIndex.value == 1
            ? convertToDouble(revisedRateController.text)
            : 0.0,
        prePaymentAmount: selectedIndex.value == 1
            ? 0.0
            : convertToDouble(prePaymentAmountController.text),
        newEmi: newEmi,
        emiDifference: emiDifference,
        oldEmi: oldEmi,
        newInterest: newInterest,
        interestDifference: interestDifference,
        interestDifferenceTenure: interestDifferenceTenure,
        oldInterest: oldInterest,
        oldInterestEmi: oldInterestEmi,
        oldMonths: oldMonths,
        newMonths: newMonths,
        monthsDifference: monthsDifference,
        isRevisedRateView: selectedIndex.value == 1,
      ),
    );
  }

  void reset() {
    outstandingAmountController.clear();
    currentRateController.clear();
    currentEmiController.clear();
    revisedRateController.clear();
    prePaymentAmountController.clear();

    newEmi = 0.0;
    emiDifference = 0.0;
    oldEmi = 0.0;

    newInterest = 0.0;
    interestDifference = 0.0;
    interestDifferenceTenure = 0.0;

    oldMonths = 0.0;
    newMonths = 0.0;
    monthsDifference = 0.0;

    isResultVisible = false;
    update();
  }
}
