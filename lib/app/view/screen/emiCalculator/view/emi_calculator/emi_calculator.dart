import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
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
import '../../../history/view/history_screen.dart';
import '../../controller/emi_calculator_controller.dart';
import 'emi_details_screen.dart';

class EmiCalculatorView extends StatefulWidget {
  const EmiCalculatorView({super.key});

  @override
  State<EmiCalculatorView> createState() => _EmiCalculatorViewState();
}

class _EmiCalculatorViewState extends State<EmiCalculatorView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EmiCalculatorController(),
      builder: (controller) {
        return AppScaffold(
            bottomNavigationBar:
                GoogleAdd.getInstance().showNative(isSmall: true),
            appBar: myAppBar(titleText: "EMI Calculator", actions: [
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
                          calculateData: controller.historyCalculate,
                        )));
                  },
                ),
              ),
            ]),
            body: Obx(() => SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(10.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppTextFormField(
                          hint: "Ex: 10,00,000",
                          controller: controller.amountController,
                          radioTap: () =>
                              controller.handleRadioChange('Amount'),
                          title: "Amount",
                          readOnly: controller.isCustomAmount.value,
                          numFormater: [AmountFormatter()],
                        ),
                        AppTextFormField(
                          hint: "Ex: 6%",
                          controller: controller.interestController,
                          maxLength: 5,
                          radioTap: () =>
                              controller.handleRadioChange('Interest %'),
                          title: "Interest %",
                          readOnly: controller.isCustomInterest.value,
                          numFormater: [Max100Formatter()],
                        ),
                        AppTextFormField(
                          hint: "Ex: 10",
                          maxLength: 3,
                          controller: controller.periodController,
                          radioTap: () =>
                              controller.handleRadioChange('Period'),
                          title: "Period",
                          readOnly: controller.isCustomPeriod.value,
                          suffixIcon: buildToggle(controller),
                          numFormater: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        AppTextFormField(
                          hint: "Ex: 1425",
                          controller: controller.emiController,
                          radioTap: () => controller.handleRadioChange('EMI'),
                          title: "EMI",
                          readOnly: controller.isCustomEmi.value,
                          numFormater: [AmountFormatter()],
                        ),
                        AppTextFormField(
                          hint: "Ex: 3%",
                          maxLength: 5,
                          controller: controller.processingFeeController,
                          radioButton: false,
                          keyboardType: TextInputType.number,
                          title: "Processing Fee %",
                          numFormater: [Max100Formatter()],
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
                          SizedBox(height: 20.h),
                          buildPieChart(
                            controller,
                          ),
                        ],
                      ],
                    ),
                  ),
                )));
      },
    );
  }

  Widget buildResultTable(EmiCalculatorController controller) {
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
              "Total Payment", controller.emiResult?.totalPayment ?? ""),
        ],
      ),
    );
  }

  Widget buildPieChart(EmiCalculatorController controller) {
    Widget buildLabel(Color color, String title) {
      return Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.w),
            height: 10.h,
            width: 10.h,
            color: color,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        SizedBox(
          height: 200.h,
          width: 200.w,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      controller.touchedIndex = -1;
                      return;
                    }
                    controller.touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 3,
              centerSpaceRadius: 45,
              sections: List.generate(2, (i) {
                final isTouched = i == controller.touchedIndex;
                final radius = isTouched ? 60.0 : 50.0;
                switch (i) {
                  case 0:
                    return PieChartSectionData(
                        color: AppColors.appColor.withOpacity(0.2),
                        value: controller.emiResult?.interestRatio,
                        title:
                            '${controller.emiResult?.interestRatio?.toStringAsFixed(2)}%',
                        radius: radius,
                        titleStyle: notoSans.black.bold.get10);
                  case 1:
                    return PieChartSectionData(
                        color: AppColors.appColor.withOpacity(0.7),
                        value: controller.emiResult?.loanRatio,
                        title:
                            '${controller.emiResult?.loanRatio?.toStringAsFixed(2)}%',
                        radius: radius,
                        titleStyle: notoSans.white.bold.get10);

                  default:
                    throw Error();
                }
              }),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLabel(AppColors.appColor.withOpacity(0.7), "Total Amount"),
                SizedBox(height: 10.w),
                buildLabel(
                    AppColors.appColor.withOpacity(0.2), "Total Interest"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildToggle(EmiCalculatorController controller) {
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

    var index = controller.selectedPeriodIndex.value;
    return Padding(
      padding: EdgeInsets.only(right: 5.h),
      child: ToggleButtons(
        isSelected: [index == 0, index == 1],
        onPressed: (i) => controller.onPeriodChanged.call(i),
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        fillColor: Colors.transparent,
        highlightColor: AppColors.trans,
        splashColor: AppColors.trans,
        selectedColor: AppColors.appColor,
        children: List.generate(controller.toggleItem.length,
            (index) => buildText(controller.toggleItem[index], index)),
      ),
    );
  }
}
