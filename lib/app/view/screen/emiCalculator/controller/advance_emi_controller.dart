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

class AdvanceEMIController extends GetxController {
  CalculateResult? emiResult;
  ScrollController scrollController = ScrollController();
  List<ItemModel> emiCalculatorList = [
    ItemModel(
        icon: "assets/icons/emi_calculator.png",
        title: 'EMI\nCalculator',
        route: const EmiCalculatorView()),
    ItemModel(
        icon: "assets/icons/quick_calculator.png",
        title: 'Quick\nCalculator',
        route: const QuickCalculatorScreen()),
    ItemModel(
        icon: "assets/icons/advance_emi.png",
        title: 'Advance\nEMI',
        route: const AdvanceEMIView()),
    ItemModel(
        icon: "assets/icons/compare_loans.png",
        title: 'Compare\nLoans',
        route: const CompareLoanView()),
  ];

  final TextEditingController amountController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController periodController = TextEditingController();
  final TextEditingController emiController = TextEditingController();
  final TextEditingController processingFeeController = TextEditingController();
  final TextEditingController gstOnInterest = TextEditingController();
  final TextEditingController gstOnProcessingFees = TextEditingController();
  final dbHelper = DbHelper.instance;

  TextStyle periodStyle = notoSans.copyWith(height: 1.2).get14.w600;
  int touchedIndex = -1;
  var selectedAdvanceType = 0.obs;
  var selectedPeriodType = 0.obs; // 0 for Years, 1 for Months
  RxInt selectedInterestIndex = 0.obs;
  RxInt selectedProcessingIndex = 0.obs;
  RxBool isCustomAmount = false.obs;
  RxBool isCustomInterest = false.obs;
  RxBool isCustomPeriod = false.obs;
  RxBool isCustomEmi = true.obs;
  double startAngle = 0.0;

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

  List<ToggleList> advanceInterestItem = [
    ToggleList(true, 'Reducing'),
    ToggleList(false, 'Flat')
  ];
  List<ToggleList> advancePeriodItem = [
    ToggleList(true, 'Years'),
    ToggleList(false, 'Months')
  ];
  List<ToggleList> advanceProcessingItem = [
    ToggleList(true, '%'),
    ToggleList(false, '₹')
  ];

  void updateSelectedPeriodType(int index) {
    selectedPeriodType.value = index;
  }

  void updateInterest(int index) {
    selectedInterestIndex.value = index;
  }

  void updateProcessingFees(int index) {
    selectedProcessingIndex.value = index;
  }

  double calculateEmiValue(var principal, var annualInterestRate, var months) {
    var monthlyInterestRate = annualInterestRate / (12 * 100);
    return (principal *
            monthlyInterestRate *
            pow(1 + monthlyInterestRate, months)) /
        (pow(1 + monthlyInterestRate, months) - 1);
  }

  calculateEmi() {
    bool isAmountFieldEmpty = amountController.text.isEmpty;
    bool isInterestFieldEmpty = interestController.text.isEmpty;
    bool isPeriodFieldEmpty = periodController.text.isEmpty;
    bool isEmiFieldEmpty = emiController.text.isEmpty;

    if (isAmountFieldEmpty && !isCustomAmount.value) {
      showToast("Please Fill Amount Field.");
      return;
    }

    if (isInterestFieldEmpty && !isCustomInterest.value) {
      showToast("Please Fill Interest(%) Field.");
      return;
    }

    if (isPeriodFieldEmpty && !isCustomPeriod.value) {
      showToast("Please Fill Period Field.");
      return;
    }
    if (isEmiFieldEmpty && !isCustomEmi.value) {
      showToast("Please Fill EMI Field.");
      return;
    }

    showAdAndNavigate(() {
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
        if (selectedPeriodType.value == 0) {
          time *= 12;
        }
      }

      if (isCustomAmount.value) {
        calculateAmount(rate, time, emiAmount);
      }
      if (isCustomInterest.value) {
        calculateInterestRate(principal, time, emiAmount);
      }
      if (isCustomPeriod.value) {
        calculatePeriod(principal, rate, emiAmount);
      }
      if (isCustomEmi.value) {
        calculateMonthlyEmi(principal, rate, time);
      }

      manageResult();
    });
    update();
  }

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

    if (selectedPeriodType.value == 0) {
      // If period type is "Years", convert to years
      periodController.text = (calculatedTime / 12).truncate().toString();
    } else {
      // If period type is "Months", use calculatedTime directly
      periodController.text = calculatedTime.truncate().toString();
    }
  }

  void calculateMonthlyEmi(double principal, double rate, double time) {
    try {
      double emi;
      if (selectedInterestIndex.value == 0) {
        // Reducing balance method
        emi = (principal * rate * pow(1 + rate, time)) /
            (pow(1 + rate, time) - 1);
      } else {
        // Flat rate method
        emi = calculateFlatEmiValue(principal, rate, time);
      }
      emiController.text = formatNumber(emi);
      update();
    } catch (e) {
      emiController.text = "";
      update();
    }
  }

  double calculateFlatEmiValue(double principal, double rate, double time) {
    double flatRate = convertToDouble(interestController.text);
    double flatTime = convertToDouble(periodController.text);
    double totalInterest;
    if (selectedPeriodType.value == 0) {
      totalInterest = (principal * flatRate * flatTime) / 100;
    } else {
      totalInterest = (principal * flatRate * flatTime) / (100 * 12);
    }
    double totalAmountPayable = principal + totalInterest;
    return totalAmountPayable / time;
  }

  double calculateReducingEmiValue(
      double principal, double annualInterestRate, double tenureInMonths) {
    double monthlyInterestRate = annualInterestRate / (12 * 100);
    return (principal *
            monthlyInterestRate *
            pow(1 + monthlyInterestRate, tenureInMonths)) /
        (pow(1 + monthlyInterestRate, tenureInMonths) - 1);
  }

  void calculateInterestRate(double principal, double time, double emiAmount) {
    double rate = 0.0;
    double lowerBound = 0.0;
    double upperBound = 1.0;
    double epsilon = 0.0000001;

    if (selectedInterestIndex.value == 0) {
      // Reducing balance method
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
      interestController.text = (data > 100 ? 100 : data).round().toString();
    } else {
      // Flat rate method
      double calculatedInterest =
          ((emiAmount * time) - principal) / principal * 100;
      interestController.text = (calculatedInterest / time).toStringAsFixed(2);
    }
  }

  manageResult() async {
    List<Map<String, dynamic>> emiSchedule = [];
    var amount = convertToDouble(amountController.text);
    var interest = convertToDouble(interestController.text);
    var monthlyEmi = convertToDouble(emiController.text);

    var gstInterest = convertToDouble(gstOnInterest.text);

    int monthTenor;
    if (selectedPeriodType.value == 0) {
      monthTenor = (int.parse(periodController.text) * 12).toInt();
    } else {
      monthTenor = (int.parse(periodController.text)).toInt();
    }
    double tenor = convertToDouble(periodController.text);
    double totalInterest;
    if (selectedInterestIndex.value == 0) {
      totalInterest = (monthlyEmi * monthTenor) - amount;
    } else if (selectedPeriodType.value == 0) {
      totalInterest = (amount * interest * tenor) / 100;
    } else {
      totalInterest = (amount * interest * tenor) / (100 * 12);
    }

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
    double processingFeeValue = processingFeeController.text.isEmpty
        ? 0
        : double.parse(processingFeeController.text);

    double processingAmount = (selectedProcessingIndex.value == 0)
        ? (amount * processingFeeValue / 100)
        : processingFeeValue;
    double gstOnInterestAmount = (totalInterest * gstInterest / 100);
    double gstOnProcessingFeeAmount = (processingAmount * 18 / 100);
    double totalPayment = amount +
        totalInterest +
        gstOnInterestAmount +
        gstOnProcessingFeeAmount +
        processingAmount;
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
      "gst_on_interest": formatNumber(gstOnInterestAmount),
      "gst_on_processing_fees": formatNumber(gstOnProcessingFeeAmount),
      "total_payment": formatNumber(totalPayment),
      "loan_amount": amountController.text,
      "interest": interestController.text,
      "period": monthTenor.toString(),
      "loan_ratio": loanPercentage,
      "interest_ratio": interestPercentage,
      "emi_list": emiSchedule
    };

    String loanProfile = json.encode(finalResult);

    try {
      await dbHelper.insert(SqlTableString.advanceEmiTable, {
        SqlTableString.advanceEmi: loanProfile,
      }).then((value) {
        getLoanData();
        update();
      });
      showToast("Advance Emi Data saved successfully");
    } catch (e) {
      showToast("Error saving loan profile: $e");
    }

    emiResult = CalculateResult.fromJson(finalResult);
    FocusManager.instance.primaryFocus?.unfocus();
    scrollToEnd();
  }

  void scrollToEnd() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

//==============================================================================
// ** Get Data For Database **
//==============================================================================

  var advanceCalculate = <CalculateResult>[].obs;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  List<CalculateResult> get loanData => advanceCalculate;
  Future<void> getLoanData() async {
    final dbHelper = DbHelper.instance;

    try {
      final List<Map<String, dynamic>>? loanData =
          await dbHelper.queryAll(SqlTableString.advanceEmiTable);
      String encodeData = json.encode(loanData);
      List<DbCalculateResult> dbCalculateResult =
          calculateResultFromJson(encodeData);
      if (dbCalculateResult.isNotEmpty) {
        advanceCalculate.clear();

        for (var i = 0; i < dbCalculateResult.length; i++) {
          advanceCalculate.add(CalculateResult(dbData: dbCalculateResult[i]));
          update();
        }
        update();
      }
    } catch (e) {
      showToast("Error fetching loan data: $e");
    }
  }

  void resetData() {
    amountController.clear();
    interestController.clear();
    periodController.clear();
    emiController.clear();
    processingFeeController.clear();
    gstOnInterest.clear();
    gstOnProcessingFees.clear();
    emiResult = null;
    update();
  }
}
