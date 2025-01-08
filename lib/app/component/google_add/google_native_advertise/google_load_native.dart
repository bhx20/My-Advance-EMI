import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ad_counter.dart';
import '../InitialController.dart';

class NativeObject {
  final NativeAd? nativeAd;
  final RxBool? failedNative;
  NativeObject({this.nativeAd, this.failedNative});
}

//==============================================================================
//   ** Large Native ***
//==============================================================================

class LoadLargeNative {
  static final LoadLargeNative instance = LoadLargeNative._internal();

  factory LoadLargeNative() {
    return instance;
  }

  LoadLargeNative._internal();

  List<NativeAd> nativeObjectLarge = [];
  int reloadAd = 1;
  var c = Get.find<InitialController>().dbData.value;
  bool loading = false;

  Future<void> loadAd() async {
    String adUnitId = c.nativeId ?? "ca-app-pub-3940256099942544/2247696110";
    NativeAd? nativeAd;

    if (nativeObjectLarge.length <= 2) {
      try {
        loading = true;
        nativeAd = NativeAd(
          factoryId: "listTileMedium",
          adUnitId: adUnitId,
          listener: NativeAdListener(
            onAdLoaded: (ad) async {
              debugPrint('$NativeAd loaded.');
              if (nativeAd != null) {
                nativeObjectLarge.add(nativeAd);
              }
              if (nativeObjectLarge.length < 2) {
                loadAd();
              }
              nativeLoadM.value++;
              loading = false;
            },
            onAdImpression: (add) {
              nativeImpM.value++;
            },
            onAdFailedToLoad: (ad, error) {
              loading = false;
              nativeFailedM.value++;
              ad.dispose();
              if (reloadAd == 1) {
                reloadAd--;
                loadAd();
                print("failed ad large");
                print(error);
              } else {
                reloadAd = 1;
              }
            },
          ),
          request: const AdRequest(),
        );
        await nativeAd.load();
      } catch (error) {
        print("catch error");
        print(error);
      }
    }
  }
}

//==============================================================================
//   ** Small Native ***
//==============================================================================

class LoadSmallNative {
  static final LoadSmallNative instance = LoadSmallNative._internal();

  factory LoadSmallNative() {
    return instance;
  }

  LoadSmallNative._internal();

  List<NativeAd> nativeObjectSmall = [];
  var c = Get.find<InitialController>().dbData.value;
  int reloadAd = 1;
  bool loading = false;

  Future<void> loadAd() async {
    String adUnitId = c.nativeId ?? "ca-app-pub-3940256099942544/2247696110";
    NativeAd? nativeAd;
    if (nativeObjectSmall.length <= 2) {
      loading = true;
      try {
        nativeAd = NativeAd(
          factoryId: "listTile",
          adUnitId: adUnitId,
          listener: NativeAdListener(
            onAdLoaded: (ad) async {
              if (nativeAd != null) {
                nativeObjectSmall.add(nativeAd);
              }
              if (nativeObjectSmall.length < 2) {
                await loadAd();
              }
              nativeLoadS.value++;
              loading = false;
            },
            onAdImpression: (ad) {
              nativeImpS.value++;
            },
            onAdFailedToLoad: (ad, error) {
              loading = false;
              nativeFailedS.value++;
              ad.dispose();
              if (reloadAd == 1) {
                reloadAd--;
                loadAd();
              } else {
                reloadAd = 1;
              }
            },
          ),
          request: const AdRequest(),
        );

        await nativeAd.load();
      } catch (error) {
        print("catch error");
        print(error);
      }
    }
  }
}
