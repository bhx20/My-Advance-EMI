
import 'package:advance_emi/app/view/screen/other_calculators/view/cash_counter/cash_counter.dart';
import 'package:get/get.dart';

import '../../../../model/local.dart';
import '../view/discount_calculator/discount_calculator_view.dart';

class OtherCalculator extends GetxController {
  List<ItemModel> otherCalculatorList = [
    ItemModel(
        title: "Cash Counter",
        icon: "assets/icons/cash_note_counter.png",
        route: const CashCounterView()),
    ItemModel(
        title: "Discount\nCalculator",
        icon: "assets/icons/discount_calculator.png",
        route: const DiscountCalculatorView()),
  ];
}
