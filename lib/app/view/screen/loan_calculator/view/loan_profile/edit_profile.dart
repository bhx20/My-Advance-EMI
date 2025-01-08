import 'package:advance_emi/app/core/app_colors.dart';
import 'package:advance_emi/app/core/app_typography.dart';
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
import '../../../../../model/loan_profile_model.dart';
import '../../../../../model/local.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/loan_profile_controller.dart';
import 'create_profile.dart';

class EditProfile extends StatefulWidget {
  final LoanProfileData? editData;
  final int? index;
  const EditProfile({super.key, this.editData, this.index});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoanProfileController>(
      init: LoanProfileController(),
      builder: (controller) {
        return AppScaffold(
          appBar: myAppBar(
            titleText: "Edit Profile",
            isBack: true,
          ),
          bottomNavigationBar:
              GoogleAdd.getInstance().showNative(isSmall: true),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.editProfileList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showAdAndNavigate(() {
                          if (index == 0) {
                            navigateTo(
                                CreateProfileView(editData: widget.editData));
                          } else if (index == 1) {
                            _showLoanPrePaymentDialog(
                                context, controller, widget.index);
                          } else if (index == 2) {
                            _showVariableInterestRateDialog(
                                context, controller, widget.index);
                          } else if (index == 3) {
                            _showInterestSaverAccountDialog(
                                context, controller, widget.index);
                          } else {
                            _showMoratoriumPeriodDialog(
                              context,
                              controller,
                              widget.index,
                            );
                          }
                        });
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Container(
                              height: 45.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppColors.border, width: 0.8)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child: _getImageForIndex(index),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15.w),
                                          child: Text(
                                            controller.editProfileList[index],
                                            style: notoSans.w600.black.get11,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.orchid,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 10.h);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getImageForIndex(int index) {
    switch (index) {
      case 0:
        return Image.asset('assets/icons/loan_details.png');
      case 1:
        return Image.asset('assets/icons/loan_pre_payment.png');
      case 2:
        return Image.asset('assets/icons/interest-rate.png');
      case 3:
        return Image.asset('assets/icons/interest_saver_account.png');
      default:
        return Image.asset('assets/icons/moratorium_period.png');
    }
  }

  void _showLoanPrePaymentDialog(
      BuildContext context, LoanProfileController controller, int? index) {
    final TextEditingController principalController = TextEditingController();
    final TextEditingController tenureController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Loan Pre-Payment',
                      style: notoSans.w600.get15.appColor,
                    ),
                  ),
                ),
                Text(
                  "Effect of prepayment",
                  style: notoSans.w500.black.get12,
                ),
                AppDropdown(
                  options: controller.loanPrePayment,
                  value: controller.loanPrePaymentType.value.isEmpty
                      ? controller.loanPrePayment.first
                      : controller.loanPrePaymentType.value,
                  onChanged: (String? value) {
                    controller.loanPrePaymentType.value = value!;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    "PrePayment Details",
                    style: notoSans.w500.black.get12,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        radioButton: false,
                        controller: principalController,
                        keyboardType: TextInputType.number,
                        hint: "Payment Amount",
                        numFormater: [AmountFormatter()],
                        autoValidation: false,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: AppTextFormField(
                        radioButton: false,
                        controller: tenureController,
                        keyboardType: TextInputType.number,
                        numFormater: [FilteringTextInputFormatter.digitsOnly],
                        hint: "Starting Month",
                        maxLength: 3,
                        autoValidation: false,
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return Column(
                    children: controller.loanPrePaymentList
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key;
                      Map<String, String> data = entry.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              data['type'].toString(),
                              style: notoSans.w500.black.get12,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              data['principal'].toString(),
                              style: notoSans.w500.black.get12
                                  .textDecoration(TextDecoration.underline),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              data['tenure'].toString(),
                              style: notoSans.w500.black.get12
                                  .textDecoration(TextDecoration.underline),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 15,
                              ),
                              onPressed: () {
                                controller.loanPrePaymentList.removeAt(index);
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          height: 35.h,
                          style: notoSans.w500.get12.white,
                          "Save",
                          onPressed: () {
                            if (principalController.text.isNotEmpty &&
                                tenureController.text.isNotEmpty) {
                              int enteredMonth =
                                  int.parse(tenureController.text);
                              if (enteredMonth <
                                  num.parse(widget.editData?.dbData
                                          ?.loanProfile!.months ??
                                      "")) {
                                controller.addPrePaymentToLoanProfile(
                                  index!,
                                  controller.loanPrePaymentType.value,
                                  principalController.text,
                                  tenureController.text,
                                );
                                controller.loanPrePaymentList.add({
                                  'type': controller.loanPrePaymentType.value,
                                  'principal': principalController.text,
                                  'tenure': tenureController.text,
                                });
                                Get.back();
                              } else {
                                showToast("Please enter a valid month.");
                              }
                            } else {
                              Get.back();
                            }
                          },
                          bg: AppColors.appColor,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          height: 35.h,
                          style: notoSans.w500.get12.appColor,
                          "Reset",
                          onPressed: () {
                            principalController.clear();
                            tenureController.clear();
                            controller.addPrePaymentToLoanProfile(
                              index!,
                              controller.loanPrePaymentType.value,
                              principalController.text,
                              tenureController.text,
                            );
                            controller.loanPrePaymentType.value =
                                controller.loanPrePayment.first;
                            controller.loanPrePaymentList.clear();
                          },
                          bg: AppColors.stoicWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showVariableInterestRateDialog(
      BuildContext context, LoanProfileController controller, int? index) {
    final TextEditingController rateController = TextEditingController();
    final TextEditingController tenureController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Variable Interest Rate',
                      style: notoSans.w600.get15.appColor,
                    ),
                  ),
                ),
                Text(
                  "Effect of interest change",
                  style: notoSans.w500.black.get12,
                ),
                AppDropdown(
                  options: controller.variableInterestRate,
                  value: controller.variableInterestRateType.value.isEmpty
                      ? controller.variableInterestRate.first
                      : controller.variableInterestRateType.value,
                  onChanged: (String? value) {
                    controller.variableInterestRateType.value = value!;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    "Interest Change Details",
                    style: notoSans.w500.black.get12,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        radioButton: false,
                        controller: rateController,
                        keyboardType: TextInputType.number,
                        hint: "Interest Rate(%)",
                        maxLength: 5,
                        numFormater: [Max100Formatter()],
                        autoValidation: false,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: AppTextFormField(
                        width: 50.w,
                        radioButton: false,
                        controller: tenureController,
                        keyboardType: TextInputType.number,
                        numFormater: [FilteringTextInputFormatter.digitsOnly],
                        hint: "Starting Month",
                        maxLength: 3,
                        autoValidation: false,
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return Column(
                    children: controller.variableInterestRateList
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key;
                      Map<String, String> data = entry.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              data['type'].toString(),
                              style: notoSans.w500.black.get12,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              data['rate'].toString(),
                              style: notoSans.w500.black.get12
                                  .textDecoration(TextDecoration.underline),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              data['tenure'].toString(),
                              style: notoSans.w500.black.get12
                                  .textDecoration(TextDecoration.underline),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 15,
                              ),
                              onPressed: () {
                                controller.variableInterestRateList
                                    .removeAt(index);
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          height: 35.h,
                          style: notoSans.w500.get12.white,
                          "Save",
                          onPressed: () {
                            if (rateController.text.isNotEmpty &&
                                tenureController.text.isNotEmpty) {
                              int enteredMonth =
                                  int.parse(tenureController.text);
                              if (enteredMonth <
                                  num.parse(widget.editData?.dbData
                                          ?.loanProfile!.months ??
                                      "")) {
                                controller.addVariableInterestRate(
                                  index!,
                                  controller.variableInterestRateType.value,
                                  rateController.text,
                                  tenureController.text,
                                );
                                controller.variableInterestRateList.add({
                                  'type':
                                      controller.variableInterestRateType.value,
                                  'rate': rateController.text,
                                  'tenure': tenureController.text,
                                });
                                Get.back();
                              } else {
                                showToast("Please enter a valid month.");
                              }
                            } else {
                              Get.back();
                            }
                          },
                          bg: AppColors.appColor,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          height: 35.h,
                          style: notoSans.w500.get12.appColor,
                          "Reset",
                          onPressed: () {
                            rateController.clear();
                            tenureController.clear();
                            controller.variableInterestRateType.value;
                            controller.addVariableInterestRate(
                              index!,
                              controller.variableInterestRateType.value,
                              rateController.text,
                              tenureController.text,
                            );
                          },
                          bg: AppColors.stoicWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInterestSaverAccountDialog(
      BuildContext context, LoanProfileController controller, int? index) {
    final TextEditingController principalController = TextEditingController();
    principalController.text = controller.getInterestSaverAccountValue() ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Interest Saver Account',
                      style: notoSans.w600.get15.appColor,
                    ),
                  ),
                ),
                Text(
                  "This facility helps the borrower to deposit his surplus savings in a current account linked to his loan account. While calculating the interest, the bank deducts the balance in the current account from the borrower's outstanding principal.",
                  style: notoSans.w400.black.get12,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: AppTextFormField(
                    radioButton: false,
                    controller: principalController,
                    keyboardType: TextInputType.number,
                    hint: "Enter current account balance",
                    numFormater: [AmountFormatter()],
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
                          style: notoSans.w500.get12.white,
                          "Save",
                          onPressed: () {
                            if (principalController.text.isNotEmpty) {
                              String enteredAmountStr =
                                  principalController.text.replaceAll(',', '');
                              String loanAmountStr = widget
                                      .editData?.dbData?.loanProfile?.loanAmount
                                      ?.replaceAll(',', '') ??
                                  "";

                              // Convert the strings to double for comparison
                              double? enteredAmount =
                                  double.tryParse(enteredAmountStr);
                              double? loanAmount =
                                  double.tryParse(loanAmountStr);

                              if (enteredAmount != null && loanAmount != null) {
                                if (enteredAmount < loanAmount) {
                                  controller.setInterestSaverAccountValue(
                                      principalController.text);
                                  controller.addInterestSaverAccount(
                                      index!, principalController.text);
                                  Get.back();
                                } else {
                                  showToast("Please enter a valid Amount.");
                                }
                              } else {
                                showToast("Invalid number format.");
                              }
                            } else {
                              Get.back();
                            }
                          },
                          bg: AppColors.appColor,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          height: 35.h,
                          style: notoSans.w500.get12.appColor,
                          "Reset",
                          onPressed: () {
                            principalController.clear(); // Clear the text field
                            controller
                                .resetInterestSaverAccountValue(); // Clear stored value
                            controller.addInterestSaverAccount(
                              index!,
                              principalController.text,
                            );
                          },
                          bg: AppColors.stoicWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMoratoriumPeriodDialog(
      BuildContext context, LoanProfileController controller, int? index) {
    final TextEditingController tenureController = TextEditingController(
      text: controller.getMoratoriumTenure(index ?? 0),
    );
    final String initialMoratoriumPeriodType =
        controller.getMoratoriumPeriodType(index ?? 0);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Moratorium Period',
                      style: notoSans.w600.get15.appColor,
                    ),
                  ),
                ),
                Text(
                  "Interest payment in moratorium period?",
                  style: notoSans.w500.black.get12,
                ),
                AppDropdown(
                  options: controller.moratoriumPeriod,
                  value: initialMoratoriumPeriodType.isEmpty
                      ? controller.moratoriumPeriod.first
                      : initialMoratoriumPeriodType,
                  onChanged: (String? value) {
                    controller.moratoriumPeriodType.value = value!;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    "Moratorium Period (max: 2 yr)",
                    style: notoSans.w500.black.get12,
                  ),
                ),
                AppTextFormField(
                  radioButton: false,
                  controller: tenureController,
                  keyboardType: TextInputType.number,
                  numFormater: [FilteringTextInputFormatter.digitsOnly],
                  hint: "",
                  suffixIcon: Obx(() => buildToggle(controller)),
                  maxLength: 3,
                  autoValidation: false,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          height: 35.h,
                          style: notoSans.w500.get12.white,
                          "Save",
                          onPressed: () {
                            if (tenureController.text.isNotEmpty) {
                              int enteredValue =
                                  int.parse(tenureController.text);
                              if (controller.selectedPeriodIndex.value == 0) {
                                enteredValue *= 12;
                              }
                              if (enteredValue <
                                  num.parse(widget.editData?.dbData
                                          ?.loanProfile!.months ??
                                      "")) {
                                controller.addMoratoriumPeriod(
                                  index!,
                                  controller.moratoriumPeriodType.value,
                                  enteredValue.toString(),
                                );
                                Get.back();
                              } else {
                                showToast(
                                    "Please enter a valid number of months.");
                              }
                            } else {
                              Get.back();
                            }
                          },
                          bg: AppColors.appColor,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          height: 35.h,
                          style: notoSans.w500.get12.appColor,
                          "Reset",
                          onPressed: () {
                            if (index != null) {
                              controller.resetMoratoriumPeriod(index);
                              tenureController.clear();
                              controller.selectedPeriodIndex.value = 0;
                              controller.moratoriumPeriodType.value =
                                  controller.moratoriumPeriod.first;
                              controller.addMoratoriumPeriod(
                                index,
                                controller.moratoriumPeriodType.value,
                                tenureController.text,
                              );
                            }
                          },
                          bg: AppColors.stoicWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildToggle(LoanProfileController controller) {
    Widget buildText(ToggleList toggleItem, int index, bool isLast) {
      return Row(
        children: [
          Text(
            toggleItem.title,
            style: controller.selectedPeriodIndex.value == index
                ? notoSans.bold.appColor.get10
                : notoSans.gray.get10,
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
