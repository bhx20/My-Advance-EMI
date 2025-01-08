// To parse this JSON data, do
//
//     final guideData = guideDataFromJson(jsonString);

import 'dart:convert';

LoanInfoData guideDataFromJson(String str) =>
    LoanInfoData.fromJson(json.decode(str));

String guideDataToJson(LoanInfoData data) => json.encode(data.toJson());

class LoanInfoData {
  List<Guide>? guide;

  LoanInfoData({
    this.guide,
  });

  factory LoanInfoData.fromJson(Map<String, dynamic> json) => LoanInfoData(
        guide: json["guide"] == null
            ? []
            : List<Guide>.from(json["guide"]!.map((x) => Guide.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "guide": guide == null
            ? []
            : List<dynamic>.from(guide!.map((x) => x.toJson())),
      };
}

class Guide {
  int? id;
  String? icon;
  String? title;
  List<Cat>? cat;

  Guide({
    this.id,
    this.icon,
    this.title,
    this.cat,
  });

  factory Guide.fromJson(Map<String, dynamic> json) => Guide(
        id: json["id"],
        icon: json["icon"],
        title: json["title"],
        cat: json["cat"] == null
            ? []
            : List<Cat>.from(json["cat"]!.map((x) => Cat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "title": title,
        "cat":
            cat == null ? [] : List<dynamic>.from(cat!.map((x) => x.toJson())),
      };
}

class Cat {
  String? title;
  String? description;

  Cat({
    this.title,
    this.description,
  });

  factory Cat.fromJson(Map<String, dynamic> json) => Cat(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}
