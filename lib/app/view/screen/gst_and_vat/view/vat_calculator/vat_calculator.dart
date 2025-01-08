import 'dart:io';
import 'dart:ui' as ui;

import 'package:advance_emi/app/component/app_textformfield/common_field.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
import '../../../../../core/app_typography.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/vat_controller.dart';

class VatCalculator extends StatefulWidget {
  const VatCalculator({super.key});

  @override
  State<VatCalculator> createState() => _VatCalculatorState();
}

class _VatCalculatorState extends State<VatCalculator> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VatController>(
        init: VatController(),
        builder: (controller) {
          return AppScaffold(
              appBar: myAppBar(
                titleText: "VAT Calculator",
              ),
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
                                  title: 'Amount',
                                  hint: 'Ex: 10,000',
                                  numFormater: [AmountFormatter()],
                                  textInputAction: TextInputAction.next,
                                ),
                                AppTextFormField(
                                  controller:
                                      controller.gstPercentageController,
                                  radioButton: false,
                                  keyboardType: TextInputType.number,
                                  title: 'Rate of VAT %',
                                  maxLength: 5,
                                  numFormater: [Max100Formatter()],
                                  textInputAction: TextInputAction.done,
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      "Apply VAT",
                                      style: notoSans.black.get10.w600,
                                    )),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    _buildInterestTypeRadio(
                                        'Add VAT', 0, controller),
                                    _buildInterestTypeRadio(
                                        'Remove VAT', 1, controller),
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
                                            controller.calculateVAT();
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
                                  SizedBox(height: 20.h),
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

  Future<void> _captureAndShareImage(VatController controller) async {
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

        await Share.shareXFiles([XFile(imageFile.path)],
            text:
                'Calculated by: \n ${Get.find<InitialController>().dbData.value.shareLink ?? ""}');
      });
    } catch (e) {
      showToast("Error sharing loan details: $e");
    }
  }

  Widget buildResultTable(VatController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Table(
        border: TableBorder.all(
            color: AppColors.appColor,
            width: 1,
            borderRadius: BorderRadius.circular(5)),
        children: [
          buildTableRow(
              "Original Cost", formatNumber(controller.initialAmount)),
          buildTableRow("VAT Price", formatNumber(controller.gstAmount)),
          buildTableRow("Net Price", formatNumber(controller.gSTFinalPrice)),
        ],
      ),
    );
  }

  Widget _buildInterestTypeRadio(
      String label, int value, VatController controller) {
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
}
