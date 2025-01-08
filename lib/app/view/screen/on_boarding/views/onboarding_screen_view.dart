import 'package:advance_emi/app/model/config_model.dart';
import 'package:advance_emi/app/view/widgets/generated_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_typography.dart';
import '../controller/onboarding_controller.dart';

class OnBoardingScreenView extends StatelessWidget {
  const OnBoardingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: AppColors.trans,
      body: GetBuilder<OnBoardingController>(
        init: OnBoardingController(),
        builder: (controller) {
          return Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                pageSnapping: true,
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                itemCount: controller.filteredOnBoardingPages.length,
                onPageChanged: controller.setCurrentPageIndex,
                itemBuilder: (context, index) {
                  return buildPage(controller.filteredOnBoardingPages[index]);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w)
                    .copyWith(bottom: 30.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => SwipeDots(
                            pageCount:
                                controller.filteredOnBoardingPages.length,
                            currentIndex: controller.currentPageIndex.value,
                          ),
                        ),
                        Obx(
                          () => InkWell(
                            splashColor: AppColors.trans,
                            highlightColor: AppColors.trans,
                            onTap: () async => await controller.onPageChange(),
                            child: Container(
                              height: 40.h,
                              width: 40.h,
                              decoration: BoxDecoration(
                                color: AppColors.appColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0.5,
                                    blurRadius: 1,
                                    offset:
                                        const Offset(0, 2), // shadow position
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Icon(
                                  controller.currentPageIndex.value ==
                                          controller.filteredOnBoardingPages
                                                  .length -
                                              1
                                      ? Icons.check
                                      : Icons.arrow_forward_ios_outlined,
                                  color: Colors.white,
                                  size: 20.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPage(OnBoarding? page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w).copyWith(top: 30.h),
          child: Image.asset(
            page?.imageAsset ?? "",
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: Text(
            page?.title ?? "",
            textAlign: TextAlign.center,
            style: notoSans.w700.get21.black,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Text(
            page?.description ?? "",
            textAlign: TextAlign.center,
            style: notoSans.w400.get12.black,
          ),
        ),
        GoogleAdd.getInstance().showNative(isSmall: true),
      ],
    );
  }
}

class SwipeDots extends StatelessWidget {
  final int pageCount;
  final int currentIndex;

  const SwipeDots({
    super.key,
    required this.pageCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return Container(
          width: currentIndex == index ? 28.w : 4.w,
          height: 4.h,
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color:
                currentIndex == index ? AppColors.appColor : AppColors.ECECFF,
          ),
        );
      }),
    );
  }
}
