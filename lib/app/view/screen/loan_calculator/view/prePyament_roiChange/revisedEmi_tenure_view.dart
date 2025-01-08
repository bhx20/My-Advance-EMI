import 'package:advance_emi/app/component/google_add/google_advertise_repo/advertise_repo.dart';
import 'package:advance_emi/app/core/app_colors.dart';
import 'package:advance_emi/app/core/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_button/app_button.dart';
import '../../../../../component/app_textformfield/common_field.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/revisedEmi_And_Tenure_controller.dart';

class RevisedEmiAndTenureView extends StatelessWidget {
  const RevisedEmiAndTenureView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RevisedEmiAndTenureController>(
      init: RevisedEmiAndTenureController(),
      builder: (controller) {
        return AppScaffold(
          appBar: myAppBar(
            titleText: "Revised EMI & Tenure",
            isBack: true,
          ),
          bottomNavigationBar:
              GoogleAdd.getInstance().showNative(isSmall: true),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  _buildHeader(controller),
                  SizedBox(height: 15.h),
                  AppTextFormField(
                    controller: controller.outstandingAmountController,
                    title: "Outstanding\nAmount",
                    radioButton: false,
                    hint: "Ex:1,00,000",
                    numFormater: [AmountFormatter()],
                  ),
                  AppTextFormField(
                    controller: controller.currentRateController,
                    title: "Current Rate %",
                    radioButton: false,
                    hint: "Ex:6.5%",
                    maxLength: 5,
                    numFormater: [Max100Formatter()],
                  ),
                  AppTextFormField(
                    controller: controller.currentEmiController,
                    title: "Current EMI",
                    numFormater: [AmountFormatter()],
                    radioButton: false,
                    hint: "Ex:1425",
                  ),
                  if (controller.selectedIndex.value == 0) ...[
                    AppTextFormField(
                      controller: controller.prePaymentAmountController,
                      title: "Pre Payment\nAmount",
                      radioButton: false,
                      hint: "Ex:10,000",
                      numFormater: [AmountFormatter()],
                      textInputAction: TextInputAction.done,
                    ),
                  ] else ...[
                    AppTextFormField(
                      controller: controller.revisedRateController,
                      title: "Revised Rate %",
                      radioButton: false,
                      maxLength: 5,
                      hint: "Ex:5%",
                      numFormater: [Max100Formatter()],
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppButton(
                          bg: AppColors.appColor,
                          style: notoSans.w500.get12.white,
                          width: 150.w,
                          "Calculate",
                          onPressed: () {
                            controller.calculate();
                          },
                        ),
                        AppButton(
                          bg: AppColors.stoicWhite,
                          style: notoSans.w500.get12.appColor,
                          width: 150.w,
                          "Reset",
                          onPressed: () {
                            controller.reset();
                          },
                        ),
                      ],
                    ),
                  ),
                  if (controller.isResultVisible) ...[
                    _buildEmiResultSection(controller),
                    SizedBox(height: 20.h),
                    _buildTenureResultSection(controller),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(RevisedEmiAndTenureController controller) {
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

  Widget _buildEmiResultSection(RevisedEmiAndTenureController controller) {
    return Column(
      children: [
        Text("If you want to change EMI",
            style: notoSans.w500.get14.appColor.copyWith(height: 2)),
        Table(
          border: TableBorder.all(
              color: AppColors.appColor, // Color of the border
              width: 1,
              borderRadius: BorderRadius.circular(5)),
          children: [
            TableRow(children: [
              _buildTableHeader("New EMI"),
              _buildTableHeader("Old EMI"),
              _buildTableHeader("Difference"),
            ]),
            TableRow(children: [
              _buildTableCell(formatNumber(controller.newEmi), true),
              _buildTableCell((controller.currentEmiController.text)),
              _buildTableCell(formatNumber(controller.emiDifference)),
            ]),
            TableRow(children: [
              _buildTableHeader("New Interest"),
              _buildTableHeader("Old Interest"),
              _buildTableHeader("Difference"),
            ]),
            TableRow(children: [
              _buildTableCell(formatNumber(controller.oldInterestEmi), true),
              _buildTableCell(formatNumber(controller.oldInterest)),
              _buildTableCell(formatNumber(controller.interestDifference)),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _buildTenureResultSection(RevisedEmiAndTenureController controller) {
    return Column(
      children: [
        Text("If you want to change Tenure",
            style: notoSans.w500.get14.appColor.copyWith(height: 2)),
        Table(
          border: TableBorder.all(
              color: AppColors.appColor,
              width: 1,
              borderRadius: BorderRadius.circular(5)),
          children: [
            TableRow(children: [
              _buildTableHeader("New Months"),
              _buildTableHeader("Old Months"),
              _buildTableHeader("Difference"),
            ]),
            TableRow(children: [
              _buildTableCell(controller.newMonths.toStringAsFixed(2), true),
              _buildTableCell(controller.oldMonths.toStringAsFixed(2)),
              _buildTableCell(
                  "${controller.monthsDifference.toStringAsFixed(2)} Months"),
            ]),
            TableRow(children: [
              _buildTableHeader("New Interest"),
              _buildTableHeader("Old Interest"),
              _buildTableHeader("Difference"),
            ]),
            TableRow(children: [
              _buildTableCell(formatNumber(controller.newInterest), true),
              _buildTableCell(formatNumber(controller.oldInterest)),
              _buildTableCell(
                  formatNumber(controller.interestDifferenceTenure)),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Center(child: Text(text, style: notoSans.bold.get12)),
    );
  }

  Widget _buildTableCell(String text, [bool isHighlight = false]) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Center(
        child: Text(
          text,
          style: notoSans.w500.get12.copyWith(
            color: isHighlight ? AppColors.red : null,
          ),
        ),
      ),
    );
  }
}
