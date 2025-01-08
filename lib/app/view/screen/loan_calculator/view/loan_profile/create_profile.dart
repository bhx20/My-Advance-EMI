import 'package:advance_emi/app/core/app_colors.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_button/app_button.dart';
import '../../../../../component/app_textformfield/common_field.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../model/loan_profile_model.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../../utils/validation/validator.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/loan_profile_controller.dart';

class CreateProfileView extends StatefulWidget {
  final LoanProfileData? editData;
  const CreateProfileView({super.key, this.editData});

  @override
  State<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> {
  late final LoanProfileController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.find<LoanProfileController>();
    if (widget.editData != null) {
      controller.editProfileData(widget.editData);
    } else {
      controller.resetData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoanProfileController(),
      builder: (controller) {
        return AppScaffold(
            appBar: myAppBar(
              titleText:
                  widget.editData != null ? "Edit Profile" : "Loan Profile",
            ),
            bottomNavigationBar:
                GoogleAdd.getInstance().showNative(isSmall: true),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    AppTextFormField(
                      controller: controller.loanNameController,
                      title: "Loan Name",
                      radioButton: false,
                      keyboardType: TextInputType.name,
                      validate: Validators().validateLoanName,
                    ),
                    AppTextFormField(
                      controller: controller.loanAccountNoController,
                      title: "Loan A/C No",
                      radioButton: false,
                      keyboardType: TextInputType.number,
                      validate: Validators().validateLoanAcNUmber,
                    ),
                    AppTextFormField(
                      controller: controller.bankNameController,
                      title: "Bank Name",
                      radioButton: false,
                      keyboardType: TextInputType.name,
                      validate: Validators().validateBankName,
                    ),
                    AppTextFormField(
                      controller: controller.amountController,
                      title: "Amount",
                      radioButton: false,
                      keyboardType: TextInputType.number,
                      numFormater: [AmountFormatter()],
                    ),
                    AppTextFormField(
                      controller: controller.rateController,
                      title: "Interest Rate%",
                      radioButton: false,
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      numFormater: [Max100Formatter()],
                    ),
                    AppTextFormField(
                      controller: controller.periodController,
                      title: "Tenure(In Month)",
                      radioButton: false,
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      numFormater: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    AppTextFormField(
                      readOnly: true,
                      controller: controller.emiController,
                      title: "EMI",
                      radioButton: false,
                      fillColor: AppColors.white,
                      keyboardType: TextInputType.number,
                    ),
                    AppTextFormField(
                      controller: controller.processingFeesController,
                      title: "Processing Fees",
                      radioButton: false,
                      keyboardType: TextInputType.number,
                      numFormater: [AmountFormatter()],
                      textInputAction: TextInputAction.done,
                    ),
                    AppTextFormField(
                      readOnly: true,
                      title: "Loan Date",
                      fillColor: AppColors.white,
                      radioButton: false,
                      controller: controller.loanDateController,
                      onTap: () {
                        controller.selectDate(
                            context,
                            controller.selectedLoanDate,
                            controller.loanDateController);
                      },
                    ),
                    AppTextFormField(
                      controller: controller.firstEmiController,
                      fillColor: AppColors.white,
                      readOnly: true,
                      title: "First EMI Date",
                      onTap: () {
                        controller.selectDate(
                            context,
                            controller.selectedFirstEmiDate,
                            controller.firstEmiController);
                      },
                      radioButton: false,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: AppButton(
                        "Save",
                        onPressed: () {
                          showAdAndNavigate(() {
                            controller.saveLoanProfile(
                                loanProfileId: widget.editData?.dbData?.dbId);
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
