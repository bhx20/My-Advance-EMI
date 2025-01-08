import 'package:advance_emi/app/component/google_add/google_advertise_repo/advertise_repo.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_button/app_button.dart';
import '../../../../../component/app_textformfield/common_field.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../core/app_typography.dart';
import '../../../../../model/local.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/moratorium_controller.dart';

class MoratoriumCalculatorView extends StatefulWidget {
  const MoratoriumCalculatorView({super.key});

  @override
  State<MoratoriumCalculatorView> createState() =>
      _MoratoriumCalculatorViewState();
}

class _MoratoriumCalculatorViewState extends State<MoratoriumCalculatorView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MoratoriumController(),
      builder: (controller) {
        return AppScaffold(
            appBar: myAppBar(
              titleText: "Moratorium Calculator",
            ),
            bottomNavigationBar:
                GoogleAdd.getInstance().showNative(isSmall: true),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Column(
                  children: [
                    AppTextFormField(
                      controller: controller.loanAmountController,
                      title: "Loan Amount",
                      hint: "Ex: 5,00,000",
                      radioButton: false,
                      numFormater: [AmountFormatter()],
                    ),
                    AppTextFormField(
                      controller: controller.interestController,
                      maxLength: 5,
                      title: "Interest %",
                      hint: "Ex: 8.5%",
                      radioButton: false,
                      numFormater: [Max100Formatter()],
                    ),
                    AppTextFormField(
                      controller: controller.periodController,
                      radioButton: false,
                      hint: "Ex: 120",
                      maxLength: 3,
                      title: "Period",
                      suffixIcon: buildToggle(controller,
                          list: controller.advancePeriodItem,
                          selectedType: controller.selectedPeriodType),
                      numFormater: [FilteringTextInputFormatter.digitsOnly],
                      inputStyle: controller.periodStyle,
                    ),
                    if (controller.isNoChangeInLoanTenureSelected())
                      AppTextFormField(
                        controller: controller.installmentsPaidController,
                        title: "Installments Paid",
                        hint: "Month",
                        maxLength: 3,
                        numFormater: [FilteringTextInputFormatter.digitsOnly],
                        radioButton: false,
                      ),
                    AppTextFormField(
                      controller: controller.moratoriumPeriodController,
                      title: "Moratorium Period",
                      hint: "Month",
                      maxLength: 3,
                      numFormater: [FilteringTextInputFormatter.digitsOnly],
                      radioButton: false,
                    ),
                    AppDropdown(
                      title: "FOIR (Max. % of\nsalary)",
                      options: controller.selectOption,
                      value: controller.selectOptionType.value,
                      onChanged: (String? value) {
                        if (value != null) {
                          controller.selectOptionType.value = value;
                          controller.update();
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
                                controller.calculateMoratorium();
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
                      RepaintBoundary(
                        key: controller.boundaryKey,
                        child: Container(
                          color: AppColors.white,
                          child: Column(
                            children: [
                              SizedBox(height: 20.h),
                              buildResultTable(controller),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                      AppButton(
                          bg: AppColors.appColor,
                          height: 35.h,
                          width: 100.w,
                          style: notoSans.w500.get12.white,
                          "Share", onPressed: () {
                        showAdAndNavigate(() {
                          controller.captureAndShareImage();
                        });
                      })
                    ],
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget buildResultTable(MoratoriumController controller) {
    return Table(
      border: TableBorder.all(
          borderRadius: BorderRadius.circular(5), color: AppColors.appColor),
      children: [
        TableRow(children: [
          _buildTableHeader(""),
          _buildTableHeader("No Moratorium"),
          _buildTableHeader(
              controller.selectOptionType.value == "No change in loan tenure"
                  ? "Moratorium Revise Tenure"
                  : "Moratorium Revise EMI"),
        ]),
        TableRow(children: [
          _buildTableCell('Total Principal', true),
          _buildTableCell(
              formatNumber(controller.totalPrincipalNoMoratorium.value)),
          _buildTableCell(
              formatNumber(controller.totalPrincipalWithMoratorium.value)),
        ]),
        TableRow(children: [
          _buildTableCell('Monthly EMI', true),
          _buildTableCell(
              formatNumber(controller.monthlyEMINoMoratorium.value)),
          _buildTableCell(
              formatNumber(controller.monthlyEMIWithMoratorium.value)),
        ]),
        TableRow(children: [
          _buildTableCell('Tenure \n(In Month)', true),
          _buildTableCell(formatNumber(controller.tenureNoMoratorium.value)),
          _buildTableCell(formatNumber(controller.tenureWithMoratorium.value)),
        ]),
        TableRow(children: [
          _buildTableCell('Total Interest', true),
          _buildTableCell(
              formatNumber(controller.totalInterestNoMoratorium.value)),
          _buildTableCell(
              formatNumber(controller.totalInterestWithMoratorium.value)),
        ]),
        TableRow(children: [
          _buildTableCell('Total Payment', true),
          _buildTableCell(
              formatNumber(controller.totalPaymentNoMoratorium.value)),
          _buildTableCell(
              formatNumber(controller.totalPaymentWithMoratorium.value)),
        ]),
      ],
    );
  }

  Widget buildToggle(
    MoratoriumController controller, {
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

  Widget _buildTableHeader(String text) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Center(
          child: Text(
        text,
        style: notoSans.bold.get12,
        textAlign: TextAlign.center,
      )),
    );
  }

  Widget _buildTableCell(String text, [bool isHighlight = false]) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: notoSans.w500.get12.copyWith(
            color: isHighlight ? AppColors.appColor : null,
          ),
        ),
      ),
    );
  }
}
