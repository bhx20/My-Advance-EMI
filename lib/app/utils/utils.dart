import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../component/google_add/InitialController.dart';
import '../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../view/screen/dashBoard/view/dashboard_screen.dart';
import '../view/screen/on_boarding/views/onboarding_screen_view.dart';
import 'analytic_service_class/analytics_service.dart';
import 'local_store/preference.dart';

setOrientations() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

reDirect() async {
  bool? firstLaunch;
  firstLaunch = await PreferenceHelper.instance.getData(Pref.firstLaunch);
  if (firstLaunch == true || firstLaunch == null) {
    Get.find<InitialController>().navigated(true);
    removeAllAndNavigate(const OnBoardingScreenView());
  } else {
    Get.find<InitialController>().navigated(true);
    removeAllAndNavigate(const DashBoardView());
  }
}

showAdAndNavigate(Function()? callBack) {
  GoogleAdd.getInstance().showGoogleInterstitialAdd(callBack: callBack);
}

navigateTo(dynamic page) {
  AnalyticsService.instance.sendAnalyticsEvent(
      eventName: "navigate_to_${page.toString().toLowerCase()}");
  Get.to(page);
}

removeAndNavigate(dynamic page) {
  AnalyticsService.instance.sendAnalyticsEvent(
      eventName: "navigate_to_${page.toString().toLowerCase()}");
  Get.off(page);
}

removeAllAndNavigate(dynamic page) {
  AnalyticsService.instance.sendAnalyticsEvent(
      eventName: "navigate_to_${page.toString().toLowerCase()}");
  Get.offAll(page);
}
