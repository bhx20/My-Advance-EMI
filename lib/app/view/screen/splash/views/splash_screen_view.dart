import 'package:advance_emi/app/core/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app_colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff6366f1),
          Color(0xff3335CF),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: Image.asset(
                        "assets/icons/splash_logo.png",
                        width: 120.w,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.w),
                        child: Text(
                          "EMI Calculator",
                          style: notoSans.white.w600.get18,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
                child: LinearProgressIndicator(
                  minHeight:
                      4.h, // Set minimum height for the progress indicator
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.appColor,
                  backgroundColor: AppColors.ECECFF,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
