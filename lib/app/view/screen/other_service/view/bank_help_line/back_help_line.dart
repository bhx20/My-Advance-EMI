import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_textformfield/common_field.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/bank_helpline_controller.dart';

class BankHelpLineView extends StatefulWidget {
  const BankHelpLineView({super.key});

  @override
  State<BankHelpLineView> createState() => _BankHelpLineViewState();
}

class _BankHelpLineViewState extends State<BankHelpLineView> {
  final ScrollController _scrollController = ScrollController();
  RxBool showAd = true.obs;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <= 0) {
        showAd(true);
      } else {
        showAd(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: BankHelpLineController(),
        builder: (controller) {
          return AppScaffold(
              appBar: myAppBar(
                titleText: "Bank Help Line",
              ),
              bottomNavigationBar: Obx(() => showAd.isTrue
                  ? GoogleAdd.getInstance().showNative(isSmall: true)
                  : const SizedBox()),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: AppTextFormField(
                      controller: controller.searchController,
                      prefix: const Icon(Icons.search),
                      hint: "Search Bank",
                      onChanged: controller.filterSearchResults,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Obx(
                          () => ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              itemCount: controller.filteredBankList.length,
                              itemBuilder: (context, index) {
                                var data = controller.filteredBankList[index];
                                return ListTile(
                                  title: Text(
                                    data.title ?? "",
                                    style: notoSans.bold.get13.black,
                                  ),
                                  subtitle: Text(
                                    data.number ?? "",
                                    style: notoSans.w400.get12,
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        showAdAndNavigate(() {
                                          controller
                                              .launchDialPad(data.number ?? "");
                                        });
                                      },
                                      icon: const Icon(Icons.phone)),
                                );
                              }),
                        ),
                        GoogleAdd.getInstance().showNative()
                      ],
                    ),
                  ))
                ],
              ));
        });
  }
}
