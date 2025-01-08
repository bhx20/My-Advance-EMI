import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_colors.dart';
import 'drawer/view/app_drawer.dart';

class AppScaffold extends StatelessWidget {
  final Brightness? statusBarIconBrightness;
  final Color? statusBarColor;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final Key? sKey;
  const AppScaffold(
      {super.key,
      this.statusBarIconBrightness,
      this.statusBarColor,
      this.appBar,
      this.body,
      this.floatingActionButton,
      this.drawer,
      this.bottomNavigationBar,
      this.backgroundColor,
      this.sKey});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
        statusBarColor: statusBarColor ?? AppColors.white,
      ),
      child: SafeArea(
        child: Scaffold(
          key: sKey,
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          drawer: drawer ?? appDrawer(),
          bottomNavigationBar: bottomNavigationBar,
          backgroundColor: backgroundColor ?? AppColors.white,
        ),
      ),
    );
  }
}
