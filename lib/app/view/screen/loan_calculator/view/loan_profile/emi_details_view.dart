import 'dart:io';

import 'package:advance_emi/app/utils/utils.dart';
import 'package:cr_file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart ' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/globle_widget.dart';
import '../../../../../component/google_add/InitialController.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../component/toast/app_toast.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../core/app_typography.dart';
import '../../../../../model/loan_profile_model.dart';
import '../../../../../utils/num_converter/num_converter.dart';
import '../../../../../utils/num_formater/num_formater.dart';
import '../../../../widgets/generated_scaffold.dart';

class EmiDetailsView extends StatefulWidget {
  final LoanProfileData? emiResult;
  const EmiDetailsView({super.key, this.emiResult});

  @override
  State<EmiDetailsView> createState() => _EmiDetailsViewState();
}

class _EmiDetailsViewState extends State<EmiDetailsView> {
  final ScrollController _scrollController = ScrollController();
  RxBool showAd = true.obs;
  late Uint8List imageData;

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
    double? totalPayment;

    if (widget.emiResult?.dbData?.loanProfile?.loanAmount != null &&
        widget.emiResult?.totalInterest != null) {
      double loanAmount = convertToDouble(
          widget.emiResult?.dbData?.loanProfile!.loanAmount ?? "0.0");
      double totalInterest =
          convertToDouble(widget.emiResult!.totalInterest.toString());
      totalPayment = loanAmount + totalInterest;
    } else {
      totalPayment = null;
    }
    return AppScaffold(
      appBar: myAppBar(
        titleText: "EMI Details",
        isBack: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: AppColors.black,
              size: 20.h,
            ),
            onPressed: () {
              showAdAndNavigate(() {
                shareEmiDetailsView(widget.emiResult);
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
                  buildTableRow(
                      "Amount",
                      widget.emiResult?.dbData?.loanProfile!.loanAmount ??
                          "0.0"),
                  buildTableRow(
                      "Interest %",
                      widget.emiResult?.dbData?.loanProfile!.interestRate ??
                          "0.0"),
                  buildTableRow("Period (Months)",
                      widget.emiResult?.dbData?.loanProfile!.months ?? "0.0"),
                  buildTableRow("Monthly EMI",
                      widget.emiResult?.dbData?.loanProfile!.emi ?? "0.0"),
                  buildTableRow(
                      "Total Interest", widget.emiResult?.totalInterest ?? ""),
                  buildTableRow(
                      "Processing Fees",
                      widget.emiResult?.dbData?.loanProfile!.processingFees ??
                          "0.0"),
                  buildTableRow(
                      "Total Payment", formatNumber(totalPayment ?? 0.0)),
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
                        DataColumn(label: Text('Pre Payment')),
                        DataColumn(label: Text('Variable\nInterest Rate')),
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
                              child: Text(formatNumber(
                                  convertToDouble(data.principal))),
                            )),
                            DataCell(Center(
                              child: Text(
                                  formatNumber(convertToDouble(data.interest))),
                            )),
                            DataCell(Center(
                                child: Text(data.prePayment != "0"
                                    ? data.prePayment
                                    : "0"))),
                            DataCell(Center(
                              child: Text(formatNumber(
                                  convertToDouble(data.variableRate))),
                            )),
                            DataCell(Center(
                              child: Text(
                                  formatNumber(convertToDouble(data.balance))),
                            )),
                          ],
                        );
                      })),
                ),
              ),
            ),
            GoogleAdd.getInstance().showNative()
          ],
        ),
      ),
    );
  }

  Future<void> shareEmiDetailsView(LoanProfileData? emiResult) async {
    bool permissionGranted =
        await CRFileSaver.requestWriteExternalStoragePermission();

    if (permissionGranted) {
      // Now you can safely proceed with loading the image and sharing the PDF
      await _loadImage().then((value) => _sharePdf(emiResult));
    } else {
      // If permission was not granted, you can handle it here
      PermissionStatus status = await Permission.storage.status;

      if (status.isDenied ||
          status.isRestricted ||
          status.isPermanentlyDenied) {
        status = await Permission.storage.request();
      }

      if (status.isGranted) {
        await _loadImage().then((value) => _sharePdf(emiResult));
      } else {
        bool opened = await openAppSettings();
        if (!opened) {
          showToast(
              "Could not open app settings. Please enable storage permission manually.");
        }
      }
    }
  }

  Future<void> _loadImage() async {
    final ByteData data = await rootBundle.load('assets/icons/share_logo.png');
    imageData = data.buffer.asUint8List();
  }

  Future<void> _sharePdf(LoanProfileData? emiResult) async {
    try {
      final pdf = pw.Document();
      DateTime now =
          DateTime.parse(emiResult?.dbData?.dbCreatedAt.toString() ?? "");
      final formattedDate = "${now.day}/${now.month}/${now.year}";
      final formattedTime = "${now.hour}:${now.minute}";

      pdf.addPage(
        pw.MultiPage(
            maxPages: 50,
            header: (pw.Context context) {
              if (context.pageNumber == 1) {
                return pw.Row(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Container(
                        width: 40.w,
                        height: 40.h,
                        child: pw.Image(
                          pw.MemoryImage(imageData),
                        ),
                      ),
                    ),
                    pw.Text(
                      'EMI Calculator',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(AppColors.appColor.value),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Generated At:',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromInt(AppColors.appColor.value),
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            formattedDate,
                            style: pw.TextStyle(
                              fontSize: 11,
                              color: PdfColor.fromInt(AppColors.appColor.value),
                            ),
                          ),
                          pw.Text(
                            formattedTime,
                            style: pw.TextStyle(
                              fontSize: 11,
                              color: PdfColor.fromInt(AppColors.appColor.value),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return pw.SizedBox.shrink();
            },
            build: (pw.Context context) {
              return [
                pw.TableHelper.fromTextArray(
                  border: pw.TableBorder.all(
                    color: PdfColor.fromInt(AppColors.appColor.value),
                  ),
                  headers: ['Data', 'Value'],
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                  headerDecoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(AppColors.appColor.value)),
                  data: [
                    ['Amount', emiResult?.dbData?.loanProfile?.loanAmount],
                    [
                      'Interest %',
                      emiResult?.dbData?.loanProfile?.interestRate
                    ],
                    ['Period (Months)', emiResult?.dbData?.loanProfile?.months],
                    ['Monthly EMI', emiResult?.dbData?.loanProfile?.emi],
                    ['Total Interest', emiResult?.totalInterest],
                    [
                      'Processing Fees',
                      emiResult?.dbData?.loanProfile?.processingFees
                    ],
                    ['Total Payment', "totalPayment"],
                  ],
                ),
                pw.SizedBox(height: 60.h),
                _buildEMIScheduleTable(emiResult),
              ];
            }),
      );

      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final tempFile = File('$tempPath/EMI-Details.pdf');
      await tempFile.writeAsBytes(await pdf.save());

      if (await tempFile.exists()) {
        await Share.shareXFiles(
          [XFile(tempFile.path)],
          subject:
              'Generate BY EMI Calculators\n\n${Get.find<InitialController>().dbData.value.shareLink ?? ""}',
        );
      } else {
        showToast("PDF file could not be generated.");
      }
    } catch (e) {
      showToast("An error occurred while sharing the PDF.");
    }
  }

  pw.Widget _buildEMIScheduleTable(LoanProfileData? emiResult) {
    return pw.Table(
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColor.fromInt(AppColors.appColor.value),
            ),
            color: PdfColor.fromInt(AppColors.appColor.value),
          ),
          children: [
            _buildTableCell('Month', isHeader: true),
            _buildTableCell('Principal', isHeader: true),
            _buildTableCell('Interest', isHeader: true),
            _buildTableCell('Pre Payment', isHeader: true),
            _buildTableCell('Variable\nInterest Rate', isHeader: true),
            _buildTableCell('Balance', isHeader: true),
          ],
        ),
        ...List.generate(
            emiResult!.emiList!.length,
            (index) => pw.TableRow(
                  decoration: pw.BoxDecoration(
                    border: pw.TableBorder.all(
                      color: PdfColor.fromInt(AppColors.appColor.value),
                    ),
                  ),
                  children: [
                    _buildTableCell(
                        emiResult.emiList?[index].month.toString() ?? ""),
                    _buildTableCell(
                        emiResult.emiList?[index].principal.toString() ?? ""),
                    _buildTableCell(
                        emiResult.emiList?[index].interest.toString() ?? ""),
                    _buildTableCell(
                        emiResult.emiList?[index].prePayment.toString() ?? ""),
                    _buildTableCell(
                        emiResult.emiList?[index].variableRate.toString() ??
                            ""),
                    _buildTableCell(
                        emiResult.emiList?[index].balance.toString() ?? ""),
                  ],
                )),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: isHeader
            ? pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              )
            : const pw.TextStyle(color: PdfColors.black, fontSize: 10),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
}
