import 'dart:io';

import 'package:advance_emi/app/utils/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../component/app_button/app_button.dart';
import '../../../component/google_add/InitialController.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_typography.dart';

void showExitConfirmationDialog(BuildContext context) {
  showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return const Dialog(
        child: FeedBackWidget(),
      );
    },
  );
}

class FeedBackWidget extends StatefulWidget {
  const FeedBackWidget({
    super.key,
  });

  @override
  State<FeedBackWidget> createState() => _FeedBackWidgetState();
}

class _FeedBackWidgetState extends State<FeedBackWidget> {
  RxDouble ratingValue = 0.0.obs;
  Future<String> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return 'Device ${androidInfo.model}\n'
          'Android Version ${androidInfo.version.release}\n'
          'SDK ${androidInfo.version.sdkInt}\n'
          'Manufacturer ${androidInfo.manufacturer}\n';
    }
    return 'Unknown device';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: AppColors.white),
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40.h, bottom: 10.h),
                  child: Text(
                    'Please take a moment to share your experience with our app, it will be really helpful for our Team.',
                    style: notoSans.w400.black.get11,
                    textAlign: TextAlign.center,
                  ),
                ),
                RatingBar.builder(
                  initialRating: ratingValue.value,
                  minRating: 0,
                  direction: Axis.horizontal,
                  itemSize: 35,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemBuilder: (context, index) => Obx(() {
                    return Icon(
                      index < ratingValue.value
                          ? Icons.star
                          : Icons.star_border,
                      color: AppColors.appColor,
                    );
                  }),
                  onRatingUpdate: (rating) {
                    ratingValue.value = rating;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: AppButton(
                          style: notoSans.w500.get11.white,
                          "Share App",
                          height: 30.h,
                          bg: AppColors.appColor,
                          onPressed: () {
                            Get.back();
                            showAdAndNavigate(() {
                              Share.share(
                                  'Check out this amazing EMI Calculator app: ${Get.find<InitialController>().dbData.value.shareLink ?? ""}');
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Obx(() => AppButton(
                              style: notoSans.w500.get11.white,
                              ratingValue.value == 0.0
                                  ? "Rate Now!"
                                  : (ratingValue.value > 3
                                      ? "Rate Now!"
                                      : "Feedback"),
                              height: 30.h,
                              bg: AppColors.appColor,
                              onPressed: () async {
                                Get.back();
                                await showAdAndNavigate(() async {
                                  if (ratingValue.value > 3 ||
                                      ratingValue.value == 0.0) {
                                    final Uri url = Uri.parse(
                                        Get.find<InitialController>()
                                                .dbData
                                                .value
                                                .shareLink ??
                                            "");
                                    urlLauncher(url);
                                  } else {
                                    String? help = Get.find<InitialController>()
                                        .dbData
                                        .value
                                        .help;
                                    String deviceInfo = await getDeviceInfo();
                                    String text =
                                        "Please provide your feedback here...";

                                    String mailtoUrl =
                                        'mailto:$help?subject=EMI Calculator Feedback&body=$text\n\n$deviceInfo';

                                    if (!await launchUrl(
                                        Uri.parse(mailtoUrl))) {
                                      throw 'Could not launch $mailtoUrl';
                                    }
                                  }
                                });
                              },
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: GestureDetector(
                    onTap: () {
                      showAdAndNavigate(() {
                        exit(0);
                      });
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "No,Thanks",
                        textAlign: TextAlign.center,
                        style: notoSans.w400.get11.gray
                            .copyWith(
                              decoration: TextDecoration.underline,
                            )
                            .copyWith(decorationColor: AppColors.gray),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: -35,
          child: Image.asset(
            "assets/icons/rating.png",
            height: 70.h,
          ),
        ),
      ],
    );
  }

  Future<void> urlLauncher(Uri url) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }
}
