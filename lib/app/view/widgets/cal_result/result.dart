import 'package:advance_emi/app/core/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../component/app_button/app_button.dart';
import '../../../core/app_colors.dart';
import '../../../model/local.dart';

class Result extends StatelessWidget {
  const Result({
    super.key,
    required this.title,
    required this.data,
    this.titleStyle,
    this.dataStyle,
  });

  final String title;
  final String data;
  final TextStyle? titleStyle;
  final TextStyle? dataStyle;

  @override
  Widget build(BuildContext context) {
    if (data.isNotEmpty || data != "") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            flex: 6,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: titleStyle ?? notoSans.get10.w600,
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 100.w,
                  child: Center(
                    child: Text(
                      data,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: dataStyle ?? notoSans.get10.w600.appColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class ResultBox extends StatelessWidget {
  final Input data1;
  final Input data2;
  final Input data3;
  final Input result;
  final String shareData;
  const ResultBox({
    super.key,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.result,
    required this.shareData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white,
          border: Border.all(color: AppColors.border, width: 0.8)),
      margin: EdgeInsets.all(5.h),
      padding: EdgeInsets.all(5.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (data1.data.isNotEmpty)
            Result(
              title: data1.title,
              data: data1.data,
            ),
          if (data2.data.isNotEmpty)
            Result(
              title: data2.title,
              data: data2.data,
            ),
          if (data3.data.isNotEmpty)
            Result(
              title: data3.title,
              data: data3.data,
            ),
          if (result.data.isNotEmpty)
            Result(
              title: result.title,
              data: result.data,
              titleStyle: notoSans.get12.w600.appColor,
              dataStyle: notoSans.get12.w600.appColor,
            ),
          if (result.data.isNotEmpty)
            AppButton("Share", onPressed: () {
              Share.share(shareData);
            }),
        ],
      ),
    );
  }
}

Widget actionBar(BuildContext context,
    {required Function() calculatorTap, required Function() resetTap}) {
  return SizedBox(
    width: Get.width,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: AppButton("Calculate", onPressed: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                currentFocus.focusedChild?.unfocus();
              }
              calculatorTap();
            }),
          ),
          Expanded(
            child: AppButton(
              "Reset",
              style: notoSans.w500.get12.appColor,
              bg: AppColors.stoicWhite,
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  currentFocus.focusedChild?.unfocus();
                }
                resetTap();
              },
            ),
          ),
        ],
      ),
    ),
  );
}
