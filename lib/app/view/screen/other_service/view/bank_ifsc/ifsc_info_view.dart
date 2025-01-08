import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/google_add/InitialController.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../component/toast/app_toast.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../model/local.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/bank_ifsc_controller.dart';

class IfscInfoView extends StatefulWidget {
  final String bankName;
  final String state;
  final String city;
  final String branch;
  final String address;

  const IfscInfoView({
    super.key,
    required this.address,
    required this.bankName,
    required this.state,
    required this.city,
    required this.branch,
  });

  @override
  State<IfscInfoView> createState() => _IfscInfoViewState();
}

class _IfscInfoViewState extends State<IfscInfoView> {
  late BankInfo bankInfo;

  @override
  void initState() {
    super.initState();
    bankInfo = BankInfo.fromString(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    String shareText = "Bank Details- \n \nBank Name: ${widget.bankName}"
        "\nState: ${widget.state}\nCity: ${widget.city}\nBranch: ${widget.branch}"
        "\nIFSC: ${bankInfo.ifsc}\nMICR Code: ${bankInfo.micr}\nAddress: ${bankInfo.address}"
        "\nPhone No: ${bankInfo.mobileNumber}\nBranch Code: ${bankInfo.branchCode}"
        "\n\nCalculated by EMI Calculator:\n${Get.find<InitialController>().dbData.value.shareLink ?? ""}";
    return GetBuilder(
        init: BankIFSCController(),
        builder: (controller) {
          return AppScaffold(
            appBar: myAppBar(
              titleText: "Bank IFSC Details",
            ),
            bottomNavigationBar:
                GoogleAdd.getInstance().showNative(isSmall: true),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.h, left: 10.h, right: 10.h),
                  padding: EdgeInsets.all(10.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detailsView(title: "Bank Name", data: widget.bankName),
                      _detailsView(title: "IFSC Code", data: bankInfo.ifsc),
                      _detailsView(title: "MICR Code", data: bankInfo.micr),
                      _detailsView(title: "Address", data: bankInfo.address),
                      _detailsView(
                          title: "Phone No", data: bankInfo.mobileNumber),
                      _detailsView(
                          title: "Branch Code", data: bankInfo.branchCode),
                      Padding(
                        padding: EdgeInsets.only(top: 15.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: InkWell(
                                onTap: () async {
                                  await showAdAndNavigate(() async {
                                    await Clipboard.setData(ClipboardData(
                                      text: bankInfo.ifsc,
                                    ));
                                    showToast("Copied");
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.h),
                                  decoration: BoxDecoration(
                                      color: AppColors.appColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                      child: Text(
                                    "Copy IFSC Code",
                                    style: notoSans.get14.white,
                                  )),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                            padding: EdgeInsets.all(10.h),
                                            child: IconButton(
                                                onPressed: () async {
                                                  await showAdAndNavigate(
                                                      () async {
                                                    await Clipboard.setData(
                                                        ClipboardData(
                                                      text: shareText,
                                                    ));
                                                    showToast("Copied");
                                                  });
                                                },
                                                icon: const Icon(Icons.copy))),
                                      ),
                                      Expanded(
                                        child: Padding(
                                            padding: EdgeInsets.all(10.h),
                                            child: IconButton(
                                                onPressed: () {
                                                  showAdAndNavigate(() {
                                                    Share.share(shareText);
                                                  });
                                                },
                                                icon: const Icon(Icons.share))),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _detailsView({required String title, required String data}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: notoSans.gray.w400.get12,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              data,
              style: notoSans.black.w400.get12,
            ),
          ),
        ],
      ),
    );
  }
}
