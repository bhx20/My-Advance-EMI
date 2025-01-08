import 'package:advance_emi/app/core/app_typography.dart';
import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../component/app_bar/my_app_bar.dart';
import '../../../../../component/app_textformfield/common_field.dart';
import '../../../../../component/google_add/google_advertise_repo/advertise_repo.dart';
import '../../../../../component/toast/app_toast.dart';
import '../../../../../core/app_colors.dart';
import '../../../../../utils/num_to_word/num_to_word.dart';
import '../../../../widgets/generated_scaffold.dart';

class WordItem {
  final String title;
  RxString value;
  WordItem({required this.title, required this.value});
}

class AmountToWord extends StatefulWidget {
  const AmountToWord({super.key});

  @override
  State<AmountToWord> createState() => _AmountToWordState();
}

class _AmountToWordState extends State<AmountToWord> {
  final inputController = TextEditingController();
  List<WordItem> typeList = [
    WordItem(title: "Indian Format", value: "".obs),
    WordItem(title: "US Format", value: "".obs)
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBar: myAppBar(titleText: "Amount To Word".toUpperCase(), actions: [
          IconButton(
              onPressed: () {
                showAdAndNavigate(() {
                  inputController.clear();
                  typeList.first.value("");
                  typeList.last.value("");
                });
              },
              icon: const Icon(
                Icons.restart_alt_outlined,
                color: AppColors.black,
                size: 25,
              ))
        ]),
        bottomNavigationBar: GoogleAdd.getInstance().showNative(isSmall: true),
        body: Padding(
          padding: EdgeInsets.all(10.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppTextFormField(
                  hint: "Enter Amount",
                  maxLength: 18,
                  controller: inputController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      typeList.first.value(numToWordsIndia(int.parse(value)));
                      typeList.last.value(numToWordsUs(int.parse(value)));
                    } else {
                      typeList.first.value("");
                      typeList.last.value("");
                    }
                  },
                ),
                SizedBox(height: 20.h),
                ...List.generate(
                    typeList.length,
                    (index) => Container(
                          height: 180,
                          margin: EdgeInsets.symmetric(vertical: 10.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.border, width: 1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Text(
                                  typeList[index].title,
                                  style: notoSans.get12.w600.space09.textColor(
                                      AppColors.gray.withOpacity(0.4)),
                                ),
                              ),
                              Expanded(
                                  child: Obx(
                                      () => Text(typeList[index].value.value))),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        if (typeList[index]
                                            .value
                                            .value
                                            .isNotEmpty) {
                                          showAdAndNavigate(() async {
                                            await Clipboard.setData(
                                                ClipboardData(
                                              text: typeList[index].value.value,
                                            ));
                                            showToast("Copied");
                                          });
                                        } else {
                                          showToast("Nothing to Copy");
                                        }
                                      },
                                      icon: const Icon(Icons.copy)),
                                  IconButton(
                                      onPressed: () {
                                        if (typeList[index]
                                            .value
                                            .value
                                            .isNotEmpty) {
                                          showAdAndNavigate(() {
                                            Share.share(
                                              typeList[index].value.value,
                                            );
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.share))
                                ],
                              ),
                            ],
                          ),
                        ))
              ],
            ),
          ),
        ));
  }
}
