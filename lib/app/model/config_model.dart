// To parse this JSON data, do
//
//     final configData = configDataFromJson(jsonString);

import 'dart:convert';

ConfigData configDataFromJson(String str) =>
    ConfigData.fromJson(json.decode(str));

String configDataToJson(ConfigData data) => json.encode(data.toJson());

class ConfigData {
  String? appOpenId;
  List<DashBoardElement>? dashBoardElement;
  List<LeadingBanner>? leadingBanners;
  String? fbAppId;
  String? fbToken;
  String? help;
  int interstitialCounter;
  String? interstitialId;
  int nativeCounter;
  String? nativeId;
  List<OnBoarding>? onBoarding;
  String? privacy;
  String? shareLink;
  bool? showAd;
  bool? showBanner;
  bool? showInterstitial;
  bool? showNative;
  bool? showOpenApp;

  ConfigData({
    this.appOpenId,
    this.dashBoardElement,
    this.leadingBanners,
    this.fbAppId,
    this.fbToken,
    this.help,
    this.interstitialCounter = 0,
    this.interstitialId,
    this.nativeCounter = 0,
    this.nativeId,
    this.onBoarding,
    this.privacy,
    this.shareLink,
    this.showAd,
    this.showBanner,
    this.showInterstitial,
    this.showNative,
    this.showOpenApp,
  });

  factory ConfigData.fromJson(Map<String, dynamic> json) => ConfigData(
        appOpenId: json["appOpenId"],
        dashBoardElement: json["dashBoard_element"] == null
            ? []
            : List<DashBoardElement>.from(json["dashBoard_element"]!
                .map((x) => DashBoardElement.fromJson(x))),
        leadingBanners: json["leading_banners"] == null
            ? []
            : List<LeadingBanner>.from(
                json["leading_banners"]!.map((x) => LeadingBanner.fromJson(x))),
        fbAppId: json["fbAppId"],
        fbToken: json["fbToken"],
        help: json["help"],
        interstitialCounter: json["interstitialCounter"],
        interstitialId: json["interstitialId"],
        nativeCounter: json["nativeCounter"],
        nativeId: json["nativeId"],
        onBoarding: json["on_boarding"] == null
            ? []
            : List<OnBoarding>.from(
                json["on_boarding"]!.map((x) => OnBoarding.fromJson(x))),
        privacy: json["privacy"],
        shareLink: json["shareLink"],
        showAd: json["showAd"],
        showBanner: json["showBanner"],
        showInterstitial: json["showInterstitial"],
        showNative: json["showNative"],
        showOpenApp: json["showOpenApp"],
      );

  Map<String, dynamic> toJson() => {
        "appOpenId": appOpenId,
        "dashBoard_element": dashBoardElement == null
            ? []
            : List<dynamic>.from(dashBoardElement!.map((x) => x.toJson())),
        "leading_banners": leadingBanners == null
            ? []
            : List<dynamic>.from(leadingBanners!.map((x) => x.toJson())),
        "fbAppId": fbAppId,
        "fbToken": fbToken,
        "help": help,
        "interstitialCounter": interstitialCounter,
        "interstitialId": interstitialId,
        "nativeCounter": nativeCounter,
        "nativeId": nativeId,
        "on_boarding": onBoarding == null
            ? []
            : List<dynamic>.from(onBoarding!.map((x) => x.toJson())),
        "privacy": privacy,
        "shareLink": shareLink,
        "showAd": showAd,
        "showBanner": showBanner,
        "showInterstitial": showInterstitial,
        "showNative": showNative,
        "showOpenApp": showOpenApp,
      };
}

class DashBoardElement {
  String? id;
  bool? show;
  int? sort;

  DashBoardElement({
    this.id,
    this.show,
    this.sort,
  });

  factory DashBoardElement.fromJson(Map<String, dynamic> json) =>
      DashBoardElement(
        id: json["id"],
        show: json["show"],
        sort: json["sort"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "show": show,
        "sort": sort,
      };
}

class LeadingBanner {
  String? image;
  String? id;
  bool show;

  LeadingBanner({
    this.image,
    this.id,
    this.show = true,
  });

  factory LeadingBanner.fromJson(Map<String, dynamic> json) => LeadingBanner(
        image: json["image"],
        id: json["id"],
        show: json["show"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "id": id,
        "show": show,
      };
}

class OnBoarding {
  String? description;
  String? imageAsset;
  bool show;
  String? title;

  OnBoarding({
    this.description,
    this.imageAsset,
    this.show = true,
    this.title,
  });

  factory OnBoarding.fromJson(Map<String, dynamic> json) => OnBoarding(
        description: json["description"],
        imageAsset: json["imageAsset"],
        show: json["show"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "imageAsset": imageAsset,
        "show": show,
        "title": title,
      };
}
