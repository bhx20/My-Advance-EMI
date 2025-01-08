import 'dart:io';
import 'dart:ui' as ui;

import 'package:advance_emi/app/component/google_add/google_advertise_repo/advertise_repo.dart';
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
import '../../../../../component/toast/app_toast.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../core/app_typography.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/simple_controller.dart';

class SimpleCalculation extends StatefulWidget {
  const SimpleCalculation({super.key});

  @override
  State<SimpleCalculation> createState() => _SimpleCalculationState();
}

class _SimpleCalculationState extends State<SimpleCalculation> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SimpleController(),
      builder: (controller) {
        return AppScaffold(
            appBar: myAppBar(
              titleText: "Interest Calculator",
            ),
            bottomNavigationBar:
                GoogleAdd.getInstance().showNative(isSmall: true),
            body: SingleChildScrollView(
              child: RepaintBoundary(
                key: controller.boundaryKey,
                child: Container(
                  color: AppColors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        _buildHeader(controller),
                        SizedBox(height: 15.h),
                        AppTextFormField(
                          controller: controller.amountController,
                          title: "Amount",
                          radioButton: false,
                          hint: "Ex: 1,00,000",
                          numFormater: [AmountFormatter()],
                        ),
                        AppTextFormField(
                          controller: controller.interestController,
                          title: "Interest",
                          radioButton: false,
                          maxLength: 5,
                          hint: "Ex: 7.5%",
                          numFormater: [Max100Formatter()],
                        ),
                        if (controller.selectedIndex.value == 0) ...[
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: AppTextFormField(
                                  fillColor: AppColors.white,
                                  width: 120.w,
                                  controller: controller.yearsController,
                                  radioButton: false,
                                  maxLength: 3,
                                  hint: "Years",
                                  title: "Period",
                                  numFormater: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Expanded(
                                flex: 1,
                                child: AppTextFormField(
                                  fillColor: AppColors.white,
                                  controller: controller.monthsController,
                                  radioButton: false,
                                  maxLength: 3,
                                  hint: "Months",
                                  numFormater: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Expanded(
                                flex: 1,
                                child: AppTextFormField(
                                  controller: controller.dayController,
                                  radioButton: false,
                                  maxLength: 3,
                                  hint: "Days",
                                  numFormater: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          AppTextFormField(
                            readOnly: true,
                            title: "From Date",
                            fillColor: AppColors.white,
                            radioButton: false,
                            controller: controller.fromDateController,
                            onTap: () {
                              controller.selectDate(
                                  context,
                                  controller.selectedFromDate,
                                  controller.fromDateController);
                            },
                          ),
                          AppTextFormField(
                            readOnly: true,
                            title: "To Date",
                            fillColor: AppColors.white,
                            radioButton: false,
                            controller: controller.toDateController,
                            onTap: () {
                              controller.selectDate(
                                  context,
                                  controller.selectedToDate,
                                  controller.toDateController);
                            },
                          ),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                child: Text(
                              "Interest Type",
                              style: notoSans.black.get10.w600,
                            )),
                            SizedBox(
                              width: 15.w,
                            ),
                            _buildInterestTypeRadio('Simple', 0, controller),
                            _buildInterestTypeRadio('Compound', 1, controller),
                          ],
                        ),
                        if (controller.selectedInterestType.value == 1)
                          AppDropdown(
                            title: "Frequency",
                            options: controller.frequencyValue,
                            value: controller.frequencyType.value,
                            onChanged: (String? value) {
                              if (value != null) {
                                controller.frequencyType.value = value;
                              }
                            },
                          ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AppButton(
                                  height: 35.h,
                                  style: notoSans.w500.get12.white,
                                  "Calculate",
                                  onPressed: () {
                                    controller.calculate();
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
                                    controller.resetFields();
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
                ),
              ),
            ));
      },
    );
  }

  Future<void> _captureAndShareImage(SimpleController controller) async {
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

  Widget buildResultTable(SimpleController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Table(
        border: TableBorder.all(
            color: AppColors.appColor,
            width: 1,
            borderRadius: BorderRadius.circular(5)),
        children: [
          buildTableRow(
              "Principal Amount", formatNumber(controller.principalAmount)),
          buildTableRow(
              "Interest Amount", formatNumber(controller.interestAmount)),
          buildTableRow("Total Amount", formatNumber(controller.totalAmount)),
        ],
      ),
    );
  }

  Widget _buildHeader(SimpleController controller) {
    return Container(
        height: 35.h,
        decoration: BoxDecoration(
            color: AppColors.gray.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: List.generate(
              controller.toggleItem.length,
              (index) => Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        controller.updateSelectedIndex(index);
                      },
                      child: Container(
                        margin: EdgeInsets.all(2.h),
                        decoration: BoxDecoration(
                            color: controller.selectedIndex.value == index
                                ? AppColors.appColor
                                : AppColors.trans,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          controller.toggleItem[index],
                          style: controller.selectedIndex.value == index
                              ? notoSans.w400.white.get12
                              : notoSans.w400.black.get12,
                        )),
                      ),
                    ),
                  )),
        ));
  }

  Widget _buildInterestTypeRadio(
      String label, int value, SimpleController controller) {
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
