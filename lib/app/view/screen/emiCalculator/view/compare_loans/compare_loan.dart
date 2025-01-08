import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_button/app_button.dart';
import '../../../../../component/app_textformfield/common_field.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../core/app_typography.dart';
import '../../../../../model/local.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/compare_loan_controller.dart';
import 'compare_loan_details.dart';

class CompareLoanView extends StatefulWidget {
  const CompareLoanView({super.key});

  @override
  State<CompareLoanView> createState() => _CompareLoanViewState();
}

class _CompareLoanViewState extends State<CompareLoanView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompareLoanController>(
      init: CompareLoanController(),
      builder: (controller) {
        return AppScaffold(
          appBar: myAppBar(titleText: "Compare Loans", actions: [
            IconButton(
                onPressed: () {
                  navigateTo(const CompareLoanDetailsView(
                    dataValue: [],
                  ));
                },
                icon: Icon(
                  Icons.add,
                  color: AppColors.white,
                  size: 22.h,
                ))
          ]),
          bottomNavigationBar:
              GoogleAdd.getInstance().showNative(isSmall: true),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
            child: SingleChildScrollView(
              controller: controller.scrollController,
              child: Column(
                children: [
                  Form(
                    key: controller.compareLoanKey,
                    child: SizedBox(
                      width: Get.width,
                      child: Row(
                        children: List.generate(
                          controller.loans.length,
                          (i) => _buildLoanRow(i, controller),
                        ),
                      ),
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
                              controller.compareLoan();
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
                              controller.resetDataLoan();
                            },
                            bg: AppColors.stoicWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (controller.isResult.isTrue)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.white,
                                border: Border.all(
                                    color: AppColors.border, width: 0.8)),
                            child: Column(
                              children: [
                                _loanResultBox(
                                    title: 'Monthly Emi',
                                    topMargin: false,
                                    loan1: controller.loans[0].emi.toInt(),
                                    loan2: controller.loans[1].emi.toInt()),
                                Container(
                                  height: 0.5.h,
                                  width: Get.width,
                                  color: AppColors.border,
                                ),
                                _loanResultBox(
                                    title: 'Total Interest',
                                    loan1:
                                        controller.loans[0].totalInterestPaid(),
                                    loan2: controller.loans[1]
                                        .totalInterestPaid()),
                                Container(
                                  height: 0.5.h,
                                  width: Get.width,
                                  color: AppColors.border,
                                ),
                                _loanResultBox(
                                    title: 'Total Payment',
                                    loan1:
                                        controller.loans[0].totalAmountPaid(),
                                    loan2:
                                        controller.loans[1].totalAmountPaid()),
                              ],
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                showAdAndNavigate(() => navigateTo(
                                    CompareLoanDetailsView(
                                        dataValue: controller.loans)));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 15.h),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Compare more >>",
                                    style: notoSans.w400.appColor.get12
                                        .textDecoration(
                                            TextDecoration.underline),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _loanResultBox({
    required String title,
    bool topMargin = true,
    int loan1 = 0,
    int loan2 = 0,
  }) {
    int difference = (loan1 - loan2).abs();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        children: [
          Text(
            title,
            style: notoSans.get10.bold.black,
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: SizedBox(
              width: Get.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: Row(
                  children: [
                    _dataWidget(title: formatNumber(loan1)),
                    _dataWidget(title: formatNumber(loan2)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  "Difference:",
                  style: notoSans.get10.w300.black,
                )),
                Center(
                    child: Text(
                  " ${formatNumber(difference)}",
                  style: notoSans.get10.w600.appColor,
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _dataWidget({String? title}) {
    return Expanded(
        child: Center(
            child: Text(
      title ?? "00",
      style: notoSans.get10.w600,
    )));
  }

  Widget _buildLoanRow(int index, CompareLoanController controller) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
              child: Text(
                'LOAN ${index + 1}',
                style: notoSans.get14.bold.black,
              ),
            ),
            AppTextFormField(
              controller: controller.loans[index].principalController,
              keyboardType: TextInputType.number,
              hint: "Loan ${index + 1} amount",
              numFormater: [AmountFormatter()],
              autoValidation: false,
            ),
            AppTextFormField(
              controller: controller.loans[index].rateController,
              keyboardType: TextInputType.number,
              hint: "Interest %",
              maxLength: 5,
              numFormater: [Max100Formatter()],
              autoValidation: false,
            ),
            AppTextFormField(
              controller: controller.loans[index].tenureController,
              keyboardType: TextInputType.number,
              hint: "Ex:10",
              suffixIcon: buildToggle(controller, index),
              numFormater: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 3,
              autoValidation: false,
              textInputAction:
                  index == 0 ? TextInputAction.next : TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildToggle(CompareLoanController controller, int index) {
    List<ToggleList> toggleItems = [
      ToggleList(controller.loans[index].selectedPeriodIndex == 0, 'Years'),
      ToggleList(controller.loans[index].selectedPeriodIndex == 1, 'Months'),
    ];

    Widget buildText(ToggleList toggleItem) {
      return Row(
        children: [
          Text(
            toggleItem.title,
            style: toggleItem.isSelected
                ? notoSans.bold.appColor.get10
                : notoSans.gray.get10,
          ),
          if (toggleItem.title == 'Years')
            Text("  |", style: notoSans.gray.get10.bold),
        ],
      );
    }

    void onTogglePressed(int selectedIndex) {
      controller.onPeriodChanged(selectedIndex, index);
    }

    return Padding(
      padding: EdgeInsets.only(right: 5.h),
      child: ToggleButtons(
        isSelected: toggleItems.map((item) => item.isSelected).toList(),
        onPressed: onTogglePressed,
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        fillColor: Colors.transparent,
        highlightColor: AppColors.trans,
        splashColor: AppColors.trans,
        selectedColor: AppColors.appColor,
        children: toggleItems.map(buildText).toList(),
      ),
    );
  }
}
