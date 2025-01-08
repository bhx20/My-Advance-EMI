import 'package:advance_emi/app/core/app_colors.dart';
import 'package:advance_emi/app/core/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../component/app_bar/my_app_bar.dart';
import '../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../generated_scaffold.dart';

class DocumentRequiredView extends StatefulWidget {
  const DocumentRequiredView({super.key});

  @override
  State<DocumentRequiredView> createState() => _DocumentRequiredViewState();
}

class _DocumentRequiredViewState extends State<DocumentRequiredView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: myAppBar(
        titleText: "Documents Required",
        isBack: true,
      ),
      bottomNavigationBar: GoogleAdd.getInstance().showNative(isSmall: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
              child: Text(
                'Proof of Identify (Any one)',
                style: notoSans.w500.appColor.get12,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  _buildCheckBoxItem('PAN Card'),
                  _buildCheckBoxItem('Passport'),
                  _buildCheckBoxItem('Aadhaar Card'),
                  _buildCheckBoxItem('Voter ID'),
                  _buildCheckBoxItem('Driving License'),
                  _buildCheckBoxItem('Govt. Employee ID'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
              child: Text(
                'Proof of Residence (Any one)',
                style: notoSans.w500.appColor.get12,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  _buildCheckBoxItem('Passport'),
                  _buildCheckBoxItem('Aadhaar Card'),
                  _buildCheckBoxItem('Voter ID'),
                  _buildCheckBoxItem('Driving License'),
                  _buildCheckBoxItem('Govt. Employee ID'),
                  _buildCheckBoxItem(
                      'Utility Bills (Telephone Bill OR Electricity Bill OR Water Bill OR Gas Bill)'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
              child: Text(
                'Proof of Income',
                style: notoSans.w500.appColor.get12,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 9.w),
                    child: Text(
                      'For Salaried',
                      style: notoSans.w700.get12,
                    ),
                  ),
                  _buildCheckBoxItem(
                      'Form 16 of last 2 financial years OR IT Returns of last 2 financial years'),
                  _buildCheckBoxItem('3 months pay slip'),
                  _buildCheckBoxItem('6 months bank statement'),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 9.w),
                    child: Text(
                      'For Self-Employed',
                      style: notoSans.w700.get12,
                    ),
                  ),
                  _buildCheckBoxItem('Address Proof of Business'),
                  _buildCheckBoxItem('IT Returns of last 3 financial years'),
                  _buildCheckBoxItem('IT Returns of last 3 financial years'),
                  _buildCheckBoxItem(
                      'Balance Sheet & Profit & Loss A/c of last 3 financial years'),
                  _buildCheckBoxItem(
                      'Business Licence Details (or equivalent)'),
                  _buildCheckBoxItem(
                      'Certificate of qualification(for C.A./ Doctor and other professionals)'),
                  _buildCheckBoxItem('6 months bank statement'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  child: Text(
                    "Passport Size Photos (3 or more)",
                    style: notoSans.w400.get12,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCheckBoxItem(
    String title,
  ) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10.w, top: 3.h),
              child: Image.asset(
                "assets/icons/square.png",
                height: 9.h,
                width: 9.w,
                color: AppColors.appColor,
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: notoSans.w400.get12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
