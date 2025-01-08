import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_button/app_button.dart';
import '../../../../../component/globle_widget.dart';
import '../../../../../component/google_add/InitialController.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../component/toast/app_toast.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../model/loan_profile_model.dart';
import '../../../../../utils/num_converter/num_converter.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/loan_profile_controller.dart';
import 'edit_profile.dart';
import 'emi_details_view.dart';

class LoanDetailsView extends StatefulWidget {
  final LoanProfileData? loanProfile;
  final int? index;
  const LoanDetailsView({super.key, this.loanProfile, this.index});

  @override
  State<LoanDetailsView> createState() => _LoanDetailsViewState();
}

class _LoanDetailsViewState extends State<LoanDetailsView> {
  final GlobalKey _boundaryKey = GlobalKey();
  final LoanProfileController controller = Get.find();

  LoanProfileData? loanProfile;

  @override
  void initState() {
    super.initState();
    loanProfile = widget.loanProfile;
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.index ?? 0;
    return AppScaffold(
        appBar: myAppBar(
          titleText: "Loan Details",
          isBack: true,
        ),
        bottomNavigationBar: GoogleAdd.getInstance().showNative(isSmall: true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                child: RepaintBoundary(
                  key: _boundaryKey,
                  child: Container(
                      color: Colors.white,
                      child: Obx(() {
                        int index = widget.index ?? 0;
                        var data =
                            controller.loanProfiles[index].dbData?.loanProfile;
                        return Column(
                          children: [
                            Table(
                              border: TableBorder.all(
                                color: AppColors.appColor,
                                width: 1,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              children: [
                                buildTableRow(
                                  "Loan Name",
                                  data?.loanName ?? "N/A",
                                  titleStyle: notoSans.w600.appColor.get13,
                                  valueStyle: notoSans.w600.appColor.get13,
                                ),
                                buildTableRow("Loan A/C No",
                                    data?.loanAccountNo ?? "N/A"),
                                buildTableRow(
                                    "Bank Name", data?.bankName ?? "N/A"),
                                buildTableRow(
                                    "Loan Amount", data?.loanAmount ?? "N/A"),
                                buildTableRow("Interest Rate %",
                                    data?.interestRate ?? "N/A"),
                                buildTableRow(
                                    "Tenure(In month)", data?.months ?? "N/A"),
                                buildTableRow("EMI", data?.emi ?? "N/A"),
                                buildTableRow("Processing Fees",
                                    data?.processingFees ?? "N/A"),
                                buildTableRow(
                                    "Loan Date",
                                    DateFormat('dd/MM/yyyy').format(
                                        data?.loanDate ?? DateTime.now())),
                                buildTableRow(
                                    "First EMI date",
                                    DateFormat('dd/MM/yyyy').format(
                                        data?.firstEmiDate ?? DateTime.now())),
                                buildTableRow(
                                    "Last EMI date",
                                    controller.loanProfiles[index].lastEmiDate
                                            .toString() ??
                                        "N/A"),
                                buildTableRow(
                                    "Interest Paid",
                                    formatNumber(convertToDouble(controller
                                            .loanProfiles[index].interestPaid ??
                                        "N/A"))),
                                buildTableRow(
                                    "Principal Paid",
                                    formatNumber(convertToDouble(controller
                                            .loanProfiles[index]
                                            .principalPaid ??
                                        "N/A"))),
                                if (controller.loanProfiles[index]
                                        .interestSaverAccount !=
                                    null)
                                  buildTableRow(
                                      "Interest Saver Balance",
                                      formatNumber(convertToDouble(controller
                                              .loanProfiles[index]
                                              .interestSaverAccount ??
                                          "N/A"))),
                                buildTableRow(
                                    "Total Paid",
                                    formatNumber(convertToDouble(controller
                                            .loanProfiles[index].totalPaid ??
                                        "N/A"))),
                                buildTableRow(
                                    "Outstanding Interest",
                                    formatNumber(convertToDouble(controller
                                            .loanProfiles[index]
                                            .outstandingInterest ??
                                        "N/A"))),
                                buildTableRow(
                                    "Outstanding Principal",
                                    formatNumber(convertToDouble(controller
                                            .loanProfiles[index]
                                            .outstandingPrincipal ??
                                        "N/A"))),
                                buildTableRow(
                                    "Outstanding Total",
                                    formatNumber(convertToDouble(controller
                                            .loanProfiles[index]
                                            .outstandingTotal ??
                                        "N/A"))),
                                buildTableRow(
                                    "Total Interest",
                                    formatNumber(convertToDouble(controller
                                            .loanProfiles[index]
                                            .totalInterest ??
                                        "N/A"))),
                              ],
                            ),
                          ],
                        );
                      })),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppButton(
                      width: 100.w,
                      "Schedule",
                      style: notoSans.w400.get12.white, onPressed: () {
                    showAdAndNavigate(() => navigateTo(EmiDetailsView(
                        emiResult: controller.loanProfiles[index])));
                  }),
                  AppButton("Edit",
                      width: 100.w,
                      style: notoSans.w400.get12.white, onPressed: () async {
                    await showAdAndNavigate(() async {
                      var result = await navigateTo(() => EditProfile(
                            editData: controller.loanProfiles[index],
                            index: widget.index,
                          ));

                      if (result != null && result is LoanProfileData) {
                        controller.updateLoanProfile(result, widget.index!);
                      }
                    });
                  }),
                  AppButton("Share",
                      width: 100.w,
                      style: notoSans.w400.get12.white, onPressed: () {
                    showAdAndNavigate(() {
                      _captureAndShareImage();
                    });
                  }),
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> _captureAndShareImage() async {
    try {
      RenderRepaintBoundary boundary = _boundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final filePath = p.join(directory.path, 'loan_details.png');
      final imageFile = File(filePath)..writeAsBytesSync(pngBytes);

      Share.shareXFiles([XFile(imageFile.path)],
          text:
              'Calculated by: \n ${Get.find<InitialController>().dbData.value.shareLink ?? ""}');
    } catch (e) {
      showToast("Error sharing loan details: $e");
    }
  }
}
