import 'package:flutter/material.dart';
import 'package:get/get.dart';

RxInt interLoad = 0.obs;
RxInt interImp = 0.obs;
RxInt interFailed = 0.obs;

RxInt nativeLoadS = 0.obs;
RxInt nativeImpS = 0.obs;
RxInt nativeFailedS = 0.obs;

RxInt nativeLoadM = 0.obs;
RxInt nativeImpM = 0.obs;
RxInt nativeFailedM = 0.obs;

RxInt openAppLoad = 0.obs;
RxInt openAppImp = 0.obs;
RxInt openAppFailed = 0.obs;

Widget adCounter(bool counter) {
  return counter
      ? Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text("inter"),
                      Column(
                        children: [
                          Text("L: $interLoad, "),
                          Text("I: $interImp, "),
                          Text("F: $interFailed,"),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text("SNative"),
                      Column(
                        children: [
                          Text("L: $nativeLoadS, "),
                          Text("I: $nativeImpS, "),
                          Text("F: $nativeFailedS,"),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text("MNative"),
                      Column(
                        children: [
                          Text("L: $nativeLoadM, "),
                          Text("I: $nativeImpM, "),
                          Text("F: $nativeFailedM,"),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text("OpenApp"),
                      Column(
                        children: [
                          Text("L: $openAppLoad, "),
                          Text("I: $openAppImp, "),
                          Text("F: $openAppFailed,"),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ))
      : const SizedBox.shrink();
}
