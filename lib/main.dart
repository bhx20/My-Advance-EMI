import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/component/google_add/InitialController.dart';
import 'app/component/google_add/ad_counter.dart';
import 'app/component/wrapper.dart';
import 'app/core/constant.dart';
import 'app/core/meterial_theme.dart';
import 'app/view/screen/splash/views/splash_screen_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return ConnectivityAppWrapper(
          app: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Loan Quickly EMI Calculator",
            home: const SplashView(),
            theme: customTheme,
            navigatorKey: navigatorKey,
            initialBinding: InitialBinding(),
            builder: (buildContext, widget) {
              return ConnectivityWidgetWrapper(
                  disableInteraction: true,
                  offlineWidget: const ConnectionWrapper(),
                  child: Scaffold(
                    body: Column(
                      children: [
                        Expanded(child: widget!),
                        adCounter(false),
                      ],
                    ),
                  ));
            },
          ),
        );
      },
    );
  }
}
