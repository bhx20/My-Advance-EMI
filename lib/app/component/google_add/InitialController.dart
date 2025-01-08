import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../firebase_options.dart';
import '../../model/config_model.dart';
import '../../utils/analytic_service_class/fb_event.dart';
import '../../utils/local_store/preference.dart';
import '../../utils/notification_service/firebase_notification.dart';
import '../../utils/utils.dart';
import '../../view/screen/emiCalculator/controller/advance_emi_controller.dart';
import '../../view/screen/emiCalculator/controller/emi_calculator_controller.dart';
import 'google_advertise_repo/advertise_repo.dart';
import 'google_appopen_advertise/app_open_ad_manager.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InitialController());
    Get.put(AdvanceEMIController());
    Get.put(EmiCalculatorController());
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {}

class InitialController extends GetxController {
  Rx<ConfigData> dbData = ConfigData().obs;
  var navigated = false.obs;
  var addID = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseNotification.instance.initializeApp();
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    await PreferenceHelper.instance.createSharedPref();
    MobileAds.instance.initialize();
    setOrientations();
    listenToFirebaseChanges();
  }

  Future<void> listenToFirebaseChanges() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("app_config");

    ref.onValue.listen((event) async {
      DataSnapshot snapshot = event.snapshot;
      Object? data = snapshot.value;

      dbData.value = configDataFromJson(jsonEncode(data));
      initializeFacebookSdk();
      if (dbData.value.showAd == true) {
        if (navigated.isFalse) {
          AppOpenOnStart().loadAd();
        }
        if (dbData.value.showNative == true && dbData.value.showAd == true) {
          GoogleAdd.getInstance().loadLargeNative();
          GoogleAdd.getInstance().loadSmallNative();
        }

        GoogleAdd.getInstance().googleOpenAppAdd();
        GoogleAdd.getInstance().loadGoogleInterstitialAdd();
      } else {
        if (navigated.isFalse) {
          await Future.delayed(const Duration(seconds: 2));
          await reDirect();
        }
      }
    });
  }

  void initializeFacebookSdk() async {
    final String result = await FacebookEvents.initialize(
        dbData.value.fbAppId ?? "", dbData.value.fbToken ?? "");
    if (result == 'success') {
      print('Facebook SDK initialized successfully');
    } else {
      print('Facebook SDK Initialization failed');
    }
  }
}
