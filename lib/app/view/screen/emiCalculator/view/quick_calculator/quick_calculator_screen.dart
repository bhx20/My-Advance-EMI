import 'package:advance_emi/app/utils/utils.dart';
import 'package:advance_emi/app/view/screen/emiCalculator/view/quick_calculator/quick_calculator_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_button/app_button.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../component/pie_chat.dart';
import '../../../../../component/slider_field/sliderBar_textField.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../core/app_typography.dart';
import '../../../../../utils/num_converter/num_converter.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../../utils/num_to_word/num_to_word.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/quick_calculator_controller.dart';

class QuickCalculatorScreen extends StatefulWidget {
  const QuickCalculatorScreen({super.key});

  @override
  State<QuickCalculatorScreen> createState() => _QuickCalculatorScreenState();
}

class _QuickCalculatorScreenState extends State<QuickCalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: QuickCalculatorController(),
      builder: (controller) {
        return AppScaffold(
            appBar: myAppBar(
              titleText: "Quick Calculator",
            ),
            bottomNavigationBar:
                GoogleAdd.getInstance().showNative(isSmall: true),
            body: Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                child: Column(
                  children: [
                    _buildHeader(controller),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildResultView(controller),
                            _buildControllerView(controller)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget _buildHeader(QuickCalculatorController controller) {
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

  Widget _buildControllerView(QuickCalculatorController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          if (controller.sliderFieldShow('Amount'))
            SliderField(
                width: 190.w,
                title: 'Amount',
                label: numToWordsIndia(
                    convertToInt(controller.amountController.text)),
                value: controller.amountValue.value,
                controller: controller.amountController,
                min: controller.minimumAmount.value,
                max: controller.maximumAmount.value,
                divisions: (10000000 - 100000) ~/ 50000,
                suffixText: '₹',
                numFormater: [AmountFormatter()],
                fieldOnChange: (value) {
                  if (convertToDouble(value) > 100000) {
                    controller.updateAmount(convertToDouble(value.toString()));
                  }
                },
                sliderOnChange: controller.updateAmount),
          if (controller.sliderFieldShow('Interest'))
            SliderField(
              width: 240.w,
              title: 'Interest %',
              value: controller.interest.value,
              controller: controller.interestController,
              min: controller.minimumInterest.value,
              max: controller.maximumInterest.value,
              maxLength: 5,
              suffixText: '%',
              divisions: (30 - 1) ~/ 1,
              numFormater: [Max100Formatter()],
              fieldOnChange: (value) {
                if (convertToDouble(value) > 0) {
                  controller.updateInterest(convertToDouble(value.toString()));
                }
              },
              sliderOnChange: controller.updateInterest,
            ),
          if (controller.sliderFieldShow('Period'))
            SliderField(
              width: 240.w,
              title: 'Period',
              label:
                  '${(controller.period.value * 12).toStringAsFixed(0)} months',
              value: controller.period.value,
              controller: controller.periodController,
              min: controller.minimumPeriod.value,
              max: controller.maximumPeriod.value,
              maxLength: 2,
              divisions: (99 - 1) ~/ 1,
              suffixText: 'Yr',
              fieldOnChange: (value) {
                if (convertToDouble(value) > 0) {
                  controller.updatePeriod(convertToDouble(value.toString()));
                }
              },
              sliderOnChange: controller.updatePeriod,
            ),
          if (controller.sliderFieldShow('MonthlyEMI'))
            SliderField(
              width: 190.w,
              title: 'Monthly EMI',
              label: numToWordsIndia(
                  convertToInt(controller.monthlyEmiController.text)),
              value: controller.monthlyEmi.value,
              controller: controller.monthlyEmiController,
              min: controller.minimumMonthlyEmi.value,
              max: controller.maximumMonthlyEmi.value,
              divisions: (100000 - 1000) ~/ 500,
              suffixText: '₹',
              fieldOnChange: (value) {
                if (convertToDouble(value) > 1000) {
                  controller
                      .updateMonthlyEmi(convertToDouble(value.toString()));
                }
              },
              sliderOnChange: controller.updateMonthlyEmi,
            ),
        ],
      ),
    );
  }

  Widget _buildResultView(QuickCalculatorController controller) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
          child: Column(
            children: [
              SizedBox(
                height: 130.h,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Interest'.toUpperCase(),
                                  style: notoSans.bold.get11.black),
                              SizedBox(height: 3.h),
                              Text(
                                controller.emiResult?.totalInterest ?? "",
                                style: notoSans.w600.get12.appColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Payment'.toUpperCase(),
                                  style: notoSans.bold.get11.black),
                              SizedBox(height: 3.h),
                              Text(
                                controller.emiResult?.totalPayment ?? "",
                                style: notoSans.w600.get12.appColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: PieChatView(
                        centerSpaceRadius: 20,
                        interestRatio: convertToDouble(controller
                                .emiResult?.interestRatio
                                ?.toStringAsFixed(1) ??
                            ""),
                        loanRatio: convertToDouble(controller
                                .emiResult?.loanRatio
                                ?.toStringAsFixed(1) ??
                            ""),
                      ),
                    ),
                  ],
                ),
              ),
              _resultData(controller),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.h, bottom: 10.h),
          child: AppButton(
            height: 35.h,
            "VIEW FULL DETAILS",
            onPressed: () {
              if (controller.emiResult != null) {
                showAdAndNavigate(() => navigateTo(
                    QuickDetailsScreen(emiResult: controller.emiResult)));
              }
            },
            style: notoSans.w500.get12.white,
            bg: AppColors.appColor,
          ),
        ),
      ],
    );
  }

  Widget _resultData(QuickCalculatorController controller) {
    String title;
    String des;
    String value;
    switch (controller.selectedIndex.value) {
      case 0: // EMI selected
        title = 'Monthly EMI:  ';
        value = controller.emiResult?.monthlyEmi ?? "";
        des = _safeConvertNumberToWords(
            convertToDouble(controller.emiResult?.monthlyEmi ?? ""));
        break;
      case 1: // Amount selected
        title = 'Loan Amount:  ';
        value = controller.emiResult?.loanAmount ?? "";
        des = _safeConvertNumberToWords(
            convertToDouble(controller.emiResult?.loanAmount ?? ""));
        break;
      case 2: // Period selected
        title = 'Period (Months):  ';
        value = "${controller.emiResult?.period ?? ""} months";
        des =
            "${_safeConvertNumberToWords(convertToDouble(controller.emiResult?.period ?? ""))} months";
        break;
      case 3: // Interest selected
        title = 'Interest:  ';
        value = "${controller.emiResult?.interest ?? ""} %";
        des =
            "${_safeConvertNumberToWords(convertToDouble(controller.emiResult?.interest ?? ""))}percentage";
        break;
      default:
        title = '';
        value = "";
        des = '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(title.toUpperCase(), style: notoSans.bold.get11.black),
            Text(
              value,
              style: notoSans.w500.get15.appColor.w600,
            ),
          ],
        ),
        Text(
          des,
          style: notoSans.w400.get10.appColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _safeConvertNumberToWords(double value) {
    if (value.isFinite) {
      return numToWordsIndia(value.toInt());
    } else {
      return "";
    }
  }
}
