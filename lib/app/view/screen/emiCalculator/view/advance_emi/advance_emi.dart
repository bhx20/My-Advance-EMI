import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:advance_emi/app/view/screen/history/view/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_button/app_button.dart';
import '../../../../../component/app_textformfield/common_field.dart';
import '../../../../../component/globle_widget.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../model/local.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/advance_emi_controller.dart';
import '../emi_calculator/emi_details_screen.dart';

class AdvanceEMIView extends StatefulWidget {
  const AdvanceEMIView({super.key});

  @override
  State<AdvanceEMIView> createState() => _AdvanceEMIViewState();
}

class _AdvanceEMIViewState extends State<AdvanceEMIView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AdvanceEMIController(),
      builder: (controller) {
        return AppScaffold(
            appBar: myAppBar(titleText: "Advance EMI Calculator", actions: [
              Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: IconButton(
                  icon: Icon(
                    Icons.history,
                    color: AppColors.black,
                    size: 20.h,
                  ),
                  onPressed: () {
                    showAdAndNavigate(() => navigateTo(HistoryScreenView(
                          calculateData: controller.advanceCalculate,
                        )));
                  },
                ),
              ),
            ]),
            bottomNavigationBar:
                GoogleAdd.getInstance().showNative(isSmall: true),
            body: Obx(() => SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(10.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppTextFormField(
                          radioButton: false,
                          hint: "Ex: 10,00,000",
                          controller: controller.amountController,
                          radioTap: () =>
                              controller.handleRadioChange('Amount'),
                          title: "Amount",
                          readOnly: controller.isCustomAmount.value,
                          numFormater: [AmountFormatter()],
                        ),
                        AppTextFormField(
                          radioButton: false,
                          hint: "Ex: 6%",
                          controller: controller.interestController,
                          maxLength: 5,
                          radioTap: () =>
                              controller.handleRadioChange('Interest %'),
                          title: "Interest %",
                          suffixIcon: buildToggle(controller,
                              list: controller.advanceInterestItem,
                              selectedType: controller.selectedInterestIndex),
                          readOnly: controller.isCustomInterest.value,
                          numFormater: [Max100Formatter()],
                        ),
                        AppTextFormField(
                          radioButton: false,
                          hint: "Ex: 10",
                          maxLength: 3,
                          controller: controller.periodController,
                          radioTap: () =>
                              controller.handleRadioChange('Period'),
                          title: "Period",
                          readOnly: controller.isCustomPeriod.value,
                          suffixIcon: buildToggle(controller,
                              list: controller.advancePeriodItem,
                              selectedType: controller.selectedPeriodType),
                          numFormater: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        AppTextFormField(
                          hint: "Ex: 3%",
                          maxLength: 5,
                          controller: controller.processingFeeController,
                          radioButton: false,
                          keyboardType: TextInputType.number,
                          title: "Processing Fee (%)",
                          suffixIcon: buildToggle(controller,
                              list: controller.advanceProcessingItem,
                              selectedType: controller.selectedProcessingIndex),
                          numFormater: [Max100Formatter()],
                        ),
                        AppTextFormField(
                          hint: "Ex: 3%",
                          maxLength: 5,
                          controller: controller.gstOnInterest,
                          radioButton: false,
                          keyboardType: TextInputType.number,
                          title: "GST On Interest (%)",
                          numFormater: [Max100Formatter()],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildInterestTypeRadio(
                                  'EMI In Arrears', 0, controller),
                              _buildInterestTypeRadio(
                                  'EMI In Advance', 1, controller),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AppButton(
                                  height: 35.h,
                                  style: notoSans.w500.get12.white,
                                  "Calculate",
                                  onPressed: () {
                                    controller.calculateEmi();
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
                        AppButton(
                          height: 35.h,
                          "Detail",
                          onPressed: () {
                            if (controller.emiResult != null) {
                              showAdAndNavigate(() => navigateTo(
                                  EmiDetailsScreen(
                                      emiResult: controller.emiResult)));
                            }
                          },
                          style: notoSans.w500.get12.white,
                          bg: AppColors.appColor,
                        ),
                        if (controller.emiResult != null) ...[
                          SizedBox(height: 20.h),
                          buildResultTable(controller),
                        ],
                      ],
                    ),
                  ),
                )));
      },
    );
  }

  Widget _buildInterestTypeRadio(
      String label, int value, AdvanceEMIController controller) {
    return Obx(() {
      bool isSelected = controller.selectedAdvanceType.value == value;

      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
          child: GestureDetector(
            onTap: () {
              controller.selectedAdvanceType.value = value;
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

  Widget buildResultTable(AdvanceEMIController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Table(
        border: TableBorder.all(
            color: AppColors.appColor,
            width: 1,
            borderRadius: BorderRadius.circular(5)),
        children: [
          buildTableRow("Monthly EMI", controller.emiResult?.monthlyEmi ?? ""),
          buildTableRow(
              "Total Interest", controller.emiResult?.totalInterest ?? ""),
          buildTableRow(
              "Processing Fees", controller.emiResult?.processingFees ?? ""),
          buildTableRow(
              "GST On Interest", controller.emiResult?.gstOnInterest ?? ""),
          buildTableRow("GST On Processing Fees",
              controller.emiResult?.gstOnProcessingFees ?? ""),
          buildTableRow(
              "Total Payment", controller.emiResult?.totalPayment ?? ""),
        ],
      ),
    );
  }

  Widget buildToggle(AdvanceEMIController controller,
      {required List<ToggleList> list, required RxInt selectedType}) {
    Widget buildText(ToggleList toggleItem, int index) {
      return Row(
        children: [
          Text(toggleItem.title,
              style: toggleItem.isSelected == true
                  ? notoSans.bold.appColor.get10
                  : notoSans.gray.get10),
          if (index == 0) Text("  |", style: notoSans.gray.get10.bold)
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(right: 5.h),
      child: ToggleButtons(
        isSelected:
            List.generate(list.length, (index) => index == selectedType.value),
        onPressed: (int index) {
          selectedType.value = index;
          for (int i = 0; i < list.length; i++) {
            list[i].isSelected = false;
          }
          list[index].isSelected = true;
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
            list.length, (index) => buildText(list[index], index)),
      ),
    );
  }
}
