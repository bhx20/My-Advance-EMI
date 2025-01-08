import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';

//==============================================================================
// ** Custom Theme  **
//==============================================================================
final ThemeData customTheme = ThemeData(
    useMaterial3: true,
    fontFamily: TextFontFamily.NotoSans,
    primaryColor: AppColors.white.withOpacity(0.08),
    appBarTheme: _appBarTheme(),
    bottomNavigationBarTheme: _bottomBarTheme(),
    iconTheme: _iconThem(),
    dividerTheme: _dividerTheme(),
    progressIndicatorTheme: _loaderTheme(),
    tabBarTheme: _tabTheme(),
    elevatedButtonTheme: _elevatedButtonTheme(),
    outlinedButtonTheme: _outlineButtonTheme(),
    textButtonTheme: _textButtonTheme(),
    primaryIconTheme: _iconThem(),
    datePickerTheme: _datePickerThemeData());

//==============================================================================
// ** Helper Function  **
//==============================================================================

DatePickerThemeData _datePickerThemeData() => DatePickerThemeData(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      headerForegroundColor: AppColors.white,
      headerBackgroundColor: AppColors.appColor,
      dividerColor: AppColors.appColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );

TextButtonThemeData _textButtonTheme() =>
    const TextButtonThemeData(style: ButtonStyle());

OutlinedButtonThemeData _outlineButtonTheme() {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: AppColors.appColor),
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

ElevatedButtonThemeData _elevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.appColor,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

TabBarTheme _tabTheme() {
  return TabBarTheme(
    labelColor: AppColors.black,
    unselectedLabelColor: AppColors.black,
    indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 2.0,
          color: AppColors.appColor,
        ),
        insets: const EdgeInsets.symmetric(horizontal: 5.0)),
  );
}

ProgressIndicatorThemeData _loaderTheme() =>
    const ProgressIndicatorThemeData(color: AppColors.black);

DividerThemeData _dividerTheme() => const DividerThemeData(
      color: AppColors.black,
    );

IconThemeData _iconThem() {
  return const IconThemeData(
    color: AppColors.black,
  );
}

BottomNavigationBarThemeData _bottomBarTheme() =>
    const BottomNavigationBarThemeData();

AppBarTheme _appBarTheme() {
  return AppBarTheme(
    backgroundColor: AppColors.white,
    titleTextStyle: notoSans.get20.w500.black,
    elevation: 0,
    actionsIconTheme: const IconThemeData(color: AppColors.black, size: 20),
    iconTheme: const IconThemeData(color: AppColors.black),
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: AppColors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
}
