import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/app_colors.dart';
import '../../core/app_typography.dart';
import '../../core/constant.dart';

AppBar myAppBar({
  double? leadingWidth,
  Widget? leadingWidget,
  bool isBack = true,
  String? titleText,
  void Function()? onPressed,
  List<Widget>? actions,
}) {
  return AppBar(
    leading: leadingWidget ??
        (isBack
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.black,
                  size: 15.h,
                ),
                onPressed: onPressed ??
                    () {
                      Get.back();
                    },
              )
            : IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: AppColors.black,
                  size: 18.h,
                ),
                onPressed: () {
                  drawerKey.currentState?.openDrawer();
                },
              )),
    title: Text(
      titleText ?? "",
      style: notoSans.get14.black.w600,
    ),
    leadingWidth: leadingWidth,
    centerTitle: true,
    actions: actions,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0),
      ),
    ),
    backgroundColor: AppColors.white,
  );
}
