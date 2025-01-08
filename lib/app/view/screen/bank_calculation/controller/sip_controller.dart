import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SIPController extends GetxController {
  final GlobalKey<FormState> sipValidateKey = GlobalKey<FormState>();
  TextEditingController sipMonthlyInvestmentController =
      TextEditingController();
  TextEditingController sipAnnualInterestRateController =
      TextEditingController();
  TextEditingController sipInvestmentPeriodController = TextEditingController();

  var futureValue = 0.0.obs;

  void calculateFutureValue() {
    double monthlyInvestment =
        double.parse(sipMonthlyInvestmentController.text);
    double annualInterestRate =
        double.parse(sipAnnualInterestRateController.text) / 12 / 100;
    int investmentPeriod = int.parse(sipInvestmentPeriodController.text);

    int totalMonths = investmentPeriod * 12;
    double futureValue = monthlyInvestment *
        ((pow(1 + annualInterestRate, totalMonths) - 1) / annualInterestRate);

    this.futureValue.value = futureValue;
  }
}
