import 'dart:convert';
import 'dart:math';

import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../component/toast/app_toast.dart';
import '../../../../core/app_string.dart';
import '../../../../core/app_typography.dart';
import '../../../../model/emi_result_model.dart';
import '../../../../model/local.dart';
import '../../../../utils/local_store/sql_helper.dart';
import '../../../../utils/num_converter/num_converter.dart';
import '../../../../utils/num_formater/num_formater.dart';
import '../view/advance_emi/advance_emi.dart';
import '../view/compare_loans/compare_loan.dart';
import '../view/emi_calculator/emi_calculator.dart';
import '../view/quick_calculator/quick_calculator_screen.dart';

class EmiCalculatorController extends GetxController {
  CalculateResult? emiResult;
  ScrollController scrollController = ScrollController();
  List<ItemModel> emiCalculatorList = [
    ItemModel(
        icon: "assets/icons/emi_calculator.png",
        title: 'EMI Calculator',
        route: const EmiCalculatorView()),
    ItemModel(
        icon: "assets/icons/quick_calculator.png",
        title: 'Quick Calculator',
        route: const QuickCalculatorScreen()),
    ItemModel(
        icon: "assets/icons/advance_emi.png",
        title: 'Advance EMI',
        route: const AdvanceEMIView()),
    ItemModel(
        icon: "assets/icons/compare_loans.png",
        title: 'Compare Loans',
        route: const CompareLoanView()),
  ];

//==============================================================================
// ** EMI Controller **
//==============================================================================

  final TextEditingController amountController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController periodController = TextEditingController();
  final TextEditingController emiController = TextEditingController();
  final TextEditingController processingFeeController = TextEditingController();
  TextStyle periodStyle = notoSans.get14.w600;
  int touchedIndex = -1;
  RxInt selectedPeriodIndex = 0.obs;
  RxBool isCustomAmount = false.obs;
  RxBool isCustomInterest = false.obs;
  RxBool isCustomPeriod = false.obs;
  RxBool isCustomEmi = true.obs;
  double startAngle = 0.0;
  final dbHelper = DbHelper.instance;

  int selectedPeriodType = 0;

  final formKey = GlobalKey<FormState>();

  void handleRadioChange(String field) {
    switch (field) {
      case 'Amount':
        isCustomAmount.value = true;
        isCustomInterest.value = false;
        isCustomPeriod.value = false;
        isCustomEmi.value = false;
        break;
      case 'Interest %':
        isCustomAmount.value = false;
        isCustomInterest.value = true;
        isCustomPeriod.value = false;
        isCustomEmi.value = false;
        break;
      case 'Period':
        isCustomAmount.value = false;
        isCustomInterest.value = false;
        isCustomPeriod.value = true;
        isCustomEmi.value = false;
        break;
      case 'EMI':
        isCustomAmount.value = false;
        isCustomInterest.value = false;
        isCustomPeriod.value = false;
        isCustomEmi.value = true;
        break;
      default:
        break;
    }
    update();
  }

  @override
  void onInit() {
    getLoanData();
    super.onInit();
  }

  List<ToggleList> toggleItem = [
    ToggleList(true, 'Years'),
    ToggleList(false, 'Months')
  ];

  void onPeriodChanged(int index) {
    selectedPeriodType = index;
    for (int i = 0; i < toggleItem.length; i++) {
      toggleItem[i].isSelected = false;
    }
    toggleItem[index].isSelected = true;
    update();
  }

  double calculateEmiValue(var principal, var annualInterestRate, var months) {
    var monthlyInterestRate = annualInterestRate / (12 * 100);
    return (principal *
            monthlyInterestRate *
            pow(1 + monthlyInterestRate, months)) /
        (pow(1 + monthlyInterestRate, months) - 1);
  }

//==============================================================================
//   **    Calculate EMI   **
//==============================================================================
  calculateEmi() {
    bool isAmountFieldEmpty = amountController.text.isEmpty;
    bool isInterestFieldEmpty = interestController.text.isEmpty;
    bool isPeriodFieldEmpty = periodController.text.isEmpty;
    bool isEmiFieldEmpty = emiController.text.isEmpty;
    if (isAmountFieldEmpty && isCustomAmount.value == false) {
      showToast("Please Fill Amount Field.");
      return;
    }

    if (isInterestFieldEmpty && isCustomInterest.value == false) {
      showToast("Please Fill Interest(%) Field.");
      return;
    }

    if (isPeriodFieldEmpty && isCustomPeriod.value == false) {
      showToast("Please Fill Period Field.");
      return;
    }
    if (isEmiFieldEmpty && isCustomEmi.value == false) {
      showToast("Please Fill EMI Field.");
      return;
    }

    double principal =
        isAmountFieldEmpty ? 0 : convertToDouble(amountController.text);
    double rate = isInterestFieldEmpty
        ? 0
        : convertToDouble(interestController.text) / 12 / 100;
    double emiAmount =
        isEmiFieldEmpty ? 0 : convertToDouble(emiController.text);
    double time = 0;
    if (!isPeriodFieldEmpty) {
      time = convertToDouble(periodController.text);
      if (selectedPeriodType == 0) {
        time *= 12;
      }
    }
    if (isCustomAmount.value == true) {
      calculateAmount(rate, time, emiAmount);
    }
    if (isCustomInterest.value == true) {
      calculateInterestRate(principal, time, emiAmount);
    }
    if (isCustomPeriod.value == true) {
      calculatePeriod(principal, rate, emiAmount);
    }
    if (isCustomEmi.value == true) {
      calculateMonthlyEmi(principal, rate, time);
    }
    manageResult();

    update();
  }

//==============================================================================
//   **    Calculate Functions   **
//==============================================================================

  calculateAmount(rate, time, emiAmount) {
    double principal =
        emiAmount * (pow(1 + rate, time) - 1) / (rate * pow(1 + rate, time));
    amountController.text = formatNumber(principal);
  }

  void calculatePeriod(double principal, double rate, double emiAmount) {
    if (emiAmount <= principal * rate) {
      showToast("Invalid Input.");
      return;
    }
    double calculatedTime =
        (log(emiAmount) - log(emiAmount - (principal * rate))) / log(1 + rate);
    if (selectedPeriodType == 0) {
      if (calculatedTime.truncate() < 12) {
        periodController.text = "Less then year";
        if (periodController.text == "Less then year") {
          periodStyle = notoSans.copyWith(height: 1.2).get10.w600;
          update();
        }
      } else {
        periodController.text = (calculatedTime / 12).truncate().toString();
        periodStyle = notoSans.copyWith(height: 1.2).get14.w600;
      }
    } else {
      periodStyle = notoSans.copyWith(height: 1.2).get14.w600;
      periodController.text = calculatedTime.truncate().toString();
    }
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
    var data = rate * 12 * 100;
    if (data > 100) {
      interestController.text = 100.round().toString();
    } else {
      interestController.text = data.round().toString();
    }
  }

  calculateMonthlyEmi(principal, rate, time) {
    try {
      double emi =
          (principal * rate * pow(1 + rate, time)) / (pow(1 + rate, time) - 1);
      emiController.text = formatNumber(emi);
    } catch (e) {
      emiController.text = "";
    }
  }

  manageResult() async {
    List<Map<String, dynamic>> emiSchedule = [];
    var amount = convertToDouble(amountController.text);
    var interest = convertToDouble(interestController.text);
    var monthlyEmi = convertToDouble(emiController.text);
    var processingFee = convertToDouble(processingFeeController.text.isNotEmpty
        ? processingFeeController.text
        : "0.0");
    var monthTenor = 0;
    if (selectedPeriodType == 0) {
      if (periodController.text == "Less then year") {
        var rate = convertToDouble(interestController.text) / 12 / 100;
        double calculatedTime =
            (log(monthlyEmi) - log(monthlyEmi - (amount * rate))) /
                log(1 + rate);
        monthTenor = calculatedTime.truncate();
      } else {
        monthTenor = int.parse(periodController.text) * 12;
      }
    } else {
      monthTenor = int.parse(periodController.text);
    }

    double totalInterest = (monthlyEmi * monthTenor) - amount;
    if (totalInterest < 0) {
      showToast("Invalid Amount or EMI");
      resetData();
      return;
    }
    if (amount < monthlyEmi) {
      showToast("Invalid Amount or EMI");
      resetData();
      return;
    }
    double processingAmount = (amount * processingFee / 100);
    double totalPayment = amount + totalInterest;
    double loanPercentage = (amount / totalPayment) * 100;
    double interestPercentage = (totalInterest / totalPayment) * 100;

    for (int i = 1; i <= monthTenor; i++) {
      var interestPayment = amount * (interest / (12 * 100));
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
      "monthly_emi": emiController.text,
      "total_interest": formatNumber(totalInterest),
      "processing_fees": formatNumber(processingAmount),
      "total_payment": formatNumber(totalPayment),
      "loan_amount": amountController.text,
      "interest": interestController.text,
      "period": monthTenor.toString(),
      "loan_ratio": loanPercentage,
      "interest_ratio": interestPercentage,
      "emi_list": emiSchedule
    };

    String emiData = json.encode(finalResult);

    try {
      await dbHelper.insert(SqlTableString.advanceEmiTable, {
        SqlTableString.advanceEmi: emiData,
      }).then((value) {
        getLoanData();
        update();
      });
    } catch (e) {
      showToast("Error saving loan profile: $e");
    }
    showAdAndNavigate(() {
      emiResult = CalculateResult.fromJson(finalResult);
    });

    FocusManager.instance.primaryFocus?.unfocus();
    scrollToEnd();
  }

  scrollToEnd() {
    Future.delayed(const Duration(milliseconds: 100))
        .then((value) => scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            ));
  }

//==============================================================================
// ** Get Data For Database **
//==============================================================================

  // var emiCalculate = <HistoryResult>[].obs;
  var historyCalculate = <CalculateResult>[].obs;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  List<CalculateResult> get loanData => historyCalculate;
  Future<void> getLoanData() async {
    final dbHelper = DbHelper.instance;

    try {
      final List<Map<String, dynamic>>? loanData =
          await dbHelper.queryAll(SqlTableString.advanceEmiTable);
      String encodeData = json.encode(loanData);
      List<DbCalculateResult> dbCalculateResult =
          calculateResultFromJson(encodeData);
      if (dbCalculateResult.isNotEmpty) {
        historyCalculate.clear();

        for (var i = 0; i < dbCalculateResult.length; i++) {
          historyCalculate.add(CalculateResult(dbData: dbCalculateResult[i]));
          update();
        }
        update();
      }
    } catch (e) {
      showToast("Error fetching loan data: $e");
    }
  }

  resetData() {
    amountController.clear();
    interestController.clear();
    periodController.clear();
    emiController.clear();
    processingFeeController.clear();
    emiResult = null;
    update();
  }

  @override
  void dispose() {
    super.dispose();
    amountController.clear();
    interestController.clear();
    periodController.clear();
    emiController.clear();
    processingFeeController.clear();
  }
}
