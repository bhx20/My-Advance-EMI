import 'package:advance_emi/app/core/app_typography.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/app_colors.dart';

class PieChatView extends StatefulWidget {
  final double interestRatio;
  final double loanRatio;
  final double? centerSpaceRadius;
  const PieChatView({
    super.key,
    required this.interestRatio,
    required this.loanRatio,
    this.centerSpaceRadius,
  });

  @override
  State<PieChatView> createState() => _PieChatViewState();
}

class _PieChatViewState extends State<PieChatView> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    Widget buildLabel(Color color, String title) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 5.w),
            height: 5.h,
            width: 5.h,
            color: color,
          ),
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: Text(
              title,
              style: notoSans.w400.get8,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height: 130.h,
      width: 130.h,
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 1,
                centerSpaceRadius: widget.centerSpaceRadius ?? 45,
                sections: List.generate(2, (i) {
                  final isTouched = i == touchedIndex;
                  final radius = isTouched ? 60.0 : 50.0;
                  switch (i) {
                    case 0:
                      return PieChartSectionData(
                          color: AppColors.appColor.withOpacity(0.2),
                          value: widget.interestRatio,
                          title: '${widget.interestRatio}%',
                          radius: radius,
                          titleStyle: notoSans.black.bold.get10);
                    case 1:
                      return PieChartSectionData(
                          color: AppColors.appColor.withOpacity(0.7),
                          value: widget.loanRatio,
                          title: '${widget.loanRatio}%',
                          radius: radius,
                          titleStyle: notoSans.white.bold.get10);

                    default:
                      throw Error();
                  }
                }),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabel(AppColors.appColor.withOpacity(0.7), "Total Amount"),
                SizedBox(width: 5.h),
                buildLabel(
                    AppColors.appColor.withOpacity(0.2), "Total Interest"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
