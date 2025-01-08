import 'package:advance_emi/app/core/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';
import '../../core/constant.dart';

showToast(String message) {
  final context = navigatorKey.currentContext;
  if (context == null) {
    return;
  }

  final snackBar = SnackBar(
    width: 220.w,
    content: CustomSnackBarContent(message: message),
    duration: const Duration(seconds: 1),
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    elevation: 0,
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class CustomSnackBarContent extends StatelessWidget {
  final String message;

  const CustomSnackBarContent({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.orchid, width: 1.2),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: AppColors.black.withOpacity(0.15),
                blurRadius: 2,
                spreadRadius: 0,
                offset: const Offset(0.5, 1))
          ]),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(message,
              textAlign: TextAlign.center, style: notoSans.black.get11),
        ),
      ),
    );
  }
}
