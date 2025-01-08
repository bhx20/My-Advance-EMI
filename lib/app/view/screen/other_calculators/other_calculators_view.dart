import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_typography.dart';
import '../../../utils/utils.dart';
import 'controller/other_calculator_controller.dart';

class OtherCalculatorsView extends StatefulWidget {
  const OtherCalculatorsView({super.key});

  @override
  State<OtherCalculatorsView> createState() => _OtherCalculatorsViewState();
}

class _OtherCalculatorsViewState extends State<OtherCalculatorsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, top: 15.h, bottom: 5.h),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Other Calculators",
                style: notoSans.w500.get12.blackPANTHER,
              )),
        ),
        GetBuilder(
            init: OtherCalculator(),
            builder: (controller) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5.h,
                      crossAxisSpacing: 5.w,
                      childAspectRatio: 16 / 5),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.otherCalculatorList.length,
                  itemBuilder: (context, index) {
                    return _guideItem(index, controller);
                  });
            }),
      ],
    );
  }

  Widget _guideItem(int index, OtherCalculator controller) {
    return InkWell(
      onTap: () {
        showAdAndNavigate(
            () => navigateTo(controller.otherCalculatorList[index].route));
      },
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.white,
            border: Border.all(color: AppColors.border, width: 0.8)),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    controller.otherCalculatorList[index].icon,
                    height: 36.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      controller.otherCalculatorList[index].title,
                      style: notoSans.get9.w500,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: AppColors.orchid,
              size: 10.h,
            )
          ],
        ),
      ),
    );
  }
}
