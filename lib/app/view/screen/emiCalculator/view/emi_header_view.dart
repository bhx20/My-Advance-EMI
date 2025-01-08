import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/app_colors.dart';
import '../controller/emi_calculator_controller.dart';

class EmiCalculatorView extends StatefulWidget {
  const EmiCalculatorView({super.key});

  @override
  State<EmiCalculatorView> createState() => _EmiCalculatorViewState();
}

class _EmiCalculatorViewState extends State<EmiCalculatorView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: EmiCalculatorController(),
        builder: (controller) {
          return Column(
            children: [
              GridView.builder(
                  padding: EdgeInsets.only(top: 8.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5.h,
                      crossAxisSpacing: 5.w,
                      childAspectRatio: 1 / 0.3),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.emiCalculatorList.length,
                  itemBuilder: (context, index) {
                    return _guideItem(index, controller);
                  }),
            ],
          );
        });
  }

  Widget _guideItem(int index, EmiCalculatorController controller) {
    return InkWell(
      onTap: () {
        showAdAndNavigate(
            () => navigateTo(controller.emiCalculatorList[index].route));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.white,
            border: Border.all(color: AppColors.border, width: 0.8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              controller.emiCalculatorList[index].icon,
              height: 36.h,
            ),
            Expanded(
              child: Text(
                controller.emiCalculatorList[index].title,
                textAlign: TextAlign.center,
                style: notoSans.get9.w500.blackPANTHER,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: AppColors.orchid,
              size: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
