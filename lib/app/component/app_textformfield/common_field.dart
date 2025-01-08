import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/app_colors.dart';
import '../../core/app_typography.dart';

class AppTextFormField extends StatefulWidget {
  final RxBool readOnly;
  final String? Function(String?)? validate;
  final String? title;
  final String? hint;
  final IconData? icon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final int? maxLength;
  final bool? radioButton;
  final bool autoValidation;
  final String? labelText;
  final double? width;
  final String? suffixText;
  final double? topPadding;
  final Color? fillColor;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function()? onTap;
  final void Function()? radioTap;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? numFormater;
  final TextStyle? inputStyle;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final double? scaleY;
  AppTextFormField({
    super.key,
    this.icon,
    this.title,
    this.validate,
    this.suffixText,
    this.labelText,
    this.controller,
    this.suffixIcon,
    this.fillColor,
    this.width,
    this.keyboardType = TextInputType.number,
    this.onChanged,
    this.radioButton = true,
    this.prefix,
    this.maxLength,
    this.radioTap,
    this.autoValidation = true,
    this.onTap,
    this.textInputAction,
    this.hint,
    bool readOnly = false,
    this.numFormater,
    this.inputStyle,
    this.topPadding,
    this.textAlign,
    this.focusNode,
    this.scaleY,
  }) : readOnly = RxBool(readOnly);

  @override
  _AppTextFormFieldState createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  InputBorder border = const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.border, width: 0.8),
      borderRadius: BorderRadius.all(Radius.circular(5)));
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.radioTap,
          child: SizedBox(
            width: widget.title != null ? widget.width ?? 120.w : 0,
            height: 32.h,
            child: Row(
              children: [
                if (widget.radioButton == true)
                  Padding(
                    padding: EdgeInsets.only(right: 12.h),
                    child: Obx(
                      () => Image.asset(
                        widget.readOnly.isTrue
                            ? 'assets/icons/selected_icon.png'
                            : 'assets/icons/unselected_radio.png',
                        width: 18.w,
                        height: 18.h,
                      ),
                    ),
                  ),
                if (widget.title != null)
                  Text(widget.title ?? '', style: notoSans.black.get10.w600),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Transform.scale(
            scaleY: widget.scaleY ?? 0.85,
            child: TextFormField(
              readOnly: widget.readOnly.value,
              controller: widget.controller,
              validator: widget.validate,
              autofocus: false,
              onTap: widget.onTap,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              onChanged: widget.onChanged,
              cursorColor: AppColors.appColor,
              maxLength: widget.maxLength,
              autovalidateMode: widget.autoValidation
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              focusNode: widget.focusNode,
              textInputAction: widget.textInputAction ?? TextInputAction.next,
              style: widget.inputStyle ??
                  notoSans.copyWith(height: 1.2).get13.w600,
              inputFormatters: widget.numFormater,
              textAlign: widget.textAlign ?? TextAlign.start,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                  filled: true,
                  prefixIcon: widget.prefix,
                  fillColor: widget.fillColor ??
                      (widget.readOnly.isTrue
                          ? AppColors.lavenderBlue
                          : AppColors.white),
                  counterText: "",
                  hintText: widget.hint ?? "",
                  hintStyle: notoSans.w400
                      .textColor(AppColors.gray.withOpacity(0.5))
                      .get12,
                  suffixIcon: widget.suffixIcon,
                  suffixText: widget.suffixText,
                  labelText: widget.labelText,
                  focusedBorder: border,
                  enabledBorder: border,
                  border: border,
                  focusedErrorBorder: border,
                  errorBorder: border,
                  errorStyle: notoSans.red.get8),
            ),
          ),
        ),
      ],
    );
  }
}

//------------------------------------------------------------------------------
//Common Dropdown
//------------------------------------------------------------------------------

class AppDropdown extends StatefulWidget {
  final String hintText;
  final List options;
  final String value;
  final String? title;
  final String? Function(String?)? validate;
  final void Function(String?)? onChanged;

  const AppDropdown({
    super.key,
    this.hintText = 'Please select an Option',
    this.options = const [],
    required this.value,
    required this.onChanged,
    this.title,
    this.validate,
  });

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  @override
  Widget build(BuildContext context) {
    InputBorder border = const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.border, width: 0.8),
        borderRadius: BorderRadius.all(Radius.circular(5)));
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: SizedBox(
        height: 32.h,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SizedBox(
                width: widget.title != null ? 120.w : 0,
                child: Row(
                  children: [
                    Text(widget.title ?? '', style: notoSans.black.get10.w600),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: notoSans.black.get12,
                  menuMaxHeight: 200,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      filled: true,
                      fillColor: AppColors.white,
                      counterText: "",
                      hintText: "",
                      hintStyle: notoSans.w400
                          .textColor(AppColors.gray.withOpacity(0.5))
                          .get12,
                      focusedBorder: border,
                      enabledBorder: border,
                      border: border,
                      focusedErrorBorder: border,
                      errorBorder: border,
                      errorStyle: notoSans.red.get8),
                  dropdownColor: AppColors.white,
                  validator: (value) {
                    if (value != null) {
                      return null;
                    } else {
                      return "Please select ${widget.title?.toLowerCase()}";
                    }
                  },
                  value: widget.options.contains(widget.value)
                      ? widget.value
                      : null,
                  items: List.generate(
                      widget.options.length,
                      (index) => DropdownMenuItem(
                            value: widget.options[index],
                            child: Text(
                              widget.options[index] ?? "",
                              style: notoSans.black.get12,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                  elevation: 2,
                  onChanged: widget.onChanged,
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Icon(Icons.keyboard_arrow_down_outlined,
                        color: AppColors.black),
                  ),
                  focusColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
