import 'package:advance_emi/app/view/screen/emiCalculator/controller/advance_emi_controller.dart';
import 'package:advance_emi/app/view/screen/emiCalculator/controller/emi_calculator_controller.dart';
import 'package:advance_emi/app/view/screen/history/view/history_screen.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../component/google_add/InitialController.dart';
import '../../../../model/emi_result_model.dart';
import '../../../../model/local.dart';
import '../../../../utils/utils.dart';
import '../view/document_required.dart';

class AppDrawerController extends GetxController {
  List<DrawerItem> drawerItem = [
    DrawerItem(title: "Home", icon: "assets/icons/home.png", onTap: () {}),
    DrawerItem(
        title: "History", icon: "assets/icons/history.png", onTap: () {}),
    DrawerItem(
        title: "Settings", icon: "assets/icons/settings.png", onTap: () {}),
  ];

  List<DrawerItem> drawerMoreItem = [
    DrawerItem(
        title: "Tell a Friend",
        icon: "assets/icons/tell_a_friend.png",
        onTap: () {
          String? share =
              Get.find<InitialController>().dbData.value.shareLink ?? "";
          Share.share(share);
        }),
    DrawerItem(
        title: "History",
        icon: "assets/icons/history.png",
        onTap: () async {
          var advanceEMIController = Get.find<AdvanceEMIController>();
          var emiCalculatorController = Get.find<EmiCalculatorController>();

          List<CalculateResult> advanceData =
              advanceEMIController.advanceCalculate;
          List<CalculateResult> emiData =
              emiCalculatorController.historyCalculate;

          Set<CalculateResult> uniqueDataSet = {};
          uniqueDataSet.addAll(advanceData);
          uniqueDataSet.addAll(emiData);
          List<CalculateResult> uniqueDataList = uniqueDataSet.toList();

          navigateTo(HistoryScreenView(calculateData: uniqueDataList));
        }),
    DrawerItem(
        title: "Documents Required",
        icon: "assets/icons/document.png",
        onTap: () {
          navigateTo(const DocumentRequiredView());
        }),
    DrawerItem(
        title: "Rate This App",
        icon: "assets/icons/rate_this_app.png",
        onTap: () async {
          final Uri url = Uri.parse(
              Get.find<InitialController>().dbData.value.shareLink ?? "");
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
        }),
    DrawerItem(
        title: "Privacy",
        icon: "assets/icons/privacy.png",
        onTap: () async {
          String? privacy = Get.find<InitialController>().dbData.value.privacy;
          if (privacy != null) {
            final Uri url = Uri.parse(privacy);
            if (!await launchUrl(url)) {
              throw Exception('Could not launch $url');
            }
          }
        }),
    DrawerItem(
        title: "Help",
        icon: "assets/icons/help.png",
        onTap: () async {
          String? help = Get.find<InitialController>().dbData.value.help;
          String text = "Please provide your problem here...";

          String mailtoUrl =
              'mailto:$help?subject=EMI Calculator Help&body=$text';

          if (!await launchUrl(Uri.parse(mailtoUrl))) {
            throw 'Could not launch $mailtoUrl';
          }
        }),
    DrawerItem(title: "Exit", icon: "assets/icons/exit.png", onTap: () {}),
  ];
}
