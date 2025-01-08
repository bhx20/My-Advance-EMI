import 'package:advance_emi/app/core/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../component/app_bar/my_app_bar.dart';
import '../../../component/app_button/app_button.dart';
import '../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../component/toast/app_toast.dart';
import '../generated_scaffold.dart';

class DescriptionView extends StatelessWidget {
  final String title;
  final String dec;
  final String? link;

  const DescriptionView({
    required this.dec,
    required this.title,
    super.key,
    this.link,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBar: myAppBar(
          titleText: title,
        ),
        bottomNavigationBar: GoogleAdd.getInstance().showNative(isSmall: true),
        body: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(15.h),
                  child: Text(
                    dec,
                    style: notoSans.get12.textHeight(2),
                  ),
                ),
                if (link != null && link != "")
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.h),
                    child: Text(
                      link!,
                      style: notoSans.get12.appColor.textHeight(2),
                    ),
                  ),
                if (link != null && link != "")
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.h),
                          child: AppButton(
                            "Copy",
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: link!));
                              showToast("Copied");
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.h),
                          child: AppButton(
                            "Open Link",
                            onPressed: () async {
                              final url = link!;
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch Google Maps';
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ));
  }
}
