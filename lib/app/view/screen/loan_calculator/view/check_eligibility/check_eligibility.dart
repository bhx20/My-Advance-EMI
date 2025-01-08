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
import '../../../../../model/local.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/check_eligibility_controller.dart';

class CheckEligibilityView extends StatefulWidget {
  const CheckEligibilityView({super.key});

  @override
  State<CheckEligibilityView> createState() => _CheckEligibilityViewState();
}

class _CheckEligibilityViewState extends State<CheckEligibilityView> {
  final GlobalKey _boundaryKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CheckEligibilityController(),
      builder: (controller) {
        return AppScaffold(
            appBar: myAppBar(
              titleText: "Check Eligibility",
            ),
            bottomNavigationBar:
                GoogleAdd.getInstance().showNative(isSmall: true),
            body: SingleChildScrollView(
              child: RepaintBoundary(
                key: _boundaryKey,
                child: Container(
                  color: AppColors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    child: Column(
                      children: [
                        AppTextFormField(
                          controller: controller.grossMonthlyIncomeController,
                          radioButton: false,
                          title: "Gross Monthly\nIncome",
                          hint: "Ex: 10,000",
                          numFormater: [AmountFormatter()],
                        ),
                        AppDropdown(
                          title: "FOIR (Max. % of\nsalary)",
                          options: controller.maxOfSalary,
                          value: controller.maxOfSalaryType.value,
                          onChanged: (String? value) {
                            if (value != null) {
                              controller.maxOfSalaryType.value = value;
                            }
                          },
                        ),
                        AppTextFormField(
                          controller: controller.totalMonthlyEmiController,
                          radioButton: false,
                          title: "Total Monthly\nEMI's",
                          hint: "Ex: 1,425",
                          numFormater: [AmountFormatter()],
                        ),
                        AppTextFormField(
                          maxLength: 5,
                          controller: controller.interestController,
                          radioButton: false,
                          title: "Interest %",
                          hint: "Ex: 6%",
                          numFormater: [Max100Formatter()],
                        ),
                        AppTextFormField(
                          controller: controller.periodController,
                          radioButton: false,
                          hint: "Ex: 10",
                          maxLength: 3,
                          title: "Period",
                          readOnly: controller.isCustomPeriod.value,
                          suffixIcon: buildToggle(controller,
                              list: controller.advancePeriodItem,
                              selectedType: controller.selectedPeriodType),
                          numFormater: [FilteringTextInputFormatter.digitsOnly],
                          inputStyle: controller.periodStyle,
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
                                    controller.calculateEligibility();
                                    controller.isResultVisible.isTrue;
                                    controller.update();
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
                                    controller.isResultVisible.isFalse;
                                    controller.update();
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
                              _captureAndShareImage();
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

  Widget buildResultTable(CheckEligibilityController controller) {
    return Table(
      border: TableBorder.all(
          color: AppColors.appColor,
          width: 1,
          borderRadius: BorderRadius.circular(5)),
      children: [
        buildTableRow(
            "Eligibility EMI", formatNumber(controller.eligibleEmi.value)),
        buildTableRow("Eligibility Loan Amount",
            formatNumber(controller.eligibleLoanAmount.value)),
      ],
    );
  }

  Widget buildToggle(
    CheckEligibilityController controller, {
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
}
