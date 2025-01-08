import 'package:advance_emi/app/component/app_textformfield/common_field.dart';
import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:advance_emi/app/view/widgets/generated_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../core/app_colors.dart';
import '../controller/search_data_controller.dart';

class SearchDataView extends StatelessWidget {
  const SearchDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SearchDataController());
    return AppScaffold(
      bottomNavigationBar: GoogleAdd.getInstance().showNative(isSmall: true),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              AppTextFormField(
                scaleY: 1,
                controller: c.controller,
                focusNode: c.focusNode,
                keyboardType: TextInputType.text,
                hint: "Search Calculators",
                suffixIcon: IconButton(
                  onPressed: () {
                    c.controller.clear(); // Clear search query
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: EdgeInsets.only(top: 10.h),
                    itemCount: c.filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = c.filteredItems[index];
                      return InkWell(
                        onTap: () {
                          showAdAndNavigate(() => navigateTo(item.route));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.h),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                item.icon,
                                height: 36.h,
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.h),
                                      child: Text(
                                        item.title,
                                        textAlign: TextAlign.center,
                                        style: notoSans.get10.w500.blackPANTHER,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: AppColors.orchid,
                                size: 10.h,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
