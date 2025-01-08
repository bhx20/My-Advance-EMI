import 'dart:convert';

import 'db_loanProfile.dart';

List<LoanProfileData> loanProfileDataFromJson(String str) =>
    List<LoanProfileData>.from(
        json.decode(str).map((x) => LoanProfileData.fromJson(x)));

class LoanProfileData {
  DbLoanProfile? dbData;
  String? prePayment;
  String? prePaymentMonths;
  String? loanPrePaymentType;
  String? interestSaverAccount;
  String? variableInterestRate;
  String? variableInterestMonths;
  String? moratoriumMonths;
  String? lastEmiDate;
  String? interestPaid;
  String? principalPaid;
  String? totalPaid;
  String? outstandingInterest;
  String? outstandingPrincipal;
  String? outstandingTotal;
  String? totalInterest;
  List<EmiList>? emiList;

  LoanProfileData({
    this.dbData,
    this.prePayment,
    this.prePaymentMonths,
    this.loanPrePaymentType,
    this.interestSaverAccount,
    this.variableInterestRate,
    this.variableInterestMonths,
    this.moratoriumMonths,
    this.lastEmiDate,
    this.interestPaid,
    this.principalPaid,
    this.totalPaid,
    this.outstandingInterest,
    this.outstandingPrincipal,
    this.outstandingTotal,
    this.totalInterest,
    this.emiList,
  });

  factory LoanProfileData.fromJson(Map<String, dynamic> json) {
    return LoanProfileData(
      lastEmiDate: json['lastEmiDate'],
      prePayment: json['prePayment'],
      prePaymentMonths: json['prePaymentMonths'],
      loanPrePaymentType: json['loanPrePaymentType'],
      interestSaverAccount: json['interestSaverAccount'],
      variableInterestRate: json['variableInterestRate'],
      variableInterestMonths: json['variableInterestMonths'],
      moratoriumMonths: json['moratoriumMonths'],
      interestPaid: json['interestPaid'],
      principalPaid: json['principalPaid'],
      totalPaid: json['totalPaid'],
      outstandingInterest: json['outstandingInterest'],
      outstandingPrincipal: json['outstandingPrincipal'],
      outstandingTotal: json['outstandingTotal'],
      totalInterest: json['totalInterest'],
      emiList: (json['emiList'] as List<dynamic>?)
          ?.map((item) => EmiList.fromJson(item))
          .toList(),
    );
  }
}

class EmiList {
  final int month;
  String principal;
  String interest;
  String balance;
  String prePayment;
  String variableRate;

  EmiList({
    required this.month,
    required this.principal,
    required this.interest,
    required this.balance,
    this.prePayment = "0",
    required this.variableRate,
  });

  factory EmiList.fromJson(Map<String, dynamic> json) {
    return EmiList(
      month: json['month'],
      principal: json['principal'],
      interest: json['interest'],
      balance: json['balance'],
      variableRate: json['variableRate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'principal': principal,
      'interest': interest,
      'balance': balance,
    };
  }
}
