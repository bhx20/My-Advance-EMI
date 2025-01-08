import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_button/app_button.dart';
import '../../../../../component/app_textformfield/common_field.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../component/toast/app_toast.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../core/app_typography.dart';
import '../../../../../model/local.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/compare_loan_controller.dart';

class CompareLoanDetailsView extends StatelessWidget {
  final List<Loan> dataValue;

  const CompareLoanDetailsView({super.key, required this.dataValue});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (dataValue.isEmpty) {
          Get.find<CompareLoanController>().clearData();
        }
        return true;
      },
      child: GetBuilder<CompareLoanController>(
        initState: (_) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              Get.find<CompareLoanController>().clearData();
              _showAddLoanDialog(context, Get.find<CompareLoanController>(), 0);
            },
          );
        },
        init: CompareLoanController(),
        builder: (controller) {
          final loansList = controller.newDataList;

          final displayList = [...loansList, ...dataValue];

          final uniqueDisplayList = displayList.toSet().toList();
          uniqueDisplayList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          return AppScaffold(
            appBar: myAppBar(
                titleText: "Compare Loans",
                onPressed: () {
                  controller.clearData();
                  Get.back();
                }),
            bottomNavigationBar:
                GoogleAdd.getInstance().showNative(isSmall: true),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: uniqueDisplayList.length,
                      itemBuilder: (context, index) {
                        final loan = uniqueDisplayList[index];
                        return _buildDataRow(loan);
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showAdAndNavigate(() {
                  _showAddLoanDialog(context, controller, 0);
                });
              },
              backgroundColor: AppColors.appColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.appColor,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          _headerText('Loan Amount'),
          _headerText('%'),
          _headerText('Period\n(m)'),
          _headerText('Monthly EMI'),
          _headerText('Total Interest'),
          _headerText('Total Payment'),
        ],
      ),
    );
  }

  Widget _headerText(String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: notoSans.w500.white.get9,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDataRow(Loan newDataList) {
    return Container(
      color: AppColors.flaxBLOOM,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        children: [
          _dataText(formatNumber(newDataList.principal)),
          _dataText(newDataList.rate.toStringAsFixed(0)),
          _dataText(newDataList.tenure.toString()),
          _dataText(formatNumber(newDataList.emi.toInt())),
          _dataText(formatNumber(newDataList.totalInterestPaid())),
          _dataText(formatNumber(newDataList.totalAmountPaid())),
        ],
      ),
    );
  }

  Widget _dataText(String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: notoSans.w500.black.get9,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showAddLoanDialog(
      BuildContext context, CompareLoanController controller, int index) {
    final TextEditingController principalController = TextEditingController();
    final TextEditingController rateController = TextEditingController();
    final TextEditingController tenureController = TextEditingController();
    controller.selectedPeriodIndex.value = 0;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Add New Loan',
                        style: notoSans.w600.get15.appColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: AppTextFormField(
                      radioButton: false,
                      title: "Loan Amount",
                      controller: principalController,
                      keyboardType: TextInputType.number,
                      hint: "Ex: 10,00,000",
                      numFormater: [AmountFormatter()],
                      autoValidation: false,
                    ),
                  ),
                  AppTextFormField(
                    radioButton: false,
                    title: "Interest %",
                    controller: rateController,
                    keyboardType: TextInputType.number,
                    hint: "Ex:6%",
                    maxLength: 5,
                    numFormater: [Max100Formatter()],
                    autoValidation: false,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: AppTextFormField(
                      radioButton: false,
                      title: "Period",
                      controller: tenureController,
                      keyboardType: TextInputType.number,
                      numFormater: [FilteringTextInputFormatter.digitsOnly],
                      hint: "Ex:10",
                      suffixIcon: Obx(() => buildToggle(controller)),
                      maxLength: 3,
                      autoValidation: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AppButton(
                            height: 35.h,
                            style: notoSans.w500.get12.appColor,
                            "Cancel",
                            onPressed: () {
                              if (dataValue.isEmpty) {
                                Get.back();
                                Get.back();
                              } else {
                                Get.back();
                              }
                            },
                            bg: AppColors.stoicWhite,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: AppButton(
                            height: 35.h,
                            style: notoSans.w500.get12.white,
                            "Add to Compare",
                            onPressed: () {
                              if (principalController.text.isNotEmpty &&
                                  rateController.text.isNotEmpty &&
                                  tenureController.text.isNotEmpty) {
                                double principal = double.parse(
                                    principalController.text
                                        .replaceAll(',', ''));
                                double rate = double.parse(
                                    rateController.text.replaceAll(',', ''));
                                int tenure = int.parse(
                                    tenureController.text.replaceAll(',', ''));

                                if (principal <= 0) {
                                  showToast(
                                      'Loan Amount must be greater than zero.');
                                } else if (rate <= 0) {
                                  showToast(
                                      'Interest rate must be greater than zero.');
                                } else if (tenure <= 0) {
                                  showToast(
                                      'Period must be greater than zero.');
                                } else {
                                  showAdAndNavigate(() {
                                    controller.addLoan(principal, rate, tenure);
                                    Get.back();
                                  });
                                }
                              } else {
                                showToast('Please fill all fields.');
                              }
                            },
                            bg: AppColors.appColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildToggle(CompareLoanController controller) {
    Widget buildText(ToggleList toggleItem, int index, bool isLast) {
      return Row(
        children: [
          Text(
            toggleItem.title,
            style: controller.selectedPeriodIndex.value == index
                ? notoSans.bold.appColor.get10 // Style for selected
                : notoSans.gray.get10, // Style for unselected
          ),
          if (!isLast)
            Text(
              " |",
              style: notoSans.gray.get10.bold,
            ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(right: 5.h),
      child: ToggleButtons(
        isSelected: List.generate(
          controller.toggleItem.length,
          (index) => controller.selectedPeriodIndex.value == index,
        ),
        onPressed: (index) {
          controller.onPeriodChangedData(
              index, controller.selectedPeriodIndex.value);
        },
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        fillColor: Colors.transparent,
        highlightColor: AppColors.trans,
        splashColor: AppColors.trans,
        selectedColor: AppColors.appColor,
        children: List.generate(
          controller.toggleItem.length,
          (index) => buildText(
            controller.toggleItem[index],
            index,
            index == controller.toggleItem.length - 1, // Last item check
          ),
        ),
      ),
    );
  }
}
