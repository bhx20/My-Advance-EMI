// To parse this JSON data, do
//
//     final creditScoreOnlineModel = creditScoreOnlineModelFromJson(jsonString);

import 'dart:convert';

CreditScoreOnlineModel creditScoreOnlineModelFromJson(String str) => CreditScoreOnlineModel.fromJson(json.decode(str));

String creditScoreOnlineModelToJson(CreditScoreOnlineModel data) => json.encode(data.toJson());

class CreditScoreOnlineModel {
  List<CreditScoreOnline>? creditScoreOnline;

  CreditScoreOnlineModel({
    this.creditScoreOnline,
  });

  factory CreditScoreOnlineModel.fromJson(Map<String, dynamic> json) => CreditScoreOnlineModel(
    creditScoreOnline: json["credit_score_online"] == null ? [] : List<CreditScoreOnline>.from(json["credit_score_online"]!.map((x) => CreditScoreOnline.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "credit_score_online": creditScoreOnline == null ? [] : List<dynamic>.from(creditScoreOnline!.map((x) => x.toJson())),
  };
}

class CreditScoreOnline {
  String? icon;
  String? title;
  String? description;
  String? link;

  CreditScoreOnline({
    this.icon,
    this.title,
    this.description,
    this.link,
  });

  factory CreditScoreOnline.fromJson(Map<String, dynamic> json) => CreditScoreOnline(
    icon: json["icon"],
    title: json["title"],
    description: json["description"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "title": title,
    "description": description,
    "link": link,
  };
}
