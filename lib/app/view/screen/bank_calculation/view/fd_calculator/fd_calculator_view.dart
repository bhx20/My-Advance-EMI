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
import '../../../../../component/pie_chat.dart';
import '../../../../../component/toast/app_toast.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../core/app_typography.dart';
import '../../../../../utils/num_converter/num_converter.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/fd_controller.dart';

class FDCalculatorView extends StatelessWidget {
  const FDCalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: FDController(),
        builder: (controller) {
          return AppScaffold(
              appBar: myAppBar(
                titleText: "FD Calculator",
              ),
              bottomNavigationBar:
                  GoogleAdd.getInstance().showNative(isSmall: true),
              body: RepaintBoundary(
                key: controller.boundaryKey,
                child: Container(
                  color: AppColors.white,
                  child: Form(
                    key: controller.fdValidateKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.h),
                            child: Column(
                              children: [
                                AppTextFormField(
                                  controller:
                                      controller.depositAmountController,
                                  title: "Investment",
                                  hint: "Ex: 10,000",
                                  radioButton: false,
                                  numFormater: [AmountFormatter()],
                                ),
                                AppTextFormField(
                                  controller:
                                      controller.fdInterestRateController,
                                  maxLength: 5,
                                  title: "Interest %",
                                  hint: "Ex: 7.1%",
                                  radioButton: false,
                                  numFormater: [Max100Formatter()],
                                ),
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
                                        readOnly:
                                            controller.frequencyType.value ==
                                                    "Short Term"
                                                ? true
                                                : false,
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
                                        readOnly:
                                            controller.frequencyType.value ==
                                                    "Short Term"
                                                ? true
                                                : false,
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
                                AppDropdown(
                                  title: "Deposit Type",
                                  options: controller.frequencyValue,
                                  value: controller.frequencyType.value,
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      controller.frequencyType.value = value;
                                      controller.update();
                                    }
                                  },
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
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.h),
                                    child: PieChatView(
                                      centerSpaceRadius: 20,
                                      interestRatio: convertToDouble(controller
                                          .interestPercentage
                                          .toStringAsFixed(1)),
                                      loanRatio: convertToDouble(controller
                                          .maturityPercentage
                                          .toStringAsFixed(1)),
                                    ),
                                  ),
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

  Future<void> _captureAndShareImage(FDController controller) async {
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

  Widget buildResultTable(FDController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Table(
        border: TableBorder.all(
            color: AppColors.appColor,
            width: 1,
            borderRadius: BorderRadius.circular(5)),
        children: [
          buildTableRow(
              "Maturity Amount", formatNumber(controller.maturityAmount)),
          buildTableRow(
              "Total Interest", formatNumber(controller.totalInterest)),
          buildTableRow("Maturity Date", controller.maturityDate.toString()),
        ],
      ),
    );
  }
}
