import 'dart:math';
import 'package:advance_emi/app/view/screen/emiCalculator/view/emi_calculator/emi_calculator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/local.dart';
import '../../bank_calculation/view/fd_calculator/fd_calculator_view.dart';
import '../../bank_calculation/view/ppf_calculator/ppf_calculator_view.dart';
import '../../bank_calculation/view/rd_calculator/rd_calculator_view.dart';
import '../../bank_calculation/view/simple_calculator/simple_calculator_view.dart';
import '../../emiCalculator/view/advance_emi/advance_emi.dart';
import '../../emiCalculator/view/compare_loans/compare_loan.dart';
import '../../emiCalculator/view/quick_calculator/quick_calculator_screen.dart';
import '../../gst_and_vat/view/gst_calculator/gst_calculator_view.dart';
import '../../gst_and_vat/view/vat_calculator/vat_calculator.dart';
import '../../loan_calculator/view/check_eligibility/check_eligibility.dart';
import '../../loan_calculator/view/loan_profile/loan_profile_view.dart';
import '../../loan_calculator/view/moratorium_calculator/moratorium_calculator.dart';
import '../../loan_calculator/view/prePyament_roiChange/revisedEmi_tenure_view.dart';
import '../../other_calculators/view/cash_counter/cash_counter.dart';
import '../../other_calculators/view/discount_calculator/discount_calculator_view.dart';
import '../../other_service/view/amount_to_word/amount_to_word.dart';
import '../../other_service/view/bank_help_line/back_help_line.dart';
import '../../other_service/view/bank_holidays/bank_holiday_view.dart';
import '../../other_service/view/bank_ifsc/bank_ifsc_code_view.dart';

class SearchDataController extends GetxController {
  var searchItems = <ItemModel>[].obs;
  var filteredItems = <ItemModel>[].obs;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    searchItems.assignAll([
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
      ItemModel(
        title: "Loan Profile",
        icon: "assets/icons/loan_profile.png",
        route: const LoanProfileView(),
      ),
      ItemModel(
        title: "PrePayment/ROI Change",
        icon: "assets/icons/prePayment.png",
        route: const RevisedEmiAndTenureView(),
      ),
      ItemModel(
        title: "Check Eligibility",
        icon: "assets/icons/check_eligibility.png",
        route: const CheckEligibilityView(),
      ),
      ItemModel(
        title: "Moratorium Calculator",
        icon: "assets/icons/moratorium_calculator.png",
        route: const MoratoriumCalculatorView(),
      ),
      ItemModel(
          icon: "assets/icons/fd_calculator.png",
          title: 'FD Calculator',
          route: const FDCalculatorView()),
      ItemModel(
          icon: "assets/icons/rd_calculator.png",
          title: 'RD Calculator',
          route: const RDCalculatorView()),
      ItemModel(
          icon: "assets/icons/ppf_calculator.png",
          title: 'PPF Calculator',
          route: const PPFCalculatorView()),
      ItemModel(
          icon: "assets/icons/simple_compound.png",
          title: 'Simple & Compound Interest Calculator',
          route: const SimpleCalculation()),
      ItemModel(
          icon: "assets/icons/gst_calculator.png",
          title: 'GST Calculator',
          route: const GSTCalculatorView()),
      ItemModel(
          icon: "assets/icons/vat.png",
          title: 'VAT Calculator',
          route: const VatCalculator()),
      ItemModel(
          title: "Cash Counter",
          icon: "assets/icons/cash_note_counter.png",
          route: const CashCounterView()),
      ItemModel(
          title: "Discount\nCalculator",
          icon: "assets/icons/discount_calculator.png",
          route: const DiscountCalculatorView()),
      ItemModel(
          title: "Amount to Word",
          icon: "assets/icons/amount_to_world.png",
          route: const AmountToWord()),
      ItemModel(
          title: "Bank Help Line",
          icon: "assets/icons/bank_help_line.png",
          route: const BankHelpLineView()),
      ItemModel(
          title: "Bank Holidays",
          icon: "assets/icons/bank_holidays.png",
          route: const BankHolidays()),
      ItemModel(
          title: "Bank IFSC",
          icon: "assets/icons/bank_ifsc_code.png",
          route: const BankIFSCCodeView()),
    ]);

    filteredItems.assignAll(searchItems);
    controller.addListener(() {
      filterItems(controller.text);
    });
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      filteredItems.assignAll(searchItems);
    } else {
      filteredItems.assignAll(
        searchItems.where(
            (item) => item.title.toLowerCase().contains(query.toLowerCase())),
      );
    }
    _shuffleItems(); // Shuffle after filtering
  }

  // Function to shuffle the items randomly
  void _shuffleItems() {
    filteredItems.shuffle(Random());
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }
}
