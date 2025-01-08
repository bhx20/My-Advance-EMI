import 'dart:convert';

List<DbCalculateResult> calculateResultFromJson(String str) =>
    List<DbCalculateResult>.from(
        json.decode(str).map((x) => DbCalculateResult.fromJson(x)));

String calculateResultToJson(List<DbCalculateResult> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DbCalculateResult {
  int? dbId;
  DateTime? dbCreatedAt;
  CalculateResult? advanceEmi;

  DbCalculateResult({
    this.dbId,
    this.dbCreatedAt,
    this.advanceEmi,
  });

  factory DbCalculateResult.fromJson(Map<String, dynamic> json) =>
      DbCalculateResult(
        dbId: json["dbId"],
        dbCreatedAt: json["dbCreatedAt"] == null
            ? null
            : DateTime.parse(json["dbCreatedAt"]),
        advanceEmi: json["advanceEmi"] == null
            ? null
            : CalculateResult.fromJson(jsonDecode(json["advanceEmi"])),
      );

  Map<String, dynamic> toJson() => {
        "dbId": dbId,
        "dbCreatedAt": dbCreatedAt?.toIso8601String(),
        "advanceEmi": advanceEmi?.toJson(),
      };
}

class CalculateResult {
  DbCalculateResult? dbData;
  String? createdAt;
  String? monthlyEmi;
  String? totalInterest;
  String? processingFees;
  String? gstOnInterest;
  String? gstOnProcessingFees;
  String? totalPayment;
  String? loanAmount;
  String? interest;
  String? period;
  double? loanRatio;
  double? interestRatio;
  List<EmiList>? emiList;

  CalculateResult({
    this.dbData,
    this.createdAt,
    this.monthlyEmi,
    this.totalInterest,
    this.processingFees,
    this.totalPayment,
    this.loanAmount,
    this.interest,
    this.gstOnInterest,
    this.gstOnProcessingFees,
    this.period,
    this.loanRatio,
    this.interestRatio,
    this.emiList,
  });

  factory CalculateResult.fromJson(Map<String, dynamic> json) =>
      CalculateResult(
        createdAt: json["created_at"] ?? "", // Provide default value if null
        monthlyEmi: json["monthly_emi"] ?? "",
        totalInterest: json["total_interest"] ?? "",
        processingFees: json["processing_fees"] ?? "",
        gstOnInterest: json["gst_on_interest"] ?? "",
        gstOnProcessingFees: json["gst_on_processing_fees"] ?? "",
        totalPayment: json["total_payment"] ?? "",
        loanAmount: json["loan_amount"] ?? "",
        interest: json["interest"] ?? "",
        period: json["period"] ?? "",
        loanRatio:
            json["loan_ratio"]?.toDouble(),
        interestRatio: json["interest_ratio"]?.toDouble(),
        emiList: json["emi_list"] == null
            ? []
            : List<EmiList>.from(
                json["emi_list"]!.map((x) => EmiList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "monthly_emi": monthlyEmi,
        "total_interest": totalInterest,
        "processing_fees": processingFees,
        "gst_on_interest": gstOnInterest,
        "gst_on_processing_fees": gstOnProcessingFees,
        "total_payment": totalPayment,
        "loan_amount": loanAmount,
        "interest": interest,
        "period": period,
        "loan_ratio": loanRatio,
        "interest_ratio": interestRatio,
        "emi_list": emiList == null
            ? []
            : List<dynamic>.from(emiList!.map((x) => x.toJson())),
      };
}

class EmiList {
  dynamic month;
  dynamic principal;
  dynamic interest;
  dynamic balance;

  EmiList({
    this.month,
    this.principal,
    this.interest,
    this.balance,
  });

  factory EmiList.fromJson(Map<String, dynamic> json) => EmiList(
        month: json["month"] ?? 0,
        principal: json["principal"] ?? 0,
        interest: json["interest"] ?? 0,
        balance: json["balance"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "principal": principal,
        "interest": interest,
        "balance": balance,
      };
}
