import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../model/local.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/bank_ifsc_controller.dart';
import 'ifsc_info_view.dart';

class BranchView extends StatelessWidget {
  final String bankName;
  final String state;
  final String city;
  final List<BranchData>? branches;
  const BranchView({
    super.key,
    this.branches,
    required this.bankName,
    required this.state,
    required this.city,
  });
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: BankIFSCController(),
        builder: (controller) {
          return AppScaffold(
              appBar: myAppBar(
                titleText: "$bankName Branches",
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    GoogleAdd.getInstance().showNative(
                        isSmall: branches!.length < 8 ? true : false),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        itemCount: branches?.length,
                        itemBuilder: (context, index) {
                          var data = branches?[index];
                          return controller.commonTile(
                              branches?[index].name ?? "",
                              screen: IfscInfoView(
                                bankName: bankName,
                                address: data?.address ?? "",
                                state: state,
                                city: city,
                                branch: data?.name ?? "",
                              ));
                        }),
                  ],
                ),
              ));
        });
  }
}
