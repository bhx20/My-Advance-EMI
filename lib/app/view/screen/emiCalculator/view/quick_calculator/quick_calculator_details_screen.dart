import 'package:advance_emi/app/utils/share_files/share_pdf.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/globle_widget.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../core/app_typography.dart';
import '../../../../../model/emi_result_model.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';

class QuickDetailsScreen extends StatefulWidget {
  final CalculateResult? emiResult;
  const QuickDetailsScreen({super.key, this.emiResult});

  @override
  State<QuickDetailsScreen> createState() => _QuickDetailsScreenState();
}

class _QuickDetailsScreenState extends State<QuickDetailsScreen> {
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
        titleText: "EMI Details",
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              size: 20.h,
            ),
            onPressed: () {
              showAdAndNavigate(() {
                SharePdf().shareEmiDetails(widget.emiResult);
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Obx(() => showAd.isTrue
          ? GoogleAdd.getInstance().showNative(isSmall: true)
          : const SizedBox()),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
              child: Table(
                border: TableBorder.all(
                    color: AppColors.appColor,
                    width: 1,
                    borderRadius: BorderRadius.circular(5)),
                children: [
                  buildTableRow("Amount", widget.emiResult?.loanAmount ?? ""),
                  buildTableRow("Interest %", widget.emiResult?.interest ?? ""),
                  buildTableRow(
                      "Period (Months)", widget.emiResult?.period ?? ""),
                  buildTableRow(
                      "Monthly EMI", widget.emiResult?.monthlyEmi ?? ""),
                  buildTableRow(
                      "Total Interest", widget.emiResult?.totalInterest ?? ""),
                  buildTableRow("Processing Fees",
                      widget.emiResult?.processingFees ?? ""),
                  buildTableRow(
                      "Total Payment", widget.emiResult?.totalPayment ?? ""),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: SizedBox(
                width: Get.width,
                child: FittedBox(
                  child: DataTable(
                      headingRowColor:
                          WidgetStateProperty.all(AppColors.appColor),
                      headingTextStyle: notoSans.w600.get13.white,
                      dividerThickness: 0.0,
                      columns: const [
                        DataColumn(label: Text('Month')),
                        DataColumn(label: Text('Principal')),
                        DataColumn(label: Text('Interest')),
                        DataColumn(label: Text('Balance')),
                      ],
                      rows: List.generate(widget.emiResult!.emiList!.length,
                          (index) {
                        var data = widget.emiResult!.emiList![index];
                        return DataRow(
                          cells: [
                            DataCell(Center(
                              child: Text(data.month.toString()),
                            )),
                            DataCell(Center(
                                child:
                                    Text(formatNumber(data.principal ?? 0.0)))),
                            DataCell(Center(
                                child:
                                    Text(formatNumber(data.interest ?? 0.0)))),
                            DataCell(Center(
                                child:
                                    Text(formatNumber(data.balance ?? 0.0)))),
                          ],
                        );
                      })),
                ),
              ),
            ),
            GoogleAdd.getInstance().showNative(),
          ],
        ),
      ),
    );
  }
}
