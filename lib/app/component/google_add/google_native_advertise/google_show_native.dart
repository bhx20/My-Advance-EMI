import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/app_colors.dart';
import '../InitialController.dart';
import 'google_load_native.dart';

var nativeCounter = 0.obs;

class ShowNative extends StatelessWidget {
  final bool isSmall;
  const ShowNative({super.key, required this.isSmall});

  @override
  Widget build(BuildContext context) {
    var c = Get.find<InitialController>().dbData.value;

    if (nativeCounter.value >= c.nativeCounter) {
      nativeCounter(0);
      if (c.showNative == true && c.showAd == true) {
        return isSmall ? const GoogleNativeSmall() : const GoogleNativeLarge();
      } else {
        return const SizedBox.shrink();
      }
    } else {
      nativeCounter.value++;
      return const SizedBox.shrink();
    }
  }
}

//==============================================================================
//   ** Large Native ***
//==============================================================================

class GoogleNativeLarge extends StatefulWidget {
  const GoogleNativeLarge({
    super.key,
  });

  @override
  State<GoogleNativeLarge> createState() => _GoogleNativeLargeState();
}

class _GoogleNativeLargeState extends State<GoogleNativeLarge> {
  late NativeAd native;

  @override
  void initState() {
    if (LoadLargeNative.instance.nativeObjectLarge.isNotEmpty &&
        LoadLargeNative.instance.loading == false) {
      native = LoadLargeNative.instance.nativeObjectLarge.removeAt(0);
      LoadLargeNative.instance.loadAd();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.white,
            border: Border.all(color: AppColors.border, width: 0.8)),
        margin: EdgeInsets.all(5.h),
        padding: EdgeInsets.zero,
        child: LoadLargeNative.instance.nativeObjectLarge.isNotEmpty
            ? adView()
            : const SizedBox());
  }

  Widget adView() {
    try {
      return SizedBox(
        height: 290,
        child: AdWidget(ad: native),
      );
    } catch (e) {
      return const SizedBox();
    }
  }
}

//==============================================================================
//   ** Small Native ***
//==============================================================================

class GoogleNativeSmall extends StatefulWidget {
  const GoogleNativeSmall({super.key});

  @override
  State<GoogleNativeSmall> createState() => _GoogleNativeSmallState();
}

class _GoogleNativeSmallState extends State<GoogleNativeSmall> {
  late NativeAd native;

  @override
  void initState() {
    if (LoadSmallNative.instance.nativeObjectSmall.isNotEmpty &&
        LoadSmallNative.instance.loading == false) {
      native = LoadSmallNative.instance.nativeObjectSmall.removeAt(0);
      LoadSmallNative.instance.loadAd();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.white,
            border: Border.all(color: AppColors.border, width: 0.8)),
        margin: EdgeInsets.all(5.h),
        padding: EdgeInsets.zero,
        child: LoadSmallNative.instance.nativeObjectSmall.isNotEmpty
            ? adView()
            : const SizedBox());
  }

  Widget adView() {
    try {
      return SizedBox(
        height: 160,
        child: AdWidget(ad: native),
      );
    } catch (e) {
      return const SizedBox();
    }
  }
}
