// To parse this JSON data, do
//
//     final bankIfscModel = bankIfscModelFromJson(jsonString);

import 'dart:convert';

BankIfscModel bankIfscModelFromJson(String str) =>
    BankIfscModel.fromJson(json.decode(str));

String bankIfscModelToJson(BankIfscModel data) => json.encode(data.toJson());

class BankIfscModel {
  List<BankIfsc>? bankIfsc;

  BankIfscModel({
    this.bankIfsc,
  });

  factory BankIfscModel.fromJson(Map<String, dynamic> json) => BankIfscModel(
        bankIfsc: json["bank_ifsc"] == null
            ? []
            : List<BankIfsc>.from(
                json["bank_ifsc"]!.map((x) => BankIfsc.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bank_ifsc": bankIfsc == null
            ? []
            : List<dynamic>.from(bankIfsc!.map((x) => x.toJson())),
      };
}

class BankIfsc {
  String? bankName;
  List<BankState>? bankState;

  BankIfsc({
    this.bankName,
    this.bankState,
  });

  factory BankIfsc.fromJson(Map<String, dynamic> json) => BankIfsc(
        bankName: json["Bank_name"],
        bankState: json["Bank_state"] == null
            ? []
            : List<BankState>.from(
                json["Bank_state"]!.map((x) => BankState.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Bank_name": bankName,
        "Bank_state": bankState == null
            ? []
            : List<dynamic>.from(bankState!.map((x) => x.toJson())),
      };
}

class BankState {
  String? name;
  List<City>? cities;

  BankState({
    this.name,
    this.cities,
  });

  factory BankState.fromJson(Map<String, dynamic> json) => BankState(
        name: json["name"],
        cities: json["cities"] == null
            ? []
            : List<City>.from(json["cities"]!.map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "cities": cities == null
            ? []
            : List<dynamic>.from(cities!.map((x) => x.toJson())),
      };
}

class City {
  String? name;
  List<Branch>? branches;

  City({
    this.name,
    this.branches,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"],
        branches: json["branches"] == null
            ? []
            : List<Branch>.from(
                json["branches"]!.map((x) => Branch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "branches": branches == null
            ? []
            : List<dynamic>.from(branches!.map((x) => x.toJson())),
      };
}

class Branch {
  String? name;
  String? address;
  String? phone;
  String? ifsc;

  Branch({
    this.name,
    this.address,
    this.phone,
    this.ifsc,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        ifsc: json["IFSC"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "phone": phone,
        "IFSC": ifsc,
      };
}
