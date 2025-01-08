import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/app_colors.dart';
import '../core/app_typography.dart';

class ConnectionWrapper extends StatefulWidget {
  const ConnectionWrapper({
    super.key,
  });
  @override
  State<ConnectionWrapper> createState() => _ConnectionWrapperState();
}

class _ConnectionWrapperState extends State<ConnectionWrapper> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.black.withOpacity(0.01),
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 50.h),
                        child: Text(
                          "NO INTERNET",
                          style: notoSans.get14.w600,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 40.w),
                        child: Text(
                          "Check your internet connection and try again.",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: notoSans.get10.w400.space09
                              .textColor(AppColors.dHUARGrey),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Text(
                          "PLEASE TURN ON",
                          style: notoSans.get9.black.w500.space09,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                AppSettings.openAppSettings(
                                    type: AppSettingsType.wifi);
                              },
                              child: Image.asset(
                                "assets/icons/wifi.png",
                                height: 35.h,
                              ),
                            )),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                AppSettings.openAppSettings(
                                    type: AppSettingsType.dataRoaming);
                              },
                              child: Image.asset(
                                "assets/icons/mobile_data.png",
                                height: 35.h,
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: -35,
                  child: Image.asset(
                    "assets/icons/wifi_lead.png",
                    height: 70.h,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget button(String title,
      {required String icon, required void Function() onTap}) {
    return Obx(() => InkWell(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(top: 5.h, left: 5.h, right: 5.h),
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
                color: AppColors.appColor,
                borderRadius: BorderRadius.circular(50)),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Image.asset(icon, color: AppColors.white, width: 18.w),
                ),
                Text(
                  title,
                  style: notoSans.get12.white.space09,
                ),
              ],
            )),
          ),
        ));
  }
}
