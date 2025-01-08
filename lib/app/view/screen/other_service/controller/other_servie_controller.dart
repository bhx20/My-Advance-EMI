import 'package:get/get.dart';

import '../../../../model/local.dart';
import '../view/amount_to_word/amount_to_word.dart';
import '../view/bank_help_line/back_help_line.dart';
import '../view/bank_holidays/bank_holiday_view.dart';
import '../view/bank_ifsc/bank_ifsc_code_view.dart';

class OtherServiceController extends GetxController {
  List<ItemModel> otherServiceList = [
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
  ];
}
