import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_typography.dart';
import '../controller/bank_calculator_controller.dart';

class BankCalculationScreen extends StatefulWidget {
  const BankCalculationScreen({super.key});

  @override
  State<BankCalculationScreen> createState() => _BankCalculationScreenState();
}

class _BankCalculationScreenState extends State<BankCalculationScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, top: 15.h, bottom: 5.h),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Bank Calculation",
                style: notoSans.w500.get12.blackPANTHER,
              )),
        ),
        GetBuilder(
            init: BankCalculatorController(),
            builder: (controller) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5.h,
                      crossAxisSpacing: 5.w,
                      childAspectRatio: 16 / 5),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.bankCalculatorList.length,
                  itemBuilder: (context, index) {
                    return _bankCalculationItem(index, controller);
                  });
            }),
      ],
    );
  }

  Widget _bankCalculationItem(int index, BankCalculatorController controller) {
    return InkWell(
      onTap: () {
        showAdAndNavigate(
            () => navigateTo(controller.bankCalculatorList[index].route));
      },
      child: Container(
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
                    controller.bankCalculatorList[index].icon,
                    height: 36.h,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Text(
                          controller.bankCalculatorList[index].title,
                          style: notoSans.get9.w500,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
