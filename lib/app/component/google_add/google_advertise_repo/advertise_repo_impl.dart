import 'package:flutter/material.dart';

import '../google_appopen_advertise/app_lifecycle_reactor.dart';
import '../google_interstitial_advertise/google_interstitial_advertise.dart';
import '../google_native_advertise/google_load_native.dart';
import '../google_native_advertise/google_show_native.dart';
import 'advertise_repo.dart';

class GoogleAddRepoImpl extends GoogleAddRepo {
  @override
  Future<void> loadLargeNative() {
    return LoadLargeNative.instance.loadAd();
  }

  @override
  Future<void> loadSmallNative() {
    return LoadSmallNative.instance.loadAd();
  }

  @override
  Future<void> googleOpenAppAdd() {
    return GoogleOpenAppAdvertise.instance.getOpenAppAdvertise();
  }

  @override
  void loadGoogleInterstitialAdd() {
    return GoogleInterstitialAdvertise.instance.load();
  }

  @override
  void showGoogleInterstitialAdd({Function()? callBack}) {
    return GoogleInterstitialAdvertise.instance
        .showAndNavigate(callBack: callBack ?? () {});
  }

  @override
  Widget showNative({bool isSmall = false}) {
    return ShowNative(isSmall: isSmall);
  }
}
