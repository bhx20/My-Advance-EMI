// To parse this JSON data, do
//
//     final dbLoanProfile = dbLoanProfileFromJson(jsonString);

import 'dart:convert';

List<DbLoanProfile> dbLoanProfileFromJson(String str) =>
    List<DbLoanProfile>.from(
        json.decode(str).map((x) => DbLoanProfile.fromJson(x)));

String dbLoanProfileToJson(List<DbLoanProfile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DbLoanProfile {
  int? dbId;
  DateTime? dbCreatedAt;
  LoanProfile? loanProfile;

  DbLoanProfile({
    this.dbId,
    this.dbCreatedAt,
    this.loanProfile,
  });

  factory DbLoanProfile.fromJson(Map<String, dynamic> json) => DbLoanProfile(
        dbId: json["dbId"],
        dbCreatedAt: json["dbCreatedAt"] == null
            ? null
            : DateTime.parse(json["dbCreatedAt"]),
        loanProfile: json["loanProfile"] == null
            ? null
            : LoanProfile.fromJson(jsonDecode(json["loanProfile"])),
      );

  Map<String, dynamic> toJson() => {
        "dbId": dbId,
        "dbCreatedAt": dbCreatedAt?.toIso8601String(),
        "loanProfile": loanProfile?.toJson(),
      };
}

class LoanProfile {
  String? loanName;
  String? loanAccountNo;
  String? bankName;
  String? loanAmount;
  String? interestRate;
  String? months;
  String? emi;
  String? processingFees;
  DateTime? loanDate;
  DateTime? firstEmiDate;

  LoanProfile({
    this.loanName,
    this.loanAccountNo,
    this.bankName,
    this.loanAmount,
    this.interestRate,
    this.months,
    this.emi,
    this.processingFees,
    this.loanDate,
    this.firstEmiDate,
  });

  factory LoanProfile.fromJson(Map<String, dynamic> json) => LoanProfile(
        loanName: json["loanName"],
        loanAccountNo: json["loanAccountNo"],
        bankName: json["bankName"],
        loanAmount: json["loanAmount"],
        interestRate: json["interestRate"],
        months: json["months"],
        emi: json["emi"],
        processingFees: json["processingFees"],
        loanDate:
            json["loanDate"] == null ? null : DateTime.parse(json["loanDate"]),
        firstEmiDate: json["firstEmiDate"] == null
            ? null
            : DateTime.parse(json["firstEmiDate"]),
      );

  Map<String, dynamic> toJson() => {
        "loanName": loanName,
        "loanAccountNo": loanAccountNo,
        "bankName": bankName,
        "loanAmount": loanAmount,
        "interestRate": interestRate,
        "months": months,
        "emi": emi,
        "processingFees": processingFees,
        "loanDate": loanDate?.toIso8601String(),
        "firstEmiDate": firstEmiDate?.toIso8601String(),
      };
}
