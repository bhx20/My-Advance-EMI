import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../component/toast/app_toast.dart';
import '../../../../utils/num_converter/num_converter.dart';

class GSTController extends GetxController {
  final GlobalKey boundaryKey = GlobalKey();
  final GlobalKey<FormState> gstValidateKey = GlobalKey<FormState>();
  TextEditingController gSTOriginalPriceController = TextEditingController();
  TextEditingController gstPercentageController = TextEditingController();

  List<String> rateOfGst = ["5", "12", "18", "28", "Other"];
  var rateOfGstValue = "18".obs;
  var selectedInterestType = 0.obs;
  double initialAmount = 0;
  double gSTFinalPrice = 0;
  double gstAmount = 0;
  double cgstAmount = 0;
  double sgstAmount = 0;
  double cgstPercentage = 0;
  double sgstPercentage = 0;
  var isResultVisible = false.obs;

  // Calculation Method
  void calculateGST() {
    if (gSTOriginalPriceController.text.isEmpty) {
      showToast("Please enter the initial amount");
      return;
    }

    if (rateOfGstValue.value == "Other" &&
        gstPercentageController.text.isEmpty) {
      showToast("Please enter the custom GST percentage");
      return;
    }

    initialAmount = convertToDouble(gSTOriginalPriceController.text);
    double originalAmount =
        convertToDouble(gSTOriginalPriceController.text) ?? 0.0;
    double gstRate = rateOfGstValue.value == "Other"
        ? convertToDouble(gstPercentageController.text) ?? 0.0
        : convertToDouble(rateOfGstValue.value);

    if (selectedInterestType.value == 1) {
      gstAmount = originalAmount * gstRate / 100;
      gSTFinalPrice = originalAmount + gstAmount;
    } else {
      gstAmount = originalAmount - (originalAmount / (1 + (gstRate / 100)));
      gSTFinalPrice = originalAmount - gstAmount;
    }

    cgstAmount = gstAmount / 2;
    sgstAmount = gstAmount / 2;

    cgstPercentage = gstRate / 2;
    sgstPercentage = gstRate / 2;
    showAdAndNavigate(() {
      isResultVisible.value = true;
    });

    update();
  }

  // Reset all values
  void reset() {
    gSTOriginalPriceController.clear();
    gstPercentageController.clear();
    rateOfGstValue.value = "18";
    selectedInterestType.value = 0;
    gSTFinalPrice = 0.0;
    gstAmount = 0.0;
    cgstAmount = 0.0;
    sgstAmount = 0.0;
    isResultVisible.value = false;
    update();
  }
}
