import 'package:advance_emi/app/core/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';
import '../app_textformfield/common_field.dart';

class SliderField extends StatelessWidget {
  final String title;
  final String? label;
  final double value;
  final double min;
  final double max;
  final double? width;
  final String suffixText;
  final ValueChanged<double> sliderOnChange;
  final Function(String)? fieldOnChange;
  final int? divisions;
  final int? maxLength;
  final TextEditingController? controller;
  final List<TextInputFormatter>? numFormater;

  const SliderField({
    super.key,
    required this.title,
    this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffixText,
    required this.sliderOnChange,
    this.divisions,
    this.fieldOnChange,
    this.numFormater,
    this.controller,
    this.maxLength,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppTextFormField(
              radioButton: false,
              controller: controller,
              title: title,
              width: width,
              suffixText: suffixText,
              onChanged: fieldOnChange,
              numFormater: numFormater,
              maxLength: maxLength,
            ),
            if (label != null)
              Padding(
                padding: EdgeInsets.only(right: 5.w, top: 3.h),
                child: Text(
                  label ?? "",
                  style: notoSans.w400.get12.appColor,
                ),
              ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              trackHeight: 1.5,
              tickMarkShape: SliderTickMarkShape.noTickMark,
              overlayShape: SliderComponentShape.noOverlay),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Slider(
              thumbColor: AppColors.appColor,
              activeColor: AppColors.appColor,
              value: value,
              min: min,
              max: max,
              onChanged: sliderOnChange,
              divisions: divisions,
            ),
          ),
        ),
      ],
    );
  }
}
