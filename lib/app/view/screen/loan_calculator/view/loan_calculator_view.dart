import 'package:advance_emi/app/core/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/app_colors.dart';
import '../../../../utils/utils.dart';
import '../controller/loan_type_controller.dart';

class LoanCalculatorView extends StatefulWidget {
  const LoanCalculatorView({super.key});

  @override
  State<LoanCalculatorView> createState() => _LoanCalculatorViewState();
}

class _LoanCalculatorViewState extends State<LoanCalculatorView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: LoanCalculatorController(),
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.w, top: 15.h, bottom: 5.h),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Loan Calculation",
                      style: notoSans.w500.get12.blackPANTHER,
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: 0.8)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          controller.loanTypeItem.length,
                          (index) => GestureDetector(
                                onTap: () {
                                  showAdAndNavigate(() => navigateTo(
                                      controller.loanTypeItem[index].route));
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      controller.loanTypeItem[index].icon,
                                      height: 40.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 6.h),
                                      child: SizedBox(
                                        width: 80,
                                        child: Text(
                                          controller.loanTypeItem[index].title,
                                          textAlign: TextAlign.center,
                                          style: notoSans.get9.w400,
                                          maxLines: 2,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
