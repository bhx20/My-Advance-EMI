import 'dart:io';
import 'dart:ui' as ui;

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
import '../../../../../component/app_textformfield/common_field.dart';
import '../../../../../component/globle_widget.dart';
import '../../../../../component/google_add/InitialController.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../component/toast/app_toast.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../core/app_typography.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/discount_controller.dart';

class DiscountCalculatorView extends StatefulWidget {
  const DiscountCalculatorView({super.key});

  @override
  State<DiscountCalculatorView> createState() => _DiscountCalculatorViewState();
}

class _DiscountCalculatorViewState extends State<DiscountCalculatorView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DiscountController(),
      builder: (controller) {
        return AppScaffold(
            bottomNavigationBar:
                GoogleAdd.getInstance().showNative(isSmall: true),
            appBar: myAppBar(
              titleText: "Discount Calculator",
            ),
            body: Obx(() => SingleChildScrollView(
                  child: RepaintBoundary(
                    key: controller.boundaryKey,
                    child: Container(
                      color: AppColors.white,
                      child: Padding(
                        padding: EdgeInsets.all(10.h),
                        child: Column(
                          children: [
                            AppTextFormField(
                              radioButton: false,
                              hint: "Ex: 5,00,000",
                              controller: controller.amountController,
                              title: "Amount",
                              numFormater: [AmountFormatter()],
                            ),
                            AppTextFormField(
                              radioButton: false,
                              hint: "Ex: 8.5%",
                              controller: controller.discountController,
                              maxLength: 5,
                              title: "Discount %",
                              numFormater: [Max100Formatter()],
                            ),
                            AppTextFormField(
                              radioButton: false,
                              maxLength: 3,
                              controller: controller.salesTaxController,
                              title: "Sales Tax %",
                              numFormater: [Max100Formatter()],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                    child: Text(
                                  "Apply Discount",
                                  style: notoSans.black.get10.w600,
                                )),
                                SizedBox(
                                  width: 15.w,
                                ),
                                _buildInterestTypeRadio(
                                    'After Tax', 0, controller),
                                _buildInterestTypeRadio(
                                    'Before Tax', 1, controller),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
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
                                        controller.calculateDiscount();
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
                                        controller.resetData();
                                      },
                                      bg: AppColors.stoicWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                    ),
                  ),
                )));
      },
    );
  }

  Future<void> _captureAndShareImage(DiscountController controller) async {
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

  Widget buildResultTable(DiscountController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Table(
        border: TableBorder.all(
            color: AppColors.appColor,
            width: 1,
            borderRadius: BorderRadius.circular(5)),
        children: [
          buildTableRow("Amount", (controller.amountController.text)),
          buildTableRow("Sales Tax", formatNumber(controller.salesTax.value)),
          buildTableRow("Savings", formatNumber(controller.savings.value)),
          buildTableRow(
              "Payable Amount", formatNumber(controller.payableAmount.value)),
        ],
      ),
    );
  }

  Widget _buildInterestTypeRadio(
      String label, int value, DiscountController controller) {
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
                      ? 'assets/icons/selected_icon.png' // Selected icon
                      : 'assets/icons/unselected_radio.png', // Unselected icon
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
