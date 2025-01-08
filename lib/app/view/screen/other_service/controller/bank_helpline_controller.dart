import 'dart:convert';

import 'package:advance_emi/app/model/bank_helpLine_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/json_data/bank_list.dart';

class BankHelpLineController extends GetxController {
  Rx<BankHelpLineModel> bankData = BankHelpLineModel().obs;
  RxList<BankList> filteredBankList = <BankList>[].obs;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getBankListData();
  }

  getBankListData() {
    bankData.value = bankHelpLineModelFromJson(json.encode(bankJsonList));
    filteredBankList.assignAll(bankData.value.bankList!);
  }

  launchDialPad(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void filterSearchResults(String query) {
    List<BankList> searchResults = filteredBankList
        .where(
            (bank) => bank.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    filteredBankList.assignAll(searchResults);
    if (query.isEmpty) {
      filteredBankList.assignAll(bankData.value.bankList!);
    }
  }
}
