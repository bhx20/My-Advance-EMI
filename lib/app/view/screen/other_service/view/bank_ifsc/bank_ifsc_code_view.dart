import 'package:advance_emi/app/view/screen/other_service/view/bank_ifsc/state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_textformfield/common_field.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/bank_ifsc_controller.dart';

class BankIFSCCodeView extends StatefulWidget {
  const BankIFSCCodeView({super.key});

  @override
  State<BankIFSCCodeView> createState() => _BankIFSCCodeViewState();
}

class _BankIFSCCodeViewState extends State<BankIFSCCodeView> {
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
        init: BankIFSCController(),
        builder: (controller) {
          return AppScaffold(
            appBar: myAppBar(
              titleText: "Bank IFSC Code",
            ),
            bottomNavigationBar: Obx(() => showAd.isTrue
                ? GoogleAdd.getInstance().showNative(isSmall: true)
                : const SizedBox()),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextFormField(
                    prefix: const Icon(Icons.search),
                    controller: controller.searchBankController,
                    keyboardType: TextInputType.text,
                    hint: "Search Bank",
                    onChanged: controller.filterSearchResults,
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
                            itemCount: controller.filteredIfscList.length,
                            itemBuilder: (context, index) {
                              return controller.commonTile(
                                  controller.filteredIfscList[index],
                                  isLeading: true,
                                  screen: StateView(
                                    filename:
                                        controller.filteredIfscList[index],
                                  ));
                            }),
                      ),
                      GoogleAdd.getInstance().showNative()
                    ],
                  ),
                ))
              ],
            ),
          );
        });
  }
}
