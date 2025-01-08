import 'package:advance_emi/app/component/google_add/google_advertise_repo/advertise_repo.dart';
import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_button/app_button.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/loan_profile_controller.dart';
import 'create_profile.dart';
import 'loan_details_view.dart';

class LoanProfileView extends StatefulWidget {
  const LoanProfileView({super.key});

  @override
  State<LoanProfileView> createState() => _LoanProfileViewState();
}

class _LoanProfileViewState extends State<LoanProfileView> {
  final LoanProfileController controller = Get.put(LoanProfileController());

  @override
  void initState() {
    super.initState();
    controller.getLoanData().then((value) => controller.updateFinalAmount());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        bottomNavigationBar: GoogleAdd.getInstance().showNative(isSmall: true),
        appBar: myAppBar(titleText: "My Loan Profile", actions: [
          Obx(() {
            if (controller.loanProfiles.isNotEmpty) {
              return IconButton(
                  onPressed: () {
                    showAdAndNavigate(
                        () => navigateTo(const CreateProfileView()));
                  },
                  icon: Icon(
                    Icons.add,
                    color: AppColors.black,
                    size: 20.h,
                  ));
            } else {
              return const SizedBox.shrink();
            }
          })
        ]),
        body: Obx(() {
          if (controller.loanProfiles.isEmpty) {
            return _noRecordFound();
          } else {
            return _profileData();
          }
        }));
  }

//==============================================================================
// ** Widget Function **
//==============================================================================

  Widget _noRecordFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/no_record_found.png",
            height: 50.h,
            width: 50.w,
            color: AppColors.black,
          ),
          Text(
            "No Record Found",
            style: notoSans.w500.get14.black,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            child: Text(
              "Your privacy is important to us. Rest assured that the information you provide in the Loan Profile section, including your bank name and account number, is not stored on any external servers or shared with third parties. All data is securely saved on your device’s local storage, ensuring you have full control. We do not have access to your personal data, so you can confidently use this feature to manage your loan profile.",
              textAlign: TextAlign.center,
              style: notoSans.get10.gray,
            ),
          ),
          GestureDetector(
            onTap: () {
              showAdAndNavigate(() => navigateTo(const CreateProfileView()));
            },
            child: Text(
              "Create Profile",
              style: notoSans.w400.appColor.get12
                  .textDecoration(TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Table(
            border: TableBorder.all(color: AppColors.appColor, width: 1),
            children: [
              _tableRow(label1: "Loan Amount", value1: "EMi"),
              _tableRow(
                  label1: formatNumber(controller.totalLoanAmount.toDouble()),
                  labelStyle: notoSans.red.w600.get14,
                  value1: formatNumber(controller.totalEmi.toDouble()),
                  valueStyle: notoSans.red.w600.get14),
              _tableRow(label1: "Amount Paid", value1: "Outstanding Amount"),
              _tableRow(
                  label1: formatNumber(controller.totalAmountPaid.toDouble()),
                  labelStyle: notoSans.red.w600.get14,
                  value1: formatNumber(
                      controller.totalOutstandingAmount.toDouble()),
                  valueStyle: notoSans.red.w600.get14),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.loanProfiles.length,
            itemBuilder: (context, index) {
              final profile = controller.loanProfiles[index];
              Color color = AppColors.flaxBLOOM.withOpacity(0.3);
              return GestureDetector(
                onTap: () {
                  showAdAndNavigate(() => navigateTo(() =>
                      LoanDetailsView(loanProfile: profile, index: index)));
                },
                onLongPress: () async {
                  _buildDeleteDialog(context, index);
                },
                child: Container(
                  width: Get.width,
                  margin: EdgeInsets.only(top: 1.h),
                  decoration: BoxDecoration(color: color),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    profile.dbData?.loanProfile?.loanName ?? "",
                                    style: notoSans.w600.get12.black,
                                  ),
                                  Text(
                                      "  (${profile.dbData?.loanProfile?.loanAccountNo ?? ""})",
                                      style: notoSans.w600.get12.black),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: AppColors.orchid,
                              size: 10.h,
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Amount: ${profile.dbData?.loanProfile?.loanAmount ?? ""}",
                                style: notoSans.w400.gray.get10,
                              ),
                              Text(
                                  "EMI: ${profile.dbData?.loanProfile?.emi ?? ""}",
                                  style: notoSans.w400.gray.get10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Future<dynamic> _buildDeleteDialog(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Container(
            height: 180.h,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Delete Profile",
                  style: notoSans.w500.black.get16,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Are you sure you want to delete this Loan Profile?",
                  textAlign: TextAlign.center,
                  style: notoSans.w400.black.get12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton(
                      "CANCEL",
                      style: notoSans.w400.white.get12,
                      height: 30.h,
                      width: 100.w,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    AppButton(
                      "OK",
                      style: notoSans.w400.white.get12,
                      height: 30.h,
                      width: 100.w,
                      onPressed: () {
                        controller.deleteLoanProfile(
                          controller.loanProfiles[index].dbData?.dbId ?? 0,
                        );
                        Get.back();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TableRow _tableRow({
    required String label1,
    TextStyle? labelStyle,
    required String value1,
    TextStyle? valueStyle,
  }) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            padding: EdgeInsets.all(8.h),
            child: Text(
              label1,
              textAlign: TextAlign.center,
              style: labelStyle ?? notoSans.black.w400.get12,
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: EdgeInsets.all(8.h),
            child: Text(
              value1,
              textAlign: TextAlign.center,
              style: valueStyle ?? notoSans.black.w400.get12,
            ),
          ),
        ),
      ],
    );
  }
}
