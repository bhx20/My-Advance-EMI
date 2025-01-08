import 'package:get/get.dart';

import '../../../../model/local.dart';
import '../view/fd_calculator/fd_calculator_view.dart';
import '../view/ppf_calculator/ppf_calculator_view.dart';
import '../view/rd_calculator/rd_calculator_view.dart';
import '../view/simple_calculator/simple_calculator_view.dart';

class BankCalculatorController extends GetxController {
  List<ItemModel> bankCalculatorList = [
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
  ];
}
