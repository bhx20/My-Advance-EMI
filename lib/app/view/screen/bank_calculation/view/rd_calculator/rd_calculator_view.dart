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
import '../../../../../model/local.dart';
import '../../../../../utils/num_converter/num_converter.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/rd_controller.dart';

class RDCalculatorView extends StatelessWidget {
  const RDCalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: RdController(),
        builder: (controller) {
          return AppScaffold(
              appBar: myAppBar(
                titleText: "RD Calculator",
              ),
              bottomNavigationBar:
                  GoogleAdd.getInstance().showNative(isSmall: true),
              body: RepaintBoundary(
                key: controller.boundaryKey,
                child: Container(
                  color: AppColors.white,
                  child: Form(
                    key: controller.rdValidateKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.h),
                            child: Column(
                              children: [
                                AppTextFormField(
                                  controller: controller.loanAmountController,
                                  title: "Monthly Amount",
                                  hint: "Ex: 10,000",
                                  radioButton: false,
                                  numFormater: [AmountFormatter()],
                                ),
                                AppTextFormField(
                                  controller: controller.interestController,
                                  maxLength: 5,
                                  title: "Interest %",
                                  hint: "Ex: 7%",
                                  radioButton: false,
                                  numFormater: [Max100Formatter()],
                                ),
                                AppTextFormField(
                                  controller: controller.periodController,
                                  radioButton: false,
                                  hint: "Ex: 60",
                                  maxLength: 3,
                                  title: "Period",
                                  suffixIcon: buildToggle(controller,
                                      list: controller.advancePeriodItem,
                                      selectedType:
                                          controller.selectedPeriodType),
                                  numFormater: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  inputStyle: controller.periodStyle,
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
                                            controller.calculateResult();
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
                                            controller.resetForm();
                                          },
                                          bg: AppColors.stoicWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                if (controller.isResultVisible == true) ...[
                                  SizedBox(height: 20.h),
                                  buildResultTable(controller),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.h),
                                    child: PieChatView(
                                      centerSpaceRadius: 20,
                                      interestRatio: convertToDouble(controller
                                          .totalInterestRatio
                                          .toStringAsFixed(1)),
                                      loanRatio: convertToDouble(controller
                                          .totalInvestmentRatio
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

  Future<void> _captureAndShareImage(RdController controller) async {
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

  Widget buildToggle(
    RdController controller, {
    required List<ToggleList> list,
    required RxInt selectedType,
  }) {
    Widget buildText(ToggleList toggleItem, int index) {
      return Row(
        children: [
          Text(
            toggleItem.title,
            style: toggleItem.isSelected
                ? notoSans.bold.appColor.get10
                : notoSans.gray.get10,
          ),
          if (index == 0) Text("  |", style: notoSans.gray.get10.bold)
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(right: 5.h),
      child: ToggleButtons(
        isSelected: List.generate(
          list.length,
          (index) => list[index].isSelected,
        ),
        onPressed: (int index) {
          controller.selectedPeriodType.value = index;
          for (int i = 0; i < list.length; i++) {
            list[i].isSelected = i == index;
          }
          controller.update();
        },
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        fillColor: Colors.transparent,
        highlightColor: AppColors.trans,
        splashColor: AppColors.trans,
        selectedColor: AppColors.appColor,
        children: List.generate(
          list.length,
          (index) => buildText(list[index], index),
        ),
      ),
    );
  }

  Widget buildResultTable(RdController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Table(
        border: TableBorder.all(
            color: AppColors.appColor,
            width: 1,
            borderRadius: BorderRadius.circular(5)),
        children: [
          buildTableRow(
              "Total Investment", formatNumber(controller.totalInvestment)),
          buildTableRow(
              "Total Interest", formatNumber(controller.totalInterest)),
          buildTableRow(
              "Maturity Amount", formatNumber(controller.maturityAmount)),
          buildTableRow("Maturity Date", controller.maturityDate),
        ],
      ),
    );
  }
}
