import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../model/local.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/bank_ifsc_controller.dart';
import 'branch_view.dart';

class CityView extends StatelessWidget {
  final String bankName;
  final String state;
  final List<CityData>? cities;
  const CityView({
    super.key,
    this.cities,
    required this.bankName,
    required this.state,
  });
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: BankIFSCController(),
        builder: (controller) {
          return AppScaffold(
              appBar: myAppBar(
                titleText: "$bankName Cities",
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    GoogleAdd.getInstance()
                        .showNative(isSmall: cities!.length < 8 ? true : false),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        itemCount: cities?.length,
                        itemBuilder: (context, index) {
                          var data = cities?[index];
                          return controller.commonTile(
                              cities?[index].name ?? "",
                              screen: BranchView(
                                  bankName: bankName,
                                  city: data?.name ?? "",
                                  state: state,
                                  branches: data!.branch));
                        }),
                  ],
                ),
              ));
        });
  }
}
