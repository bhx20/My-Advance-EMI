import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../InitialController.dart';
import '../ad_counter.dart';

class GoogleInterstitialAdvertise {
  static final GoogleInterstitialAdvertise instance =
      GoogleInterstitialAdvertise._internal();

  factory GoogleInterstitialAdvertise() {
    return instance;
  }

  GoogleInterstitialAdvertise._internal();

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;
  var counter = 0.obs;
  var webViewCounter = 0.obs;
  var data = Get.find<InitialController>().dbData.value;
  String adUnitId = 'ca-app-pub-3940256099942544/1033173712';

  void load() {
    adUnitId = data.interstitialId ?? "ca-app-pub-3940256099942544/1033173712";
    try {
      _isInterstitialAdLoaded = false;
      InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            interLoad.value++;
            print("inter loaded");
            _interstitialAd = ad;
            _interstitialAd!.setImmersiveMode(true);
            _isInterstitialAdLoaded = true;
          },
          onAdFailedToLoad: (LoadAdError error) {
            interFailed.value++;
            _interstitialAd = null;
            _isInterstitialAdLoaded = false;
          },
        ),
      );
    } catch (error) {
      _interstitialAd?.dispose();
    }
  }

  void showAndNavigate({required void Function() callBack}) {
    if (data.showInterstitial == true && data.showAd == true) {
      if (_isInterstitialAdLoaded &&
          _interstitialAd != null &&
          counter.value == 0) {
        _interstitialAd!.show().then((value) {
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              callBack();
              ad.dispose();
              _interstitialAd = null;
              load();

              counter.value = 1;
            },
            onAdImpression: (value) {
              interImp.value++;
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) async {
              log('$ad onAdFailedToShowFullScreenContent: $error');
              _interstitialAd = null;
              ad.dispose();
              load();
            },
          );
        });
      } else {
        if (counter.value >= data.interstitialCounter) {
          counter.value = 0;
        } else {
          counter.value++;
        }
        callBack();
      }
    } else {
      callBack();
    }
  }
}
