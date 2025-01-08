import 'dart:math';

import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../component/toast/app_toast.dart';
import '../../../../core/app_typography.dart';
import '../../../../model/local.dart';
import '../../../../utils/num_converter/num_converter.dart';

class RdController extends GetxController {
  final GlobalKey boundaryKey = GlobalKey();
  final GlobalKey<FormState> rdValidateKey = GlobalKey<FormState>();
  TextEditingController loanAmountController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  TextEditingController periodController = TextEditingController();
  TextStyle periodStyle = notoSans.copyWith(height: 1.2).get14.w600;
  RxInt selectedPeriodType = 0.obs;
  List<ToggleList> advancePeriodItem = [
    ToggleList(true, 'Years'),
    ToggleList(false, 'Months')
  ];

  bool isResultVisible = false;
  double totalInvestment = 0.0;
  double totalInterest = 0;
  double maturityAmount = 0;
  double totalInterestRatio = 0;
  double totalInvestmentRatio = 0;
  String maturityDate = '';

  void calculateResult() {
    if (loanAmountController.text.isEmpty) {
      showToast('Please enter a valid amount');
      return;
    }

    if (interestController.text.isEmpty ||
        convertToDouble(interestController.text) == 0) {
      showToast('Please enter a valid interest rate');
      return;
    }

    if (periodController.text.isEmpty ||
        convertToInt(periodController.text) == 0) {
      showToast('Please enter a valid period');
      return;
    }

    final double monthlyAmount = convertToDouble(loanAmountController.text);
    final double interestRate = convertToDouble(interestController.text);
    int period = convertToInt(periodController.text);

    if (selectedPeriodType.value == 0) {
      period *= 12;
    }

    final double totalInvestmentValue = monthlyAmount * period;

    final double maturityAmountValue = monthlyAmount *
        ((pow(1 + (interestRate / 400), period / 3) - 1) /
            (1 - pow(1 + (interestRate / 400), -1 / 3)));

    final double totalInterestValue =
        maturityAmountValue - totalInvestmentValue;

    totalInvestmentRatio = (totalInvestmentValue / maturityAmountValue) * 100;
    totalInterestRatio = (totalInterestValue / maturityAmountValue) * 100;

    final DateTime now = DateTime.now();
    final String maturityDateValue = DateFormat('dd MMM yyyy').format(
      selectedPeriodType.value == 1
          ? now.add(Duration(days: period * 30))
          : DateTime(
              now.year + (period ~/ 12), now.month + (period % 12), now.day),
    );

    totalInvestment = totalInvestmentValue;
    totalInterest = totalInterestValue;
    maturityAmount = maturityAmountValue;
    maturityDate = maturityDateValue;
    showAdAndNavigate(() {
      isResultVisible = true;
    });

    update();
  }

  void resetForm() {
    loanAmountController.clear();
    interestController.clear();
    periodController.clear();
    isResultVisible = false;
    update();
  }
}
