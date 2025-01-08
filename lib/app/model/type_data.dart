// To parse this JSON data, do
//
//     final typeData = typeDataFromJson(jsonString);

import 'dart:convert';

TypeData typeDataFromJson(String str) => TypeData.fromJson(json.decode(str));

String typeDataToJson(TypeData data) => json.encode(data.toJson());

class TypeData {
  List<Type>? type;

  TypeData({
    this.type,
  });

  factory TypeData.fromJson(Map<String, dynamic> json) => TypeData(
    type: json["type"] == null ? [] : List<Type>.from(json["type"]!.map((x) => Type.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? [] : List<dynamic>.from(type!.map((x) => x.toJson())),
  };
}

class Type {
  String? icon;
  String? title;
  String? description;

  Type({
    this.icon,
    this.title,
    this.description,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    icon: json["icon"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "title": title,
    "description": description,
  };
}
