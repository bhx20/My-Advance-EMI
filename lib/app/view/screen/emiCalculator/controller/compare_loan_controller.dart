import 'dart:math';

import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/toast/app_toast.dart';
import '../../../../model/local.dart';

class Loan {
  int principal = 0;
  double rate = 0.0;
  int tenure = 0;
  double emi = 0.0;
  DateTime createdAt = DateTime.now();
  TextEditingController principalController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController tenureController = TextEditingController();

  int selectedPeriodIndex = 0;

  int totalAmountPaid() {
    return (principal + totalInterestPaid()).toInt();
  }

  int totalInterestPaid() {
    return (emi * tenure - principal).toInt();
  }

  void calculateEmi() {
    int tenureInMonths = selectedPeriodIndex == 0 ? tenure * 12 : tenure;

    double monthlyRate = rate / 12 / 100;
    int totalPayments = tenureInMonths;

    emi = (principal * monthlyRate * pow(1 + monthlyRate, totalPayments)) /
        (pow(1 + monthlyRate, totalPayments) - 1);

    tenure = tenureInMonths;
  }
}

class CompareLoanController extends GetxController {
  List<Loan> loans = [Loan(), Loan()];
  var newDataList = [];
  final GlobalKey<FormState> compareLoanKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  RxBool isResult = false.obs;

  RxList<ToggleList> toggleItem = <ToggleList>[
    ToggleList(true, 'Years'),
    ToggleList(false, 'Months'),
  ].obs;

  var selectedPeriodIndex = 0.obs;

  void onPeriodChangedData(int newIndex, int oldIndex) {
    if (newIndex != oldIndex) {
      selectedPeriodIndex.value = newIndex;
    }
  }

  void onPeriodChanged(int index, int loanIndex) {
    loans[loanIndex].selectedPeriodIndex = index;
    selectedPeriodIndex.value = index;
    update();
  }

  void compareLoan() {
    if (compareLoanKey.currentState!.validate()) {
      bool allFieldsValid = true;
      String errorMessage = "";

      bool anyFieldEmpty = false;

      for (var loan in loans) {
        double? principal =
            double.tryParse(loan.principalController.text.replaceAll(',', ''));
        double? rate =
            double.tryParse(loan.rateController.text.replaceAll(',', ''));
        int? tenure =
            int.tryParse(loan.tenureController.text.replaceAll(',', ''));

        if (loan.principalController.text.isEmpty ||
            loan.rateController.text.isEmpty ||
            loan.tenureController.text.isEmpty) {
          anyFieldEmpty = true;
          break;
        }

        if (principal == null || principal <= 0) {
          errorMessage = "Loan Amount must be greater than zero.";
          allFieldsValid = false;
          break;
        } else if (rate == null || rate <= 0) {
          errorMessage = "Interest Rate must be greater than zero.";
          allFieldsValid = false;
          break;
        } else if (tenure == null || tenure <= 0) {
          errorMessage = "Period must be greater than zero.";
          allFieldsValid = false;
          break;
        }
      }

      if (anyFieldEmpty) {
        errorMessage = "Please enter all field values.";
      } else if (!allFieldsValid) {}

      if (errorMessage.isNotEmpty) {
        showToast(errorMessage);
        isResult.value = false;
        update();
        return;
      }

      try {
        newDataList.clear();
        for (var loan in loans) {
          loan.principal = _parseNumber(loan.principalController.text);
          loan.rate = double.parse(loan.rateController.text);
          loan.tenure = int.parse(loan.tenureController.text);

          loan.calculateEmi();

          newDataList.add(Loan()
            ..createdAt = DateTime.now()
            ..principal = loan.principal
            ..rate = loan.rate
            ..tenure = loan.tenure
            ..emi = loan.emi);
        }
        showAdAndNavigate(() {
          isResult.value = true;
        });

        update();
        FocusManager.instance.primaryFocus?.unfocus();
        scrollToEnd();
      } catch (e) {
        showToast("An error occurred during calculation.");
      }
    } else {
      showToast("Please enter all field values.");
    }
  }

  void addLoan(double principal, double rate, int tenure) {
    final newLoan = Loan();
    newLoan.principal = principal.toInt();
    newLoan.rate = rate;
    newLoan.tenure = tenure;

    int tenureInMonths = selectedPeriodIndex.value == 0 ? tenure * 12 : tenure;

    double monthlyRate = rate / 12 / 100;
    int totalPayments = tenureInMonths;

    newLoan.emi =
        (principal * monthlyRate * pow(1 + monthlyRate, totalPayments)) /
            (pow(1 + monthlyRate, totalPayments) - 1);

    newLoan.tenure = tenureInMonths;

    newDataList.add(Loan()
      ..createdAt = DateTime.now()
      ..principal = newLoan.principal
      ..rate = newLoan.rate
      ..tenure = newLoan.tenure
      ..emi = newLoan.emi);
    update();
  }

  int _parseNumber(String input) {
    return int.parse(input.replaceAll(',', ''));
  }

  void clearData() {
    newDataList.clear();
    update();
  }

  void resetDataLoan() {
    for (var loan in loans) {
      loan.principalController.clear();
      loan.rateController.clear();
      loan.tenureController.clear();
      loan.selectedPeriodIndex = 0;
    }
    newDataList.clear();
    isResult.value = false;
    update();
  }

  void scrollToEnd() {
    Future.delayed(const Duration(milliseconds: 100))
        .then((value) => scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            ));
  }

  @override
  void onInit() {
    super.onInit();
    selectedPeriodIndex.value = 0;
  }
}
