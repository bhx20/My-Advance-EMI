import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/app_colors.dart';
import '../controller/other_servie_controller.dart';

class OtherServiceView extends StatefulWidget {
  const OtherServiceView({super.key});

  @override
  State<OtherServiceView> createState() => _OtherServiceViewState();
}

class _OtherServiceViewState extends State<OtherServiceView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder(
            init: OtherServiceController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.w, top: 15.h, bottom: 5.h),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Other Services",
                          style: notoSans.w500.get12.blackPANTHER,
                        )),
                  ),
                  GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 5.h,
                          crossAxisSpacing: 5.w,
                          childAspectRatio: 1 / 0.15),
                      padding: EdgeInsets.only(bottom: 10.h),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.otherServiceList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            showAdAndNavigate(() {
                              navigateTo(
                                  controller.otherServiceList[index].route);
                            });
                          },
                          child: Container(
                            height: 50.h,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.white,
                                border: Border.all(
                                    color: AppColors.border, width: 0.8)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        controller.otherServiceList[index].icon,
                                        height: 36.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.w),
                                        child: Text(
                                          controller
                                              .otherServiceList[index].title,
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
                      }),
                ],
              );
            }),
      ],
    );
  }
}
