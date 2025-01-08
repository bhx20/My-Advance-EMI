// To parse this JSON data, do
//
//     final bankHolidaysModel = bankHolidaysModelFromJson(jsonString);

import 'dart:convert';

BankHolidaysModel bankHolidaysModelFromJson(String str) =>
    BankHolidaysModel.fromJson(json.decode(str));

String bankHolidaysModelToJson(BankHolidaysModel data) =>
    json.encode(data.toJson());

class BankHolidaysModel {
  List<BankHoliday>? bankHoliday;

  BankHolidaysModel({
    this.bankHoliday,
  });

  factory BankHolidaysModel.fromJson(Map<String, dynamic> json) =>
      BankHolidaysModel(
        bankHoliday: json["bank_holiday"] == null
            ? []
            : List<BankHoliday>.from(
                json["bank_holiday"]!.map((x) => BankHoliday.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bank_holiday": bankHoliday == null
            ? []
            : List<dynamic>.from(bankHoliday!.map((x) => x.toJson())),
      };
}

class BankHoliday {
  String? poster;
  String? title;
  List<ListElement>? list;

  BankHoliday({
    this.poster,
    this.title,
    this.list,
  });

  factory BankHoliday.fromJson(Map<String, dynamic> json) => BankHoliday(
        poster: json["poster"],
        title: json["title"],
        list: json["list"] == null
            ? []
            : List<ListElement>.from(
                json["list"]!.map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "poster": poster,
        "title": title,
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ListElement {
  String? date;
  String? holiday;

  ListElement({
    this.date,
    this.holiday,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        date: json["date"],
        holiday: json["holiday"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "holiday": holiday,
      };
}
