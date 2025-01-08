import 'package:flutter/material.dart';

import 'advertise_repo_impl.dart';

class GoogleAdd {
  static GoogleAddRepoImpl getInstance() {
    return GoogleAddRepoImpl();
  }
}

abstract class GoogleAddRepo {
  void loadLargeNative();

  void loadSmallNative();

  Widget showNative({bool isSmall = false});

  Future<void> googleOpenAppAdd();

  void loadGoogleInterstitialAdd();

  void showGoogleInterstitialAdd();
}
