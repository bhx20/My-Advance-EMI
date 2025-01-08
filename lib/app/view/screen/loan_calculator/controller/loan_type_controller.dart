import 'package:get/get.dart';

import '../../../../model/local.dart';
import '../view/check_eligibility/check_eligibility.dart';
import '../view/loan_profile/loan_profile_view.dart';
import '../view/moratorium_calculator/moratorium_calculator.dart';
import '../view/prePyament_roiChange/revisedEmi_tenure_view.dart';

class LoanCalculatorController extends GetxController {
  List<ItemModel> loanTypeItem = [
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
  ];



}
