// To parse this JSON data, do
//
//     final bankListModel = bankListModelFromJson(jsonString);

import 'dart:convert';

BankHelpLineModel bankHelpLineModelFromJson(String str) =>
    BankHelpLineModel.fromJson(json.decode(str));

String bankListModelToJson(BankHelpLineModel data) =>
    json.encode(data.toJson());

class BankHelpLineModel {
  List<BankList>? bankList;

  BankHelpLineModel({
    this.bankList,
  });

  factory BankHelpLineModel.fromJson(Map<String, dynamic> json) =>
      BankHelpLineModel(
        bankList: json["bankList"] == null
            ? []
            : List<BankList>.from(
                json["bankList"]!.map((x) => BankList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bankList": bankList == null
            ? []
            : List<dynamic>.from(bankList!.map((x) => x.toJson())),
      };
}

class BankList {
  String? title;
  String? number;

  BankList({
    this.title,
    this.number,
  });

  factory BankList.fromJson(Map<String, dynamic> json) => BankList(
        title: json["title"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "number": number,
      };
}
