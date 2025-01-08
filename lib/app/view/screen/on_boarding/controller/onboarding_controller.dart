import 'package:advance_emi/app/component/google_add/InitialController.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:advance_emi/app/view/screen/dashBoard/view/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/config_model.dart';
import '../../../../utils/local_store/preference.dart';

class OnBoardingController extends GetxController {
  PageController pageController = PageController();
  RxInt currentPageIndex = 0.obs;

  List<OnBoarding> filteredOnBoardingPages = [];
  final List<OnBoarding> onBoardingPages = [];

  @override
  void onInit() {
    super.onInit();
    fetchOnBoardingData();
  }

  void fetchOnBoardingData() {
    List<OnBoarding>? allOnBoardingPages =
        Get.find<InitialController>().dbData.value.onBoarding;
    filteredOnBoardingPages =
        allOnBoardingPages!.where((page) => page.show).toList();
    update();
  }

  void setCurrentPageIndex(int index) {
    currentPageIndex.value = index;
  }

  Future<void> onPageChange() async {
    await showAdAndNavigate(() async {
      if (currentPageIndex.value < filteredOnBoardingPages.length - 1) {
        await PreferenceHelper.instance.setData(Pref.firstLaunch, false);
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        removeAllAndNavigate(() => const DashBoardView());
      }
    });
  }
}
