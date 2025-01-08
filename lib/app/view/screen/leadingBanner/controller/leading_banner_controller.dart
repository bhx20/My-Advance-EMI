import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../component/google_add/InitialController.dart';
import '../../../../model/config_model.dart';
import '../../bank_calculation/view/fd_calculator/fd_calculator_view.dart';
import '../../bank_calculation/view/ppf_calculator/ppf_calculator_view.dart';
import '../../bank_calculation/view/rd_calculator/rd_calculator_view.dart';
import '../../bank_calculation/view/simple_calculator/simple_calculator_view.dart';
import '../../emiCalculator/view/advance_emi/advance_emi.dart';
import '../../emiCalculator/view/compare_loans/compare_loan.dart';
import '../../emiCalculator/view/emi_calculator/emi_calculator.dart';
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

class LeadingController extends GetxController {
  RxInt currentPageIndex = 0.obs;

  List<LeadingBanner> filteredLeadingPages = [];
  final List<LeadingBanner> leadingPages = [];

  @override
  void onInit() {
    super.onInit();
    fetchLeadingData();
  }

  void fetchLeadingData() {
    List<LeadingBanner>? allOnLeadingPages =
        Get.find<InitialController>().dbData.value.leadingBanners;
    filteredLeadingPages =
        allOnLeadingPages!.where((page) => page.show).toList();
    update();
  }

  Widget getScreen(String key) {
    switch (key) {
      case 'emi_calculator':
        return const EmiCalculatorView();
      case 'quick_calculator':
        return const QuickCalculatorScreen();
      case 'advance_emi':
        return const AdvanceEMIView();
      case 'compare_loans':
        return const CompareLoanView();
      case 'loan_profile':
        return const LoanProfileView();
      case 'prePayment':
        return const RevisedEmiAndTenureView();
      case 'check_eligibility':
        return const CheckEligibilityView();
      case 'moratorium_calculator':
        return const MoratoriumCalculatorView();
      case 'fd_calculator':
        return const FDCalculatorView();
      case 'rd_calculator':
        return const RDCalculatorView();
      case 'ppf_calculator':
        return const PPFCalculatorView();
      case 'simple_calculator':
        return const SimpleCalculation();
      case 'gst_calculator':
        return const GSTCalculatorView();
      case 'vat_calculator':
        return const VatCalculator();
      case 'cash_counter':
        return const CashCounterView();
      case 'discount_calculator':
        return const DiscountCalculatorView();
      case 'amount_to_word':
        return const AmountToWord();
      case 'bank_help_line':
        return const BankHelpLineView();
      case 'bank_holidays':
        return const BankHolidays();
      case 'bank_ifsc':
        return const BankIFSCCodeView();

      default:
        return const EmiCalculatorView(); // fallback screen if key doesn't match
    }
  }
}
