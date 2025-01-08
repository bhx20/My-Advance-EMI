import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CashCounter {
  final RxInt currency;
  final RxInt total;
  late TextEditingController count;

  CashCounter({
    required this.currency,
    required this.count,
    required this.total,
  });
}

class CashCounterController extends GetxController {
  RxDouble grandTotal = 0.00.obs;
  RxInt customAmount = 0.obs;
  RxInt totalNotes = 0.obs;
  final customController = TextEditingController();
  List<CashCounter> cashList = [
    CashCounter(
        currency: 2000.obs, count: TextEditingController(), total: 0.obs),
    CashCounter(
        currency: 500.obs, count: TextEditingController(), total: 0.obs),
    CashCounter(
        currency: 200.obs, count: TextEditingController(), total: 0.obs),
    CashCounter(
        currency: 100.obs, count: TextEditingController(), total: 0.obs),
    CashCounter(currency: 50.obs, count: TextEditingController(), total: 0.obs),
    CashCounter(currency: 20.obs, count: TextEditingController(), total: 0.obs),
    CashCounter(currency: 10.obs, count: TextEditingController(), total: 0.obs),
    CashCounter(currency: 5.obs, count: TextEditingController(), total: 0.obs),
    CashCounter(currency: 2.obs, count: TextEditingController(), total: 0.obs),
    CashCounter(currency: 1.obs, count: TextEditingController(), total: 0.obs),
    CashCounter(currency: 0.obs, count: TextEditingController(), total: 0.obs),
  ];

  @override
  void onInit() {
    super.onInit();
    for (var counter in cashList) {
      counter.count.addListener(() {
        updateTotalAndGrandTotal();
      });
    }
  }

  void resetData() {
    showAdAndNavigate(() {
      for (var item in cashList) {
        item.count.text = "";
        item.total.value = 0;
      }
      customController.text = "";
      grandTotal.value = 0;
    });
  }

  void updateTotalAndGrandTotal() {
    double tempGrandTotal = 0.0;
    int tempTotalNotes = 0;

    for (var counter in cashList) {
      int count = int.tryParse(counter.count.text) ?? 0;
      if (counter.currency.value != 0) {
        counter.total.value = counter.currency.value * count;
      } else {
        counter.total.value = customAmount.value * count;
      }

      tempGrandTotal += counter.total.value;
      tempTotalNotes += count;
    }

    grandTotal.value = tempGrandTotal;
    totalNotes.value = tempTotalNotes;
  }

  void decreaseCounter(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (cashList[index].count.text.isEmpty) {
      cashList[index].count.text = "0";
    }
    int count = int.parse(cashList[index].count.text);
    if (count > 0) {
      count--;
      cashList[index].count.text = count.toString();
      updateTotalAndGrandTotal();
    }
  }

  void increaseCounter(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (cashList[index].count.text.isEmpty) {
      cashList[index].count.text = "0";
    }
    int count = int.parse(cashList[index].count.text);
    count++;
    cashList[index].count.text = count.toString();
    updateTotalAndGrandTotal();
  }

  void calculateCounter(int index, int count) {
    cashList[index].count.text = count.toString();
    updateTotalAndGrandTotal();
  }
}
