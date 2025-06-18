import 'package:flutter/material.dart';
import 'package:pharma/model/colors.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.blueLight,
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    toolbarHeight: 80,
    centerTitle: true,
    titleTextStyle: TextStyle(color: AppColors.blueDark, fontSize: 20),
    iconTheme: IconThemeData(color: AppColors.blueDark),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 15, 58, 109),
  ),
);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.grayDark,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.black,
    centerTitle: true,

    iconTheme: IconThemeData(color: AppColors.grayLight),

    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
);
