import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/toast/app_toast.dart';
import '../../../../utils/num_converter/num_converter.dart';

class VatController extends GetxController {
  final GlobalKey boundaryKey = GlobalKey();
  final GlobalKey<FormState> gstValidateKey = GlobalKey<FormState>();
  TextEditingController gSTOriginalPriceController = TextEditingController();
  TextEditingController gstPercentageController =
      TextEditingController(text: "6.0");

  var selectedInterestType = 0.obs;
  double initialAmount = 0;
  double gSTFinalPrice = 0;
  double gstAmount = 0;
  var isResultVisible = false.obs;

  // Calculation Method
  void calculateVAT() {
    if (gSTOriginalPriceController.text.isEmpty) {
      showToast("Please enter the amount");
      return;
    }

    if (gstPercentageController.text.isEmpty) {
      showToast("Please enter the custom VAT percentage");
      return;
    }

    initialAmount = convertToDouble(gSTOriginalPriceController.text);
    double originalAmount = convertToDouble(gSTOriginalPriceController.text);
    double gstRate = convertToDouble(gstPercentageController.text);

    if (selectedInterestType.value == 0) {
      gstAmount = originalAmount * gstRate / 100;
      gSTFinalPrice = originalAmount + gstAmount;
    } else {
      gstAmount = originalAmount * gstRate / (100 + gstRate);
      gSTFinalPrice = originalAmount - gstAmount;
    }
    showAdAndNavigate(() {
      isResultVisible.value = true;
    });

    update();
  }

  // Reset all values
  void reset() {
    gSTOriginalPriceController.clear();
    gstPercentageController.text = "6.0";
    selectedInterestType.value = 0;
    gSTFinalPrice = 0.0;
    gstAmount = 0.0;
    isResultVisible.value = false;
    update();
  }
}
