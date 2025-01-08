import 'package:advance_emi/app/core/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../model/bank_holiday_model.dart';
import '../../../../widgets/generated_scaffold.dart';

class HolidayList extends StatefulWidget {
  final String title;
  final List<ListElement>? list;
  const HolidayList({super.key, this.list, required this.title});

  @override
  State<HolidayList> createState() => _HolidayListState();
}

class _HolidayListState extends State<HolidayList> {
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
    return AppScaffold(
        appBar: myAppBar(
          titleText: widget.title,
        ),
        bottomNavigationBar: Obx(() => showAd.isTrue
            ? GoogleAdd.getInstance().showNative(isSmall: true)
            : const SizedBox()),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.list!.length,
                  itemBuilder: (context, index) {
                    return _subTitleItem(index);
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1 / 0.4),
                ),
              ),
              GoogleAdd.getInstance().showNative()
            ],
          ),
        ));
  }

  Widget _subTitleItem(int index) {
    return ListTile(
        title: Text("- ${widget.list?[index].holiday}",
            maxLines: 2, style: notoSans.black.bold.get13),
        subtitle: Text("  ${widget.list?[index].date}", style: notoSans.get12));
  }
}
