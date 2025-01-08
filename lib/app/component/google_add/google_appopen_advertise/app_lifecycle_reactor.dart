import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../InitialController.dart';
import 'app_open_ad_manager.dart';

class GoogleOpenAppAdvertise {
  static final GoogleOpenAppAdvertise instance =
      GoogleOpenAppAdvertise._internal();

  factory GoogleOpenAppAdvertise() {
    return instance;
  }

  GoogleOpenAppAdvertise._internal();

  late AppOpenAdManager appOpenAdManager;
  late AppLifecycleReactor _appLifecycleReactor;

  Future<void> getOpenAppAdvertise() async {
    appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }
}

class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;
  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    print('New AppState state: $appState');
    if (Get.find<InitialController>().dbData.value.showOpenApp == true &&
        Get.find<InitialController>().dbData.value.showAd == true) {
      if (appState == AppState.foreground) {
        appOpenAdManager.showAdIfAvailable();
      }
    }
  }
}
