// To parse this JSON data, do
//
//     final epfServiceModel = epfServiceModelFromJson(jsonString);

import 'dart:convert';

EpfServiceModel epfServiceModelFromJson(String str) => EpfServiceModel.fromJson(json.decode(str));

String epfServiceModelToJson(EpfServiceModel data) => json.encode(data.toJson());

class EpfServiceModel {
  String? title;
  List<Epf>? epf;

  EpfServiceModel({
    this.title,
    this.epf,
  });

  factory EpfServiceModel.fromJson(Map<String, dynamic> json) => EpfServiceModel(
    title: json["title"],
    epf: json["epf"] == null ? [] : List<Epf>.from(json["epf"]!.map((x) => Epf.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "epf": epf == null ? [] : List<dynamic>.from(epf!.map((x) => x.toJson())),
  };
}

class Epf {
  String? title;
  String? icon;
  String? desc;

  Epf({
    this.title,
    this.icon,
    this.desc,
  });

  factory Epf.fromJson(Map<String, dynamic> json) => Epf(
    title: json["title"],
    icon: json["icon"],
    desc: json["desc"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "icon": icon,
    "desc": desc,
  };
}
