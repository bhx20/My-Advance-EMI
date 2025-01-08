import 'package:advance_emi/app/core/app_colors.dart';
import 'package:advance_emi/app/core/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../component/app_bar/my_app_bar.dart';
import '../../../utils/utils.dart';
import '../../widgets/generated_scaffold.dart';
import '../select_decimal_places/select_decimal_places.dart';
import '../settings/controller/setting_controller.dart';

class SelectNumberValueScreen extends StatefulWidget {
  const SelectNumberValueScreen({super.key});

  @override
  State<SelectNumberValueScreen> createState() =>
      _SelectNumberValueScreenState();
}

class _SelectNumberValueScreenState extends State<SelectNumberValueScreen> {
  int _selectedFormat = 0;

  List<String> formats = [
    "Automatic",
    "12,34,567.89",
    "1234 567,89",
    "1'234'567.89",
    "1.234.567,89",
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: myAppBar(
        titleText: 'Select Number Format',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: IconButton(
              icon: Icon(
                Icons.check,
                color: AppColors.white,
                size: 25.h,
              ),
              onPressed: () {
                var selectedFormat = formats[_selectedFormat];
                if (selectedFormat !=
                    Get.find<SettingsController>().numberFormat.value) {
                  Get.back(result: selectedFormat);
                } else {
                  navigateTo(const SelectDecimalPlacesScreen());
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5.h),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: formats.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0.w, vertical: 5.0.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: _selectedFormat == index
                              ? AppColors.appColor
                              : AppColors.appColor.withOpacity(0.2),
                          width: _selectedFormat == index ? 2.0 : 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 9.0.w),
                        title: Text(
                          formats[index],
                          style: notoSans.w600.get13,
                        ),
                        trailing: Image.asset(
                          _selectedFormat == index
                              ? 'assets/icons/selected_icon.png'
                              : 'assets/icons/unselected_image.png',
                          width: 21.w,
                          height: 21.h,
                        ),
                        onTap: () {
                          setState(() {
                            _selectedFormat = index;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
