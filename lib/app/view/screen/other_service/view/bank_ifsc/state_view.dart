import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/globle_widget.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../model/local.dart';
import '../../../../widgets/generated_scaffold.dart';
import '../../controller/bank_ifsc_controller.dart';
import 'city_view.dart';

class StateView extends StatefulWidget {
  final String filename;
  const StateView({
    super.key,
    required this.filename,
  });

  @override
  State<StateView> createState() => _StateViewState();
}

class _StateViewState extends State<StateView> {
  var isLoading = true.obs;
  List<IfscData> ifscBankData = [];
  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  loadAsset() async {
    isLoading(true);
    String assetData =
        await rootBundle.loadString('assets/bank_ifsc/${widget.filename}.txt');

    List<String> data = assetData.split('\n');
    List<String> lines = data[3].split('**');

    for (String line in lines) {
      if (line.trim().isNotEmpty) {
        List<String> locationParts = line.split('->');
        String state = locationParts[0].trim();
        String city = locationParts[1].trim();
        String branch = locationParts[2].trim();
        String fullAddress = locationParts[3].trim();

        BranchData branchData = BranchData(name: branch, address: fullAddress);
        CityData cityData = CityData(name: city, branch: [branchData]);
        IfscData ifscData = IfscData(state: state, city: [cityData]);

        int stateIndex = ifscBankData.indexWhere((item) => item.state == state);
        if (stateIndex != -1) {
          int cityIndex = ifscBankData[stateIndex]
              .city!
              .indexWhere((item) => item.name == city);
          if (cityIndex != -1) {
            ifscBankData[stateIndex].city![cityIndex].branch!.add(branchData);
          } else {
            ifscBankData[stateIndex].city!.add(cityData);
          }
        } else {
          ifscBankData.add(ifscData);
        }
      }
    }
    isLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: BankIFSCController(),
        builder: (controller) {
          return AppScaffold(
              appBar: myAppBar(
                titleText: "${widget.filename} States",
              ),
              body: Obx(() {
                if (isLoading.isTrue) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Column(
                        children: List.generate(
                            15,
                            (index) => SimmerLoader(
                                  radius: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5.h, horizontal: 5.w),
                                )),
                      ),
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        GoogleAdd.getInstance().showNative(
                            isSmall: ifscBankData.length < 8 ? true : false),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            itemCount: ifscBankData.length,
                            itemBuilder: (context, index) {
                              return controller.commonTile(
                                  ifscBankData[index].state ?? "",
                                  screen: CityView(
                                    bankName: widget.filename,
                                    state: ifscBankData[index].state ?? "",
                                    cities: ifscBankData[index].city,
                                  ));
                            }),
                      ],
                    ),
                  );
                }
              }));
        });
  }
}
