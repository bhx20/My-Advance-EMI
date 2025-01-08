import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../component/app_bar/my_app_bar.dart';
import '../../../../component/app_button/app_button.dart';
import '../../../../component/globle_widget.dart';
import '../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../core/app_colors.dart';
import '../../../../model/emi_result_model.dart';
import '../../../widgets/generated_scaffold.dart';
import '../../emiCalculator/view/emi_calculator/emi_details_screen.dart';
import '../controller/history_controller.dart';

class HistoryScreenView extends StatefulWidget {
  final List<CalculateResult> calculateData;
  const HistoryScreenView({super.key, required this.calculateData});

  @override
  State<HistoryScreenView> createState() => _HistoryScreenViewState();
}

class _HistoryScreenViewState extends State<HistoryScreenView> {
  final HistoryController controller = Get.put(HistoryController());

  @override
  void initState() {
    controller.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar: GoogleAdd.getInstance().showNative(isSmall: true),
      appBar: myAppBar(titleText: "History", actions: [
        Obx(() {
          if (controller.advanceEmi.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: IconButton(
                icon: Icon(
                  Icons.delete_sweep_outlined,
                  color: AppColors.black,
                  size: 20.h,
                ),
                onPressed: () {
                  warning(
                    context,
                    content: "Are you sure, You want to clear your data?",
                    leadingTap: () {
                      showAdAndNavigate(() {
                        controller.deleteAllData();
                        Get.back();
                      });
                    },
                  );
                },
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        })
      ]),
      body: Obx(() {
        if (controller.advanceEmi.isEmpty) {
          return _noRecordFound();
        } else {
          return _historyData();
        }
      }),
    );
  }

  Widget _historyData() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: ListView.builder(
        itemCount: widget.calculateData.length,
        itemBuilder: (context, index) {
          final history = widget.calculateData[index];
          DateTime? createdAtDate =
              DateTime.tryParse(history.dbData?.advanceEmi?.createdAt ?? "");
          String formattedDate = createdAtDate != null
              ? DateFormat('dd MMM yyyy').format(createdAtDate)
              : '';

          return GestureDetector(
            onLongPress: () async {
              _buildDeleteDialog(context, history, index);
            },
            onTap: () {
              showAdAndNavigate(() {
                navigateTo(EmiDetailsScreen(
                  emiResult: history.dbData?.advanceEmi,
                ));
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.border,
                    width: 1.w,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 35.h,
                      width: 35.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.appColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Center(
                          child: Icon(
                            Icons.history,
                            color: AppColors.white,
                            size: 20.h,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              formattedDate,
                              style: notoSans.fLYbyNight.w700.get10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Amount: ",
                                      style: notoSans.w600.get10.fLYbyNight,
                                    ),
                                    TextSpan(
                                      text:
                                          "${history.dbData?.advanceEmi?.loanAmount}  (${history.dbData?.advanceEmi?.interest}%)",
                                      style: notoSans.w400.get10.fLYbyNight,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              "${history.dbData?.advanceEmi?.period} Months",
                              style: notoSans.w600.get10.fLYbyNight,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: AppColors.orchid,
                      size: 12.h,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> _buildDeleteDialog(
      BuildContext context, CalculateResult history, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Container(
            height: 160.h,
            width: MediaQuery.of(context).size.width * 0.7,
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
                  "Delete History",
                  style: notoSans.w500.black.get16,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Are you sure you want to delete this History?",
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
                        controller.deleteData(history.dbData?.dbId ?? 0);
                        setState(() {
                          widget.calculateData.removeAt(index);
                        });
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

  Widget _noRecordFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/no_record_found.png",
            height: 50.h,
            width: 50.w,
            color: AppColors.gray,
          ),
          Text(
            "No Record Found",
            style: notoSans.w500.get14.gray,
          ),
        ],
      ),
    );
  }
}
