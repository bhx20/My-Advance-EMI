import 'dart:io';
import 'dart:math'; // For using the pow function
import 'dart:ui' as ui;

import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../component/google_add/InitialController.dart';
import '../../../../component/toast/app_toast.dart';
import '../../../../core/app_typography.dart';
import '../../../../model/local.dart';

class MoratoriumController extends GetxController {
  TextEditingController loanAmountController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  TextEditingController moratoriumPeriodController = TextEditingController();
  TextEditingController periodController = TextEditingController();
  TextEditingController installmentsPaidController = TextEditingController();
  TextStyle periodStyle = notoSans.copyWith(height: 1.2).get14.w600;
  RxInt selectedPeriodType = 0.obs; // 0 for Years, 1 for Months
  RxBool isResultVisible = false.obs;
  final GlobalKey boundaryKey = GlobalKey();
  var selectOptionType = "No change in monthly EMI".obs;
  List<ToggleList> advancePeriodItem = [
    ToggleList(true, 'Years'),
    ToggleList(false, 'Months')
  ];

  List<String> selectOption = [
    "No change in monthly EMI",
    "No change in loan tenure",
  ];
  // Result fields for No Moratorium
  RxDouble totalPrincipalNoMoratorium = 0.0.obs;
  RxDouble monthlyEMINoMoratorium = 0.0.obs;
  RxDouble tenureNoMoratorium = 0.0.obs;
  RxDouble totalInterestNoMoratorium = 0.0.obs;
  RxDouble totalPaymentNoMoratorium = 0.0.obs;

  // Result fields for Moratorium Revise Tenure
  RxDouble totalPrincipalWithMoratorium = 0.0.obs;
  RxDouble monthlyEMIWithMoratorium = 0.0.obs;
  RxDouble tenureWithMoratorium = 0.0.obs;
  RxDouble totalInterestWithMoratorium = 0.0.obs;
  RxDouble totalPaymentWithMoratorium = 0.0.obs;
  bool isNoChangeInLoanTenureSelected() {
    return selectOptionType.value == "No change in loan tenure";
  }

  void calculateMoratorium() {
    if (_areFieldsEmpty()) {
      showToast('Please fill all the fields.');
      return;
    }
    double loanAmount =
        double.tryParse(loanAmountController.text.replaceAll(',', '')) ?? 0;
    double interestRate = double.tryParse(interestController.text) ?? 0;

    if (interestController.text.isEmpty || interestRate <= 0) {
      showToast('Please provide a valid interest rate.');
      return;
    }
    if (loanAmountController.text.isEmpty || loanAmount <= 0) {
      showToast('Please provide a valid Loan Amount.');
      return;
    }

    // Convert period and moratoriumPeriod to months based on selectedPeriodType
    int period = int.tryParse(periodController.text) ?? 0;
    int moratoriumPeriod = int.tryParse(moratoriumPeriodController.text) ?? 0;
    int installmentsPaid = int.tryParse(installmentsPaidController.text) ?? 0;

    if (periodController.text.isEmpty || period <= 0) {
      showToast('Please provide a valid Period.');
      return;
    }

    // Convert years to months if necessary
    if (selectedPeriodType.value == 0) {
      // 0 = Years, 1 = Months
      period = period * 12; // Convert years to months
      moratoriumPeriod = moratoriumPeriod * 12; // Convert years to months
      installmentsPaid = installmentsPaid * 12; // Convert years to months
    }

    // Convert annual interest rate to monthly rate
    double monthlyInterestRate = interestRate / (12 * 100);

    if (selectOptionType.value == "No change in loan tenure") {
      // 1. Calculate values for "No Moratorium"
      totalPrincipalNoMoratorium.value = loanAmount;
      monthlyEMINoMoratorium.value =
          calculateEMI(loanAmount, monthlyInterestRate, period);
      tenureNoMoratorium.value = period - installmentsPaid.toDouble();

      // 2. Calculate values for "Moratorium Revise Tenure"
      totalPrincipalWithMoratorium.value = loanAmount;
      monthlyEMIWithMoratorium.value = calculateEMI(
          loanAmount,
          monthlyInterestRate,
          (tenureNoMoratorium.value + moratoriumPeriod).toInt());
      tenureWithMoratorium.value = tenureNoMoratorium.value + moratoriumPeriod;

      // Calculate Total Interest and Total Payment for both scenarios
      totalInterestNoMoratorium.value =
          (monthlyEMINoMoratorium.value * period) - loanAmount;
      totalPaymentNoMoratorium.value =
          totalInterestNoMoratorium.value + loanAmount;

      totalInterestWithMoratorium.value = (monthlyEMIWithMoratorium.value *
              tenureWithMoratorium.value.toInt()) -
          loanAmount;
      totalPaymentWithMoratorium.value =
          totalInterestWithMoratorium.value + loanAmount;
    } else {
      // Case for "No change in EMI", adjust the tenure
      totalPrincipalNoMoratorium.value = loanAmount;
      monthlyEMINoMoratorium.value =
          calculateEMI(loanAmount, monthlyInterestRate, period);
      tenureNoMoratorium.value = period - installmentsPaid.toDouble();

      // 3. Calculate revised EMI after Moratorium (keeping EMI same, adjusting tenure)
      totalPrincipalWithMoratorium.value = loanAmount;
      monthlyEMIWithMoratorium.value =
          monthlyEMINoMoratorium.value; // No change in EMI
      tenureWithMoratorium.value = tenureNoMoratorium.value + moratoriumPeriod;

      // Calculate Total Interest and Total Payment for both scenarios
      totalInterestNoMoratorium.value =
          (monthlyEMINoMoratorium.value * period) - loanAmount;
      totalPaymentNoMoratorium.value =
          totalInterestNoMoratorium.value + loanAmount;

      totalInterestWithMoratorium.value = (monthlyEMIWithMoratorium.value *
              tenureWithMoratorium.value.toInt()) -
          loanAmount;
      totalPaymentWithMoratorium.value =
          totalInterestWithMoratorium.value + loanAmount;
    }
    showAdAndNavigate(() {
      isResultVisible.value = true;
    });

    update();
  }

  double calculateEMI(double principal, double monthlyRate, int tenure) {
    return (principal * monthlyRate * pow(1 + monthlyRate, tenure)) /
        (pow(1 + monthlyRate, tenure) - 1);
  }

  resetData() {
    loanAmountController.clear();
    interestController.clear();
    moratoriumPeriodController.clear();
    periodController.clear();
    installmentsPaidController.clear();
    isResultVisible.value = false;
    update();
  }

  bool _areFieldsEmpty() {
    return loanAmountController.text.isEmpty ||
        interestController.text.isEmpty ||
        moratoriumPeriodController.text.isEmpty ||
        periodController.text.isEmpty ||
        (selectOptionType.value != "No change in monthly EMI"
            ? installmentsPaidController.text.isEmpty
            : false);
  }

  Future<void> captureAndShareImage() async {
    try {
      RenderRepaintBoundary boundary = boundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final filePath = p.join(directory.path, 'loan_details.png');
      final imageFile = File(filePath)..writeAsBytesSync(pngBytes);

      Share.shareXFiles([XFile(imageFile.path)],
          text:
              'Calculated by: \n ${Get.find<InitialController>().dbData.value.shareLink ?? ""}');
    } catch (e) {
      showToast("Error sharing loan details: $e");
    }
  }
}
