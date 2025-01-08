import 'dart:io';

import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../component/globle_widget.dart';
import '../../../../core/app_colors.dart';
import '../controller/drawer_controller.dart';

Drawer appDrawer() {
  return Drawer(
    width: 240.w,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    child: const DrawerWidget(),
  );
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: GetBuilder(
          init: AppDrawerController(),
          builder: (controller) {
            return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                child: Column(
                  children: List.generate(
                      controller.drawerMoreItem.length,
                      (index) => Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  showAdAndNavigate(() {
                                    if (index != 6) {
                                      controller.drawerMoreItem[index].onTap();
                                    } else {
                                      Get.back();
                                      warning(context,
                                          content:
                                              "Are you really want to close the app?",
                                          leadingTap: () {
                                        exit(0);
                                      });
                                    }
                                  });
                                },
                                leading: Image.asset(
                                  controller.drawerMoreItem[index].icon,
                                  width: 13.h,
                                  height: 13.h,
                                  color: AppColors.blackPANTHER,
                                ),
                                title: Text(
                                  controller.drawerMoreItem[index].title,
                                  style: notoSans.w500.get10.black,
                                ),
                              ),
                              Divider(
                                height: 2,
                                color: AppColors.gray.withOpacity(0.1),
                              )
                            ],
                          )),
                ));
          }),
    );
  }
}
