import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TypeItem {
  final String icon;
  final String title;

  TypeItem({
    required this.icon,
    required this.title,
  });
}

class History {
  final String date;
  final String amount;
  final String interest;
  final String duration;

  History({
    required this.date,
    required this.amount,
    required this.interest,
    required this.duration,
  });
}

class ItemModel {
  final String icon;
  final String title;
  final Widget route;
  ItemModel({
    required this.icon,
    required this.title,
    required this.route,
  });
}

class ClientData {
  final String icon;
  final String name;
  final String city;
  final String price;

  ClientData({
    required this.icon,
    required this.name,
    required this.city,
    required this.price,
  });
}

class Input {
  final String title;
  final String data;
  Input(this.title, this.data);
}

class InstantModel {
  final String title;
  final String amount;
  final String rate;
  InstantModel({
    required this.title,
    required this.amount,
    required this.rate,
  });
}

class EMI {
  final String icon;
  final String title;
  final String subTitle;

  EMI({required this.icon, required this.title, required this.subTitle});
}

class SelectBackground {
  final String image;
  final String price;
  final String title;
  final String subTitle;

  final Color color;

  SelectBackground(
      {required this.image,
      required this.price,
      required this.subTitle,
      required this.title,
      required this.color});
}

class FirmData {
  final String icon;
  final String title;
  final RxBool isSelected;

  FirmData({required this.icon, required this.title, required this.isSelected});
}

class Gender {
  final String icon;
  final String label;
  final RxBool selected;

  Gender({
    required this.icon,
    required this.label,
    required this.selected,
  });
}

class IfscData {
  final String? state;
  final List<CityData>? city;
  IfscData({
    this.state,
    this.city,
  });
}

class CityData {
  final String? name;
  final List<BranchData>? branch;

  CityData({this.name, this.branch});
}

class BranchData {
  final String? name;
  final String? address;

  BranchData({this.name, this.address});
}

class BankInfo {
  String address;
  String mobileNumber;
  String ifsc;
  String micr;
  String branchCode;

  BankInfo({
    required this.address,
    required this.mobileNumber,
    required this.ifsc,
    required this.micr,
    required this.branchCode,
  });

  factory BankInfo.fromString(String data) {
    List<String> parts = data.split('*');

    String address = parts[0];
    String mobileNumber = parts[1];
    String ifsc = parts[2];
    String micr = parts[3];
    String branchCode = parts[2].numericOnly();

    return BankInfo(
      address: address,
      mobileNumber: mobileNumber,
      ifsc: ifsc,
      micr: micr,
      branchCode: branchCode,
    );
  }
}

class DrawerItem {
  final String icon;
  final String title;
  void Function() onTap;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class ToggleList {
  late bool isSelected;
  final String title;
  ToggleList(this.isSelected, this.title);
}
