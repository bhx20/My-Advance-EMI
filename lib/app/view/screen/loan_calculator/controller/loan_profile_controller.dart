import 'dart:convert';
import 'dart:math';

import 'package:advance_emi/app/model/loan_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../component/toast/app_toast.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_string.dart';
import '../../../../model/db_loanProfile.dart';
import '../../../../model/local.dart';
import '../../../../utils/local_store/sql_helper.dart';
import '../../../../utils/num_converter/num_converter.dart';
import '../../../../utils/num_formater/num_formater.dart';

class LoanProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getLoanData().then((_) => updateFinalAmount());
    amountController.addListener(_calculateEmi);
    rateController.addListener(_calculateEmi);
    periodController.addListener(_calculateEmi);
  }

  void updateLoanProfile(LoanProfileData updatedProfile, int index) {
    loanProfiles[index] = updatedProfile;
    updateFinalAmount();
    update(); // Notify listeners
  }

//==============================================================================
// ** Save Loan Profile **
//==============================================================================

  final TextEditingController loanNameController = TextEditingController();
  final TextEditingController loanAccountNoController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController periodController = TextEditingController();
  final TextEditingController emiController = TextEditingController();
  final TextEditingController processingFeesController =
      TextEditingController();
  final TextEditingController loanDateController = TextEditingController();
  final TextEditingController firstEmiController = TextEditingController();

  var selectedLoanDate = Rx<DateTime?>(DateTime.now());
  var selectedFirstEmiDate = Rx<DateTime?>(DateTime.now());
  var notificationDurationType = "".obs;
  RxBool isNotificationEnabled = false.obs;
  String? selectedDuration;

  List<EmiList> schedule = [];
  List<String> notificationDuration = [
    "1 Day Before",
    "2 Day Before",
    "5 Day Before",
    "10 Day Before",
  ];

  Future<void> selectDate(BuildContext context, Rx<DateTime?> selectedDate,
      TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value!,
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.appColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.appColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> selectLoanDate(BuildContext context) async {
    await selectDate(context, selectedLoanDate, loanDateController);
  }

  Future<void> selectFirstEmiDate(BuildContext context) async {
    await selectDate(context, selectedFirstEmiDate, firstEmiController);
  }

  resetData() {
    loanNameController.clear();
    loanAccountNoController.clear();
    bankNameController.clear();
    amountController.clear();
    rateController.clear();
    periodController.clear();
    emiController.clear();
    processingFeesController.clear();
    loanDateController.clear();
    firstEmiController.clear();
  }

  void _calculateEmi() {
    double amount = convertToDouble(amountController.text);
    double rate = convertToDouble(rateController.text);
    double period = convertToDouble(periodController.text);

    if (amount > 0 && rate > 0 && period > 0) {
      final monthlyInterestRate = rate / (12 * 100);
      final emi = (amount *
              monthlyInterestRate *
              pow((1 + monthlyInterestRate), period)) /
          (pow((1 + monthlyInterestRate), period) - 1);

      emiController.text = formatNumber(emi);
    } else {
      emiController.clear();
    }
  }

  Future<void> saveLoanProfile({int? loanProfileId}) async {
    if (loanNameController.text.isEmpty ||
        loanAccountNoController.text.isEmpty ||
        bankNameController.text.isEmpty ||
        amountController.text.isEmpty ||
        rateController.text.isEmpty ||
        periodController.text.isEmpty ||
        processingFeesController.text.isEmpty ||
        loanDateController.text.isEmpty ||
        firstEmiController.text.isEmpty) {
      showToast("Please enter all fields");
      return;
    }

    double amount = convertToDouble(amountController.text);
    double rate = convertToDouble(rateController.text);
    double period = convertToDouble(periodController.text);

    if (amount <= 0) {
      showToast("Please enter a valid loan amount");
      return;
    }
    if (rate <= 0) {
      showToast("Please enter a valid interest rate");
      return;
    }
    if (period <= 0) {
      showToast("Please enter a valid loan period");
      return;
    }

    if (selectedLoanDate.value!.isAfter(selectedFirstEmiDate.value!) ||
        selectedLoanDate.value!.isAtSameMomentAs(selectedFirstEmiDate.value!)) {
      showToast("Loan date must be before the first EMI date");
      return;
    }

    final loanDateFormatted =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedLoanDate.value!);
    final firstEmiDateFormatted =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedFirstEmiDate.value!);
    final dbHelper = DbHelper.instance;

    final loanProfileMap = {
      "loanName": loanNameController.text,
      "loanAccountNo": loanAccountNoController.text,
      "bankName": bankNameController.text,
      "loanAmount": amountController.text,
      "interestRate": rateController.text,
      "months": periodController.text,
      "emi": emiController.text,
      "processingFees": processingFeesController.text,
      "loanDate": loanDateFormatted,
      "firstEmiDate": firstEmiDateFormatted,
    };

    String loanProfile = json.encode(loanProfileMap);

    try {
      if (loanProfileId != null) {
        await dbHelper
            .update(
          SqlTableString.loanProfileTable,
          {'loanProfile': loanProfile},
          loanProfileId,
        )
            .then((value) {
          getLoanData().then((value) {
            updateFinalAmount();
            Get.back();
            update();
          });
        });
        showToast("Loan profile updated successfully");
      } else {
        await dbHelper.insert(SqlTableString.loanProfileTable, {
          SqlTableString.loanProfile: loanProfile,
        }).then((value) {
          getLoanData().then((value) {
            updateFinalAmount();
            Get.back();
            resetData();
            update();
          });
        });
        showToast("Loan profile saved successfully");
      }
    } catch (e) {
      showToast("Error saving loan profile: $e");
    }
  }

//==============================================================================
// ** Get Data For Database **
//==============================================================================

  var loanProfiles = <LoanProfileData>[].obs;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  Future<void> getLoanData() async {
    final dbHelper = DbHelper.instance;

    try {
      final List<Map<String, dynamic>>? loanData =
          await dbHelper.queryAll(SqlTableString.loanProfileTable);
      String encodeData = json.encode(loanData);
      List<DbLoanProfile> dbLoanProfile = dbLoanProfileFromJson(encodeData);
      if (dbLoanProfile.isNotEmpty) {
        loanProfiles.clear();

        for (var i = 0; i < dbLoanProfile.length; i++) {
          loanProfiles.add(LoanProfileData(dbData: dbLoanProfile[i]));
          getDataCalculateEMI(loanProfiles[i]);
          // getDataCalculateEMIWithInterestSaver(loanProfiles[i]);
        }
      } else {}
    } catch (e) {
      showToast("Error fetching loan data: $e");
    }
  }

  void getDataCalculateEMI(LoanProfileData model) {
    double principal =
        convertToDouble(model.dbData?.loanProfile?.loanAmount ?? '0');
    double annualRate =
        convertToDouble(model.dbData?.loanProfile?.interestRate ?? '0');
    double months = convertToDouble(model.dbData?.loanProfile?.months ?? '0');
    double prePayment = convertToDouble(model.prePayment ?? '0');
    int prePaymentMonths = convertToInt(model.prePaymentMonths ?? '0');
    int moratoriumMonths = convertToInt(model.moratoriumMonths ?? '0');

    // This is the new field to check if interest is paid during moratorium
    String moratoriumInterestOption =
        model.loanPrePaymentType ?? 'No, I don\'t pay interest';

    if (principal <= 0 || annualRate <= 0 || months <= 0) {
      showToast("Invalid loan details");
      return;
    }

    double currentRate = annualRate;
    final monthlyRate = (currentRate / 12) / 100;
    double emi = (principal * monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);

    double outstandingPrincipal = principal;
    double totalInterest = 0;

    DateTime firstEmiDate = dateFormat
        .parse(model.dbData?.loanProfile?.firstEmiDate.toString() ?? '');
    List<EmiList> schedule = [];

    for (int i = 0; i < months; i++) {
      // Handle moratorium period with interest payment logic
      if (i < moratoriumMonths) {
        double interestPaid = 0;

        // Check if user chose to pay interest during moratorium
        if (moratoriumInterestOption == 'Yes, I pay interest') {
          interestPaid = outstandingPrincipal * (currentRate / 12 / 100);
          totalInterest += interestPaid;
        }

        schedule.add(EmiList(
          month: i + 1,
          principal: "0",
          interest: interestPaid.toStringAsFixed(0),
          balance: outstandingPrincipal.toStringAsFixed(0),
          prePayment: "0",
          variableRate: currentRate.toStringAsFixed(2),
        ));

        if (interestPaid > 0) {
          emi = (outstandingPrincipal *
                  monthlyRate *
                  pow(1 + monthlyRate, months - i - 1)) /
              (pow(1 + monthlyRate, months - i - 1) - 1);
        }

        continue;
      }

      // Check if interest rate should be updated based on user input
      if (i + 1 == convertToInt(model.variableInterestMonths ?? '0')) {
        currentRate = convertToDouble(model.variableInterestRate ?? '0');
        emi = (outstandingPrincipal *
                (currentRate / 12 / 100) *
                pow(1 + (currentRate / 12 / 100), months - i)) /
            (pow(1 + (currentRate / 12 / 100), months - i) - 1);
      }

      final interestPaid = outstandingPrincipal * (currentRate / 12 / 100);
      var principalPaid = emi - interestPaid;

      if (principalPaid > outstandingPrincipal) {
        principalPaid = outstandingPrincipal;
      }

      outstandingPrincipal -= principalPaid;

      if (outstandingPrincipal < 0) {
        outstandingPrincipal = 0;
      }

      // Handle pre-payment logic
      if (i + 1 == prePaymentMonths && prePayment > 0) {
        outstandingPrincipal -= prePayment;
        if (outstandingPrincipal < 0) {
          outstandingPrincipal = 0;
        }
      }

      // Add EMI entry to the schedule
      schedule.add(EmiList(
        month: i + 1,
        principal: principalPaid.toStringAsFixed(0),
        interest: interestPaid.toStringAsFixed(0),
        balance: outstandingPrincipal.toStringAsFixed(0),
        prePayment:
            i + 1 == prePaymentMonths ? prePayment.toStringAsFixed(0) : "0",
        variableRate: currentRate.toStringAsFixed(2),
      ));

      totalInterest += interestPaid;

      if (outstandingPrincipal <= 0) {
        break;
      }
    }

    // Handle the last EMI
    if (outstandingPrincipal > 0 && schedule.isNotEmpty) {
      EmiList lastEmi = schedule.last;
      double lastInterest = outstandingPrincipal * (currentRate / 12 / 100);
      lastEmi.principal = outstandingPrincipal.toStringAsFixed(0);
      lastEmi.interest = lastInterest.toStringAsFixed(0);
      lastEmi.balance = "0";
      lastEmi.prePayment = "0";
    }

    // Update model with calculated values
    model.lastEmiDate = DateFormat('dd/MM/yyyy').format(DateTime(
        firstEmiDate.year,
        firstEmiDate.month + schedule.length,
        firstEmiDate.day));
    model.interestPaid = schedule.first.interest;
    model.principalPaid = schedule.first.principal;
    model.totalPaid = (double.parse(schedule.first.interest) +
            double.parse(schedule.first.principal))
        .toStringAsFixed(0);
    model.outstandingInterest =
        (totalInterest - double.parse(schedule.first.interest))
            .toStringAsFixed(0);
    model.outstandingPrincipal = schedule.first.balance;
    model.outstandingTotal = (double.parse(schedule.first.balance) +
            (totalInterest - double.parse(schedule.first.interest)))
        .toStringAsFixed(0);
    model.totalInterest = totalInterest.toStringAsFixed(0);
    model.emiList = schedule;

    update();
  }

  void getDataCalculateEMIWithInterestSaver(LoanProfileData model) {
    double principal =
        convertToDouble(model.dbData?.loanProfile?.loanAmount ?? '0');
    double annualRate =
        convertToDouble(model.dbData?.loanProfile?.interestRate ?? '0');
    double months = convertToDouble(model.dbData?.loanProfile?.months ?? '0');
    double prePayment = convertToDouble(model.prePayment ?? '0');
    int prePaymentMonths = int.parse(model.prePaymentMonths ?? '0');

    double interestSaver = convertToDouble(model.interestSaverAccount ?? '0');

    principal -= interestSaver;

    if (principal <= 0 || annualRate <= 0 || months <= 0) {
      showToast("Invalid loan details");
      return;
    }

    final monthlyRate = annualRate / 12 / 100;
    final emi = (principal * monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);

    double outstandingPrincipal = principal;
    double totalInterest = 0;

    DateTime firstEmiDate = dateFormat
        .parse(model.dbData?.loanProfile?.firstEmiDate.toString() ?? '');
    List<EmiList> schedule = [];

    for (int i = 0; i < months; i++) {
      if (i + 1 == prePaymentMonths) {
        outstandingPrincipal -= prePayment;
      }

      final interestPaid = outstandingPrincipal * monthlyRate;
      var principalPaid = emi - interestPaid;

      if (principalPaid > outstandingPrincipal) {
        principalPaid = outstandingPrincipal;
      }

      outstandingPrincipal -= principalPaid;

      if (outstandingPrincipal < 0) {
        outstandingPrincipal = 0;
      }

      schedule.add(EmiList(
        month: i + 1,
        principal: principalPaid.toStringAsFixed(0),
        interest: interestPaid.toStringAsFixed(0),
        balance: outstandingPrincipal.toStringAsFixed(0),
        prePayment:
            i + 1 == prePaymentMonths ? prePayment.toStringAsFixed(0) : "0",
        variableRate: model.dbData?.loanProfile?.interestRate ?? "0",
      ));

      totalInterest += interestPaid;
      if (outstandingPrincipal <= 0) {
        break;
      }
    }

    if (outstandingPrincipal > 0 && schedule.isNotEmpty) {
      EmiList lastEmi = schedule.last;
      double lastInterest = outstandingPrincipal * monthlyRate;
      lastEmi.principal = outstandingPrincipal.toStringAsFixed(0);
      lastEmi.interest = lastInterest.toStringAsFixed(0);
      lastEmi.balance = "0";
      lastEmi.prePayment = "0";
    }

    model.lastEmiDate = DateFormat('dd/MM/yyyy').format(DateTime(
        firstEmiDate.year,
        firstEmiDate.month + schedule.length,
        firstEmiDate.day));
    model.interestPaid = schedule.first.interest;
    model.principalPaid = schedule.first.principal;
    model.totalPaid = (double.parse(schedule.first.interest) +
            double.parse(schedule.first.principal))
        .toStringAsFixed(0);
    model.outstandingInterest =
        (totalInterest - double.parse(schedule.first.interest))
            .toStringAsFixed(0);
    model.outstandingPrincipal = schedule.first.balance;
    model.outstandingTotal = (double.parse(schedule.first.balance) +
            (totalInterest - double.parse(schedule.first.interest)))
        .toStringAsFixed(0);
    model.totalInterest = totalInterest.toStringAsFixed(0);
    model.emiList = schedule;

    update();
  }

//==============================================================================
// ** Loan Profile **
//==============================================================================
  var totalLoanAmount = 0.0.obs;
  var totalEmi = 0.0.obs;
  var totalAmountPaid = 0.0.obs;
  var totalOutstandingAmount = 0.0.obs;
  final dbHelper = DbHelper.instance;

  updateFinalAmount() {
    totalLoanAmount.value = 0.0;
    totalEmi.value = 0.0;
    totalAmountPaid.value = 0.0;
    totalOutstandingAmount.value = 0.0;

    for (var profile in loanProfiles) {
      double loanAmount =
          convertToDouble(profile.dbData?.loanProfile?.loanAmount ?? '0');
      double emi = convertToDouble(profile.dbData?.loanProfile?.emi ?? '0');
      double amountPaid = convertToDouble(profile.totalPaid ?? '0');
      double outstandingAmount =
          convertToDouble(profile.outstandingPrincipal ?? '0');

      totalLoanAmount.value += loanAmount;
      totalEmi.value += emi;
      totalAmountPaid.value += amountPaid;
      totalOutstandingAmount.value += outstandingAmount;
    }

    // Notify listeners to update the UI
    update();
  }

  deleteLoanProfile(int id) async {
    await dbHelper
        .deleteQuery(SqlTableString.loanProfileTable, id, SqlTableString.dbId)
        .then((value) {
      loanProfiles.removeWhere((value) => value.dbData?.dbId == id);
    }).then((value) {
      getLoanData();
    }).then((value) {
      updateFinalAmount();
    });
    update();
  }

//==============================================================================
// ** Edit Profile **
//==============================================================================

  editProfileData(LoanProfileData? editData) {
    loanNameController.text = editData?.dbData?.loanProfile?.loanName ?? "";
    loanAccountNoController.text =
        editData?.dbData?.loanProfile?.loanAccountNo ?? "";
    bankNameController.text = editData?.dbData?.loanProfile?.bankName ?? "";
    amountController.text = editData?.dbData?.loanProfile?.loanAmount ?? "";
    rateController.text = editData?.dbData?.loanProfile?.interestRate ?? "";
    periodController.text = editData?.dbData?.loanProfile?.months ?? "";
    emiController.text = editData?.dbData?.loanProfile?.emi ?? "";
    processingFeesController.text =
        editData?.dbData?.loanProfile?.processingFees ?? "";
    loanDateController.text = DateFormat('dd/MM/yyyy')
        .format(editData?.dbData?.loanProfile?.loanDate ?? DateTime.now());
    firstEmiController.text = DateFormat('dd/MM/yyyy')
        .format(editData?.dbData?.loanProfile?.firstEmiDate ?? DateTime.now());
  }

  var selectedPeriodIndex = 0.obs;
  var loanPrePaymentType = "".obs;
  var variableInterestRateType = "".obs;
  var moratoriumPeriodType = "".obs;
  String? currentTenure;
  var moratoriumPeriodTypeBool = "Yes, I pay interest".obs;
  var loanPrePaymentList = <Map<String, String>>[].obs;
  var variableInterestRateList = <Map<String, String>>[].obs;
  String _interestSaverAccountValue = '';

// Pre Payment Loan Function
  void addPrePaymentToLoanProfile(
      int index, String prePaymentType, String principal, String tenure) {
    if (index >= 0 && index < loanProfiles.length) {
      loanProfiles[index].prePayment = principal;
      loanProfiles[index].prePaymentMonths = tenure;
      loanProfiles[index].loanPrePaymentType = prePaymentType;
      loanProfiles[index] = loanProfiles[index];
      getDataCalculateEMI(loanProfiles[index]);
      update();
    }
  }

// variable Interest Rate Function
  void addVariableInterestRate(
      int index, String variableType, String rate, String tenure) {
    if (index >= 0 && index < loanProfiles.length) {
      var profile = loanProfiles[index];
      profile.variableInterestRate = rate;
      profile.variableInterestMonths = tenure;
      profile.loanPrePaymentType = variableType;

      getDataCalculateEMI(profile);
      loanProfiles[index] = profile;
      update();
    }
  }

// Moratorium Period Function
  void addMoratoriumPeriod(
      int index, String moratoriumPeriodType, String tenure) {
    if (index >= 0 && index < loanProfiles.length) {
      var profile = loanProfiles[index];
      profile.loanPrePaymentType = moratoriumPeriodType;
      profile.moratoriumMonths = tenure;
      currentTenure = tenure;

      getDataCalculateEMI(profile);
      loanProfiles[index] = profile;
      update();
    }
  }

  String getMoratoriumTenure(int index) {
    if (index >= 0 && index < loanProfiles.length) {
      return loanProfiles[index].moratoriumMonths ?? '';
    }
    return '';
  }

  // Method to get current moratorium period type for the dialog
  String getMoratoriumPeriodType(int index) {
    if (index >= 0 && index < loanProfiles.length) {
      return loanProfiles[index].loanPrePaymentType ?? '';
    }
    return '';
  }

  void resetMoratoriumPeriod(int index) {
    if (index >= 0 && index < loanProfiles.length) {
      var profile = loanProfiles[index];
      profile.moratoriumMonths = ''; // Reset tenure
      profile.loanPrePaymentType = ''; // Reset period type
      loanProfiles[index] = profile;
      update();
    }
  }

// Interest Saver Account Function
  String? getInterestSaverAccountValue() {
    return _interestSaverAccountValue.isNotEmpty
        ? _interestSaverAccountValue
        : null;
  }

  void setInterestSaverAccountValue(String value) {
    _interestSaverAccountValue = value;
  }

  void resetInterestSaverAccountValue() {
    _interestSaverAccountValue = '';
  }

  void addInterestSaverAccount(int index, String principal) {
    if (index >= 0 && index < loanProfiles.length) {
      loanProfiles[index].interestSaverAccount = principal;
      loanProfiles[index] = loanProfiles[index];
      getDataCalculateEMIWithInterestSaver(loanProfiles[index]);
      update();
    }
  }

  void onPeriodChangedData(int newIndex, int oldIndex) {
    if (newIndex != oldIndex) {
      selectedPeriodIndex.value = newIndex;
    }
  }

  List<String> loanPrePayment = [
    "Reduce the loan term",
    "Reduce EMI monthly",
  ];

  List<String> variableInterestRate = [
    "Change loan term",
    "Change EMI monthly",
  ];

  List<String> moratoriumPeriod = [
    "Yes, I pay interest",
    "No, I don't pay interest",
  ];

  List<String> editProfileList = [
    "Loan Details",
    "Loan Pre-Payment",
    "Variable Interest Rate",
    "Interest Saver Account",
    "Moratorium Period",
  ];

  RxList<ToggleList> toggleItem = <ToggleList>[
    ToggleList(true, 'Years'),
    ToggleList(false, 'Months'),
  ].obs;
}
