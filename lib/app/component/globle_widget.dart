import 'package:advance_emi/app/core/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../core/app_colors.dart';
import 'app_button/app_button.dart';

TableRow buildTableRow(String title, String value,
    {TextStyle? titleStyle, TextStyle? valueStyle}) {
  return TableRow(
    children: [
      Padding(
        padding: EdgeInsets.all(8.h),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: titleStyle ?? notoSans.w700.get10,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8.h),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: valueStyle ?? notoSans.w600.get10,
        ),
      ),
    ],
  );
}

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.h),
          child: Text('Loading', style: notoSans.get10.space09.w500),
        ),
        SizedBox(
          width: 20.w,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Text('.' * (_controller.value * 4).floor(),
                  maxLines: 1, style: notoSans.get12.w500);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SimmerLoader extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  final Color? baseColor;
  final Color? highlightColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? decorationColor;

  const SimmerLoader({
    super.key,
    this.height,
    this.width,
    this.radius,
    this.baseColor,
    this.highlightColor,
    this.padding,
    this.margin,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.gray.withOpacity(0.1),
      highlightColor: highlightColor ?? AppColors.white.withOpacity(0.5),
      child: Container(
        margin: margin,
        width: width ?? Get.width,
        height: 40.h,
        decoration: BoxDecoration(
          color: decorationColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(radius ?? 15),
        ),
      ),
    );
  }
}

warning(BuildContext context,
    {required String content, required void Function() leadingTap}) {
  return showDialog(
    context: context,
    barrierColor: null,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Text(
                content ?? "",
                style: notoSans.black.get13.w500,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: AppButton(
                    radius: 10,
                    bg: AppColors.appColor,
                    style: notoSans.w500.get11.white,
                    "Yes",
                    onPressed: leadingTap,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: AppButton(
                    radius: 10,
                    bg: AppColors.stoicWhite,
                    style: notoSans.w500.get11.appColor,
                    "No",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
