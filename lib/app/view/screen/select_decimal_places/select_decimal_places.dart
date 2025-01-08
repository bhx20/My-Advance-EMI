import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../component/app_bar/my_app_bar.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_typography.dart';
import '../../../utils/utils.dart';
import '../../widgets/generated_scaffold.dart';
import '../dashBoard/view/dashboard_screen.dart';
import '../settings/controller/setting_controller.dart';

class SelectDecimalPlacesScreen extends StatefulWidget {
  const SelectDecimalPlacesScreen({super.key});

  @override
  State<SelectDecimalPlacesScreen> createState() =>
      _SelectDecimalPlacesScreenState();
}

class _SelectDecimalPlacesScreenState extends State<SelectDecimalPlacesScreen> {
  int selectedDecimal = 0;

  List<String> decimal = [
    "123",
    "123.4",
    "123.45",
    "123.456",
    "123.4567",
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: myAppBar(
        titleText: 'Select Decimal Places',
        leadingWidth: 0,
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
                var selectedPlaces = decimal[selectedDecimal];
                if (selectedPlaces !=
                    Get.find<SettingsController>().decimalPlaces.value) {
                  Get.back(result: selectedPlaces);
                } else {
                  navigateTo(const DashBoardView());
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
                itemCount: decimal.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0.w, vertical: 5.0.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: selectedDecimal == index
                              ? AppColors.appColor
                              : AppColors.appColor.withOpacity(0.2),
                          width: selectedDecimal == index ? 2.0 : 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 9.0.w),
                        title: Text(
                          decimal[index],
                          style: notoSans.w600.get13,
                        ),
                        trailing: Image.asset(
                          selectedDecimal == index
                              ? 'assets/icons/selected_icon.png' // Path to your selected image
                              : 'assets/icons/unselected_image.png', // Path to your unselected image
                          width: 21.w,
                          height: 21.h,
                        ),
                        onTap: () {
                          setState(() {
                            selectedDecimal = index;
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
