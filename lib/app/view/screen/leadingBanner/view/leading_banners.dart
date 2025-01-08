import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../component/app_slider/leading_slider.dart';
import '../../../../component/network_image/network_image.dart';
import '../controller/leading_banner_controller.dart';

class LeadingSliderView extends StatelessWidget {
  const LeadingSliderView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: GetBuilder(
            init: LeadingController(),
            builder: (controller) => Obx(() {
                  return CarouselSliderWidget(
                    itemCount: controller.filteredLeadingPages.length,
                    itemBuilder: (
                      BuildContext context,
                      int itemIndex,
                      int pageViewIndex,
                    ) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                            onTap: () {
                              showAdAndNavigate(() => navigateTo(
                                  controller.getScreen(controller
                                          .filteredLeadingPages[itemIndex].id ??
                                      "emi")));
                            },
                            child: NetWorkImage(
                              controller
                                      .filteredLeadingPages[itemIndex].image ??
                                  "",
                              width: Get.width,
                            )),
                      );
                    },
                    onPageChanged: (index, reason) {
                      controller.currentPageIndex.value = index;
                    },
                    carouselHeight: 110.h,
                    enableInfiniteScroll: true,
                    viewportFraction: 0.6,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    enlargeFactor: 0.22,
                    currentIndex: controller.currentPageIndex.value,
                  );
                })));
  }
}
