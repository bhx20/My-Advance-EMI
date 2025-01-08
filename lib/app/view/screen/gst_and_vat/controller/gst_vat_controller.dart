
import 'package:get/get.dart';

import '../../../../model/local.dart';
import '../view/gst_calculator/gst_calculator_view.dart';
import '../view/vat_calculator/vat_calculator.dart';

class GSTAndVatController extends GetxController {
  List<ItemModel> calculatorList = [
    ItemModel(
        icon: "assets/icons/gst_calculator.png",
        title: 'GST Calculator',
        route: const GSTCalculatorView()),
    ItemModel(
        icon: "assets/icons/vat.png",
        title: 'VAT Calculator',
        route: const VatCalculator()),
  ];
}
