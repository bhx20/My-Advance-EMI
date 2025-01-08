import 'dart:convert';

import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../model/bank_holiday_model.dart';
import '../../../../../utils/json_data/bank_holidays.dart';
import '../../../../widgets/generated_scaffold.dart';
import 'bank_holidays.dart';

class BankHolidays extends StatefulWidget {
  const BankHolidays({super.key});

  @override
  State<BankHolidays> createState() => _BankHolidaysState();
}

class _BankHolidaysState extends State<BankHolidays> {
  Rx<BankHolidaysModel> bankHolidayList = BankHolidaysModel().obs;

  final ScrollController _scrollController = ScrollController();
  RxBool showAd = true.obs;

  @override
  void initState() {
    super.initState();
    getBankHoliday();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <= 0) {
        showAd(true);
      } else {
        showAd(false);
      }
    });
  }

  getBankHoliday() {
    bankHolidayList.value =
        bankHolidaysModelFromJson(json.encode(bankHolidays));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBar: myAppBar(
          titleText: "Bank Holidays",
        ),
        bottomNavigationBar: Obx(() => showAd.isTrue
            ? GoogleAdd.getInstance().showNative(isSmall: true)
            : const SizedBox()),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 20.h),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bankHolidayList.value.bankHoliday?.length,
                  itemBuilder: (context, index) {
                    return _typeSubItem(index);
                  }),
              GoogleAdd.getInstance().showNative()
            ],
          ),
        ));
  }

  Widget _typeSubItem(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: ListTile(
        onTap: () {
          var data = bankHolidayList.value.bankHoliday?[index];
          showAdAndNavigate(() {
            navigateTo(HolidayList(list: data?.list, title: data?.title ?? ""));
          });
        },
        tileColor: Colors.white54,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              bankHolidayList.value.bankHoliday?[index].poster ?? "",
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(bankHolidayList.value.bankHoliday?[index].title ?? "",
            style: notoSans.get12.w600),
        trailing: const Icon(
          Icons.arrow_forward_ios_outlined,
          size: 15,
        ),
      ),
    );
  }
}
