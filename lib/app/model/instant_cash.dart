// To parse this JSON data, do
//
//     final instantCashModel = instantCashModelFromJson(jsonString);

import 'dart:convert';

InstantCashModel instantCashModelFromJson(String str) =>
    InstantCashModel.fromJson(json.decode(str));

String instantCashModelToJson(InstantCashModel data) =>
    json.encode(data.toJson());

class InstantCashModel {
  List<Instant>? instant;

  InstantCashModel({
    this.instant,
  });

  factory InstantCashModel.fromJson(Map<String, dynamic> json) =>
      InstantCashModel(
        instant: json["instant"] == null
            ? []
            : List<Instant>.from(
                json["instant"]!.map((x) => Instant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "instant": instant == null
            ? []
            : List<dynamic>.from(instant!.map((x) => x.toJson())),
      };
}

class Instant {
  String? title;
  String? amount;
  String? rate;

  Instant({
    this.title,
    this.amount,
    this.rate,
  });

  factory Instant.fromJson(Map<String, dynamic> json) => Instant(
        title: json["title"],
        amount: json["amount"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "amount": amount,
        "rate": rate,
      };
}
