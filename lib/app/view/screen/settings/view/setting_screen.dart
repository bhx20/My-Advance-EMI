import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../component/app_bar/my_app_bar.dart';
import '../../../../component/app_button/app_button.dart';
import '../../../../component/globle_widget.dart';
import '../../../../component/toast/app_toast.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_typography.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/generated_scaffold.dart';
import '../../select_decimal_places/select_decimal_places.dart';
import '../../select_number_value/select_number_value.dart';
import '../controller/setting_controller.dart';

class SettingScreenView extends StatefulWidget {
  const SettingScreenView({super.key});

  @override
  State<SettingScreenView> createState() => _SettingScreenViewState();
}

class _SettingScreenViewState extends State<SettingScreenView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: myAppBar(
        titleText: "Settings",
      ),
      body: GetBuilder<SettingsController>(
        init: SettingsController(),
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Column(
              children: [
                Obx(() => _buildSettingsOption(
                      context,
                      iconValue: "12,345",
                      title: 'Number Format',
                      trailingText: controller.numberFormat.value,
                      onTap: () async {
                        var result = await navigateTo(
                            () => const SelectNumberValueScreen());
                        if (result != null) {
                          controller.updateNumberFormat(result);
                        }
                      },
                    )),
                Obx(() => _buildSettingsOption(
                      context,
                      iconValue: "123.45",
                      title: 'Decimal Places',
                      trailingText: controller.decimalPlaces.value,
                      onTap: () async {
                        var result = await navigateTo(
                            () => const SelectDecimalPlacesScreen());
                        if (result != null) {
                          controller.updateDecimalPlaces(result);
                        }
                      },
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: AppButton(
                      height: 50.h,
                      borderColor: AppColors.appColor.withOpacity(0.4),
                      bg: AppColors.white,
                      "Clear History",
                      style: notoSans.w500.get12.black, onPressed: () {
                    warning(
                      context,
                      content: "Are you sure, You want to clear your data?",
                      leadingTap: () {
                        Get.back();
                        showToast("Data Cleared Successfully");
                      },
                    );
                  }),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context,
      {required String iconValue,
      required String title,
      VoidCallback? onTap,
      required String trailingText}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Container(
          padding: EdgeInsets.all(6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: AppColors.appColor.withOpacity(0.4), width: 1.w),
          ),
          child: Row(
            children: [
              Container(
                height: 45.h,
                width: 50.w,
                decoration: BoxDecoration(
                  color: AppColors.azraQBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    iconValue,
                    style: notoSans.w500.get8.white,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: notoSans.fLYbyNight.w500.get12,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: Text(
                  trailingText,
                  style: notoSans.fLYbyNight.w500.get11,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: AppColors.orchid,
                size: 12.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
