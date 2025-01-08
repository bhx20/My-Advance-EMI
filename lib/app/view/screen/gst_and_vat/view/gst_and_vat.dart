import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_typography.dart';
import '../../../../utils/utils.dart';
import '../controller/gst_vat_controller.dart';

class GSTAndVatScreen extends StatefulWidget {
  const GSTAndVatScreen({super.key});

  @override
  State<GSTAndVatScreen> createState() => _GSTAndVatScreenState();
}

class _GSTAndVatScreenState extends State<GSTAndVatScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, top: 15.h, bottom: 5.h),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "GST & VAT Calculation",
                style: notoSans.w500.get12.blackPANTHER,
              )),
        ),
        GetBuilder(
            init: GSTAndVatController(),
            builder: (controller) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5.h,
                      crossAxisSpacing: 5.w,
                      childAspectRatio: 16 / 5),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.calculatorList.length,
                  itemBuilder: (context, index) {
                    return _guideItem(index, controller);
                  });
            }),
      ],
    );
  }

  Widget _guideItem(int index, GSTAndVatController controller) {
    return InkWell(
      onTap: () {
        showAdAndNavigate(
            () => navigateTo(controller.calculatorList[index].route));
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
                    controller.calculatorList[index].icon,
                    height: 36.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      controller.calculatorList[index].title,
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
