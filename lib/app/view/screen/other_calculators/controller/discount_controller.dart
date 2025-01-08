import 'package:advance_emi/app/utils/num_converter/num_converter.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/toast/app_toast.dart';

class DiscountController extends GetxController {
  final GlobalKey boundaryKey = GlobalKey();
  TextEditingController amountController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController salesTaxController = TextEditingController(text: "6.0");

  var selectedInterestType = 0.obs;
  var isResultVisible = false.obs;
  RxDouble discountedAmount = 0.0.obs;
  RxDouble savings = 0.0.obs;
  RxDouble payableAmount = 0.0.obs;
  RxDouble salesTax = 0.0.obs;

  void calculateDiscount() {
    if (amountController.text.isEmpty) {
      showToast("Please enter amount");
      return;
    }
    if (discountController.text.isEmpty) {
      showToast("Please enter discount");
      return;
    }

    final double amount = convertToDouble(amountController.text);
    final double discount = convertToDouble(discountController.text);
    final double tax = convertToDouble(salesTaxController.text);

    if (amount > 0 && discount > 0) {
      double taxValue;
      double discountValue;

      if (selectedInterestType.value == 0) {
        taxValue = amount * (tax / 100);
        discountValue = (amount + taxValue) * (discount / 100);
        payableAmount.value = (amount + taxValue) - discountValue;
      } else {
        discountValue = amount * (discount / 100);
        taxValue = (amount - discountValue) * (tax / 100);
        payableAmount.value = (amount - discountValue) + taxValue;
      }

      savings.value = discountValue;
      salesTax.value = taxValue;
    } else {
      savings.value = 0;
      payableAmount.value = 0;
      salesTax.value = 0;
    }
    showAdAndNavigate(() {
      isResultVisible.value = true;
    });

    update();
  }

  void resetData() {
    amountController.clear();
    discountController.clear();
    salesTaxController.text = '6.0';
    selectedInterestType.value = 0;
    discountedAmount.value = 0;
    savings.value = 0;
    payableAmount.value = 0;
    salesTax.value = 0;
    isResultVisible.value = false;
    update();
  }
}
