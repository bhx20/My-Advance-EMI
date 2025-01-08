// To parse this JSON data, do
//
//     final insuranceModel = insuranceModelFromJson(jsonString);

import 'dart:convert';

InsuranceModel insuranceModelFromJson(String str) =>
    InsuranceModel.fromJson(json.decode(str));

String insuranceModelToJson(InsuranceModel data) => json.encode(data.toJson());

class InsuranceModel {
  List<Insurance>? insurance;

  InsuranceModel({
    this.insurance,
  });

  factory InsuranceModel.fromJson(Map<String, dynamic> json) => InsuranceModel(
        insurance: json["insurance"] == null
            ? []
            : List<Insurance>.from(
                json["insurance"]!.map((x) => Insurance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "insurance": insurance == null
            ? []
            : List<dynamic>.from(insurance!.map((x) => x.toJson())),
      };
}

class Insurance {
  String? title;
  String? icon;
  String? description;

  Insurance({
    this.title,
    this.icon,
    this.description,
  });

  factory Insurance.fromJson(Map<String, dynamic> json) => Insurance(
        title: json["title"],
        icon: json["icon"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "icon": icon,
        "description": description,
      };
}
