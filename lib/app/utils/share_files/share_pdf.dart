import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart ' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cr_file_saver/file_saver.dart';
import '../../component/google_add/InitialController.dart';
import '../../component/toast/app_toast.dart';
import '../../core/app_colors.dart';
import '../../model/emi_result_model.dart';

class SharePdf {
  late Uint8List imageData;

  Future<void> shareEmiDetails(CalculateResult? emiResult) async {
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

  Future<void> _sharePdf(CalculateResult? emiResult) async {
    try {
      final pdf = pw.Document();
      DateTime now = DateTime.parse(emiResult?.createdAt ?? "");
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
                    ['Amount', emiResult?.loanAmount],
                    ['Interest %', emiResult?.interest],
                    ['Period (Months)', emiResult?.period],
                    ['Monthly EMI', emiResult?.monthlyEmi],
                    ['Total Interest', emiResult?.totalInterest],
                    ['Processing Fees', emiResult?.processingFees],
                    ['Total Payment', emiResult?.totalPayment],
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

  pw.Widget _buildEMIScheduleTable(CalculateResult? emiResult) {
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
