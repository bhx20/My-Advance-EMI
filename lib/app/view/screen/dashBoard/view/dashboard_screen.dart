import 'package:advance_emi/app/model/config_model.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:advance_emi/app/view/screen/leadingBanner/view/leading_banners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../component/app_bar/my_app_bar.dart';
import '../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/constant.dart';
import '../../../widgets/dialogs/app_dialog.dart';
import '../../../widgets/generated_scaffold.dart';
import '../../bank_calculation/view/bank_calculation_view.dart';
import '../../emiCalculator/view/emi_header_view.dart';
import '../../gst_and_vat/view/gst_and_vat.dart';
import '../../loan_calculator/view/loan_calculator_view.dart';
import '../../other_calculators/other_calculators_view.dart';
import '../../other_service/view/other_service_view.dart';
import '../../search/view/search_data_view.dart';
import '../controller/dashboard_controller.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({super.key});

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  final DashBoardController homeController = Get.put(DashBoardController());
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showExitConfirmationDialog(context);
      },
      child: AppScaffold(
        sKey: drawerKey,
        appBar: myAppBar(titleText: "Home", isBack: false, actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: AppColors.black,
                size: 20.h,
              ),
              onPressed: () {
                showAdAndNavigate(() {
                  navigateTo(const SearchDataView());
                });
              },
            ),
          ),
        ]),
        bottomNavigationBar: Obx(() => showAd.isTrue
            ? GoogleAdd.getInstance().showNative(isSmall: true)
            : const SizedBox()),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: GetBuilder(
              init: DashBoardController(),
              builder: (controller) {
                return Obx(() {
                  var data = controller.config.dbData.value.dashBoardElement;
                  data?.sort((a, b) => a.sort!.compareTo(b.sort!));
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data?.length,
                            itemBuilder: (context, i) {
                              return dashboardElement(data![i], controller);
                            }),
                        GoogleAdd.getInstance().showNative(),
                      ],
                    ),
                  );
                });
              }),
        ),
      ),
    );
  }

  Widget dashboardElement(
    DashBoardElement data,
    DashBoardController controller,
  ) {
    if (data.id == "leading_banners") {
      return show(data.show!, const LeadingSliderView());
    } else if (data.id == "emi_calculator") {
      return show(data.show!, withMargin(child: const EmiCalculatorView()));
    } else if (data.id == "loan_calculator") {
      return show(data.show!, withMargin(child: const LoanCalculatorView()));
    } else if (data.id == "bank_calculator") {
      return show(data.show!, withMargin(child: const BankCalculationScreen()));
    } else if (data.id == "gst_vat_calculator") {
      return show(data.show!, withMargin(child: const GSTAndVatScreen()));
    } else if (data.id == "other_calculator") {
      return show(data.show!, withMargin(child: const OtherCalculatorsView()));
    } else if (data.id == "other_service") {
      return show(data.show!, withMargin(child: const OtherServiceView()));
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget withMargin({Widget? child}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w), child: child);
  }

  Widget show(bool show, Widget child) {
    if (show == true) {
      return child;
    } else {
      return const SizedBox.shrink();
    }
  }
}
