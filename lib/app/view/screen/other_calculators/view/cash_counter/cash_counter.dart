import 'package:advance_emi/app/core/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_textformfield/common_field.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../../utils/num_to_word/num_to_word.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/cash_counter_controller.dart';

class CashCounterView extends StatelessWidget {
  const CashCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CashCounterController>(
        init: CashCounterController(),
        builder: (controller) {
          return AppScaffold(
            appBar: myAppBar(titleText: "Cash Counter".toUpperCase(), actions: [
              IconButton(
                  onPressed: controller.resetData,
                  icon: const Icon(
                    Icons.restart_alt_outlined,
                    color: AppColors.black,
                    size: 25,
                  ))
            ]),
            bottomNavigationBar:
                GoogleAdd.getInstance().showNative(isSmall: true),
            body: Column(
              children: [
                _grandTotal(controller),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.cashList.length,
                    padding: EdgeInsets.only(top: 5.h),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50.w,
                              child: controller
                                          .cashList[index].currency.value ==
                                      0
                                  ? AppTextFormField(
                                      topPadding: 0,
                                      maxLength: 4,
                                      textInputAction: TextInputAction.done,
                                      inputStyle: notoSans.w500.get11,
                                      radioButton: false,
                                      textAlign: TextAlign.center,
                                      numFormater: [NumericInputFormatter()],
                                      controller: controller.customController,
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          controller.customAmount.value = 0;
                                          controller.updateTotalAndGrandTotal();
                                        } else {
                                          controller.customAmount.value =
                                              int.parse(value);
                                          controller.updateTotalAndGrandTotal();
                                        }
                                      })
                                  : Text(
                                      controller.cashList[index].currency.value
                                          .toString(),
                                      style: notoSans.w500.get11,
                                    ),
                            ),
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.w, right: 10.w),
                                        child: Text(
                                          "x",
                                          style: notoSans.bold.get12,
                                        ),
                                      ),
                                      _inputField(controller, index),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.w, right: 5.w),
                                        child: Text("=",
                                            style: notoSans.bold.get12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Obx(() => Text(
                                  formatText(
                                      controller.cashList[index].total.value),
                                  style: notoSans.w500.get11,
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _inputField(CashCounterController controller, int index) {
    return SizedBox(
      width: 130,
      child: AppTextFormField(
        topPadding: 0,
        maxLength: 4,
        textInputAction: TextInputAction.done,
        inputStyle: notoSans.w500.get11,
        radioButton: false,
        prefix: _actionButton(
            icon: Icons.remove,
            onTap: () {
              controller.decreaseCounter(index);
            }),
        suffixIcon: _actionButton(
            icon: Icons.add,
            onTap: () {
              controller.increaseCounter(index);
            }),
        controller: controller.cashList[index].count,
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (value.isNotEmpty) {
            controller.calculateCounter(index, int.parse(value));
          } else {
            controller.cashList[index].total.value = 0;
            controller.updateTotalAndGrandTotal();
          }
        },
      ),
    );
  }

  Widget _actionButton(
      {required IconData icon, required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, color: AppColors.black, size: 12),
      ),
    );
  }

  Widget _grandTotal(CashCounterController controller) {
    return Container(
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppColors.border, width: 0.8))),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.h, right: 20.w, top: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Cash:",
                    style: notoSans.get10.black.w500,
                  ),
                  Obx(
                    () => Text(
                      formatText(controller.grandTotal.value),
                      style: notoSans.get16.black.bold.space09,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 30.w),
                    child: Obx(
                      () => Text(
                        numToWordsIndia(controller.grandTotal.value.round()),
                        style: notoSans.get8.black.bold.space09,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Total Notes:",
                  style: notoSans.get10.black.w500,
                ),
                Obx(
                  () => Text(
                    formatText(controller.totalNotes.value),
                    style: notoSans.get16.black.bold.space09,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
