import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_button/app_button.dart';
import '../../../../../component/app_textformfield/common_field.dart';
import '../../../../../component/globle_widget.dart';
import '../../../../../component/google_add/InitialController.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../component/toast/app_toast.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../core/app_typography.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/gst_controller.dart';

class GSTCalculatorView extends StatelessWidget {
  const GSTCalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GSTController>(
        init: GSTController(),
        builder: (controller) {
          return AppScaffold(
              appBar: myAppBar(titleText: "GST Calculator"),
              bottomNavigationBar:
                  GoogleAdd.getInstance().showNative(isSmall: true),
              body: RepaintBoundary(
                key: controller.boundaryKey,
                child: Container(
                  color: AppColors.white,
                  child: Form(
                    key: controller.gstValidateKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.h),
                            child: Column(
                              children: [
                                AppTextFormField(
                                  controller:
                                      controller.gSTOriginalPriceController,
                                  radioButton: false,
                                  keyboardType: TextInputType.number,
                                  title: 'Initial Amount',
                                  hint: 'Ex: 10,000',
                                  numFormater: [AmountFormatter()],
                                  textInputAction: TextInputAction.next,
                                ),
                                AppDropdown(
                                  title: "Rate of GST(%)",
                                  options: controller.rateOfGst,
                                  value: controller.rateOfGstValue.value,
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      controller.rateOfGstValue.value = value;
                                      // Triggering update so UI reflects changes
                                      controller.update();
                                    }
                                  },
                                ),
                                Obx(() {
                                  return controller.rateOfGstValue.value ==
                                          "Other"
                                      ? AppTextFormField(
                                          controller: controller
                                              .gstPercentageController,
                                          radioButton: false,
                                          keyboardType: TextInputType.number,
                                          title: 'Custom Rate(%)',
                                          hint: "15",
                                          maxLength: 3,
                                          textInputAction: TextInputAction.done,
                                        )
                                      : const SizedBox();
                                }),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    _buildInterestTypeRadio(
                                        'Excluding GST', 0, controller),
                                    _buildInterestTypeRadio(
                                        'Including GST', 1, controller),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: AppButton(
                                          height: 35.h,
                                          style: notoSans.w500.get12.white,
                                          "Calculate",
                                          onPressed: () {
                                            controller.calculateGST();
                                          },
                                          bg: AppColors.appColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: AppButton(
                                          height: 35.h,
                                          style: notoSans.w500.get12.appColor,
                                          "Reset",
                                          onPressed: () {
                                            controller.reset();
                                          },
                                          bg: AppColors.stoicWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                if (controller.isResultVisible.isTrue) ...[
                                  SizedBox(height: 20.h),
                                  buildResultTable(controller),
                                  SizedBox(height: 10.h),
                                  Text(
                                    "(CGST : ${controller.cgstPercentage}% = ${controller.cgstAmount.toStringAsFixed(1)}) , (SGST : ${controller.sgstPercentage}% = ${controller.sgstAmount.toStringAsFixed(1)})",
                                    style: notoSans.gray.get11,
                                  ),
                                  SizedBox(height: 10.h),
                                  AppButton(
                                      bg: AppColors.appColor,
                                      height: 35.h,
                                      width: 100.w,
                                      style: notoSans.w500.get12.white,
                                      "Share", onPressed: () {
                                    showAdAndNavigate(() {
                                      _captureAndShareImage(controller);
                                    });
                                  })
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        });
  }

  Widget buildResultTable(GSTController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Table(
        border: TableBorder.all(
            color: AppColors.appColor,
            width: 1,
            borderRadius: BorderRadius.circular(5)),
        children: [
          buildTableRow(
              "Initial Amount", formatNumber(controller.initialAmount)),
          buildTableRow("GST Amount", formatNumber(controller.gstAmount)),
          buildTableRow("Total Amount", formatNumber(controller.gSTFinalPrice)),
        ],
      ),
    );
  }

  Widget _buildInterestTypeRadio(
      String label, int value, GSTController controller) {
    return Obx(() {
      bool isSelected = controller.selectedInterestType.value == value;

      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
          child: GestureDetector(
            onTap: () {
              controller.selectedInterestType.value = value;
              controller.update();
            },
            child: Row(
              children: [
                Image.asset(
                  isSelected
                      ? 'assets/icons/selected_icon.png'
                      : 'assets/icons/unselected_radio.png',
                  width: 15.w, // Icon size management
                  height: 15.h,
                ),
                SizedBox(width: 8.w), // Space between icon and text
                Text(
                  label,
                  style: notoSans.black.get10.w600,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _captureAndShareImage(GSTController controller) async {
    try {
      // Ensure the widget is fully built before capturing the image
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Scroll to the top to capture the full content
        Scrollable.ensureVisible(controller.boundaryKey.currentContext!);

        // Wait for the UI to be fully rendered
        await Future.delayed(const Duration(milliseconds: 100));

        RenderRepaintBoundary boundary = controller.boundaryKey.currentContext
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
      });
    } catch (e) {
      showToast("Error sharing loan details: $e");
    }
  }
}
