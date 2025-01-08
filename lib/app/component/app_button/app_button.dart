import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';
import '../../core/app_typography.dart';

//==============================================================================
// ** Elevated Button **
//==============================================================================
class AppButton extends StatelessWidget {
  final double? height;
  final double? radius;
  final double? width;
  final TextStyle? style;
  final String title;
  final Color? bg;
  final Color? borderColor;
  final Function() onPressed;

  const AppButton(
    this.title, {
    super.key,
    this.height,
    this.borderColor,
    this.width,
    this.style,
    required this.onPressed,
    this.bg,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      child: InkWell(
        onTap: onPressed,
        highlightColor: AppColors.trans,
        splashColor: AppColors.trans,
        child: SizedBox(
          height: height ?? 35.h,
          width: width,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1.w,
                  color: borderColor ?? AppColors.trans,
                ),
                borderRadius: BorderRadius.circular(radius ?? 7),
                color: bg ?? AppColors.appColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 0.5,
                    spreadRadius: 0.5,
                    color: AppColors.gray.withOpacity(0.3),
                  ),
                ]),
            child: Center(
                child: Text(
              title,
              style: style ?? notoSans.w500.get12.white,
            )),
          ),
        ),
      ),
    );
  }
}
