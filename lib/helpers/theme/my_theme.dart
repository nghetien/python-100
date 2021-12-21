import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../helpers.dart';

class MyTheme {
  static final lightTheme = ThemeData(
    textTheme: AppThemeLight.textTheme,
    colorScheme: const ColorScheme.light(primary: $primaryColor),
    backgroundColor: $whiteColor,
    primaryColor: $whiteColor,
    primaryColorLight: $whiteColor,
    primaryColorDark: $whiteColor,
    cardColor: $green100,
    shadowColor: $shadow7,
    appBarTheme: const AppBarTheme(
      backgroundColor: $whiteColor,
      iconTheme: IconThemeData(color: $blackColor),
      titleTextStyle: TextStyle(color: $blackColor),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: $primaryColor,
      selectionColor: $primaryColor,
      selectionHandleColor: $primaryColor,
    ),
    toggleableActiveColor: $primaryColor,
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      checkColor: MaterialStateProperty.all($primaryColor),
      side: const BorderSide(width: 1, color: $greyColor),
      splashRadius: 0,
    ),
    // dividerColor: $neutrals300,
    dividerColor: Colors.transparent,
  );

  static final darkTheme = ThemeData(
    textTheme: AppThemeDark.textTheme,
    colorScheme: const ColorScheme.light(primary: $primaryColor),
    backgroundColor: $whiteColor,
    primaryColor: $whiteColor,
    primaryColorLight: $whiteColor,
    primaryColorDark: $whiteColor,
    cardColor: $green100,
    shadowColor: $shadow7,
    appBarTheme: const AppBarTheme(
      backgroundColor: $whiteColor,
      iconTheme: IconThemeData(color: $blackColor),
      titleTextStyle: TextStyle(color: $blackColor),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: $primaryColor,
      selectionColor: $primaryColor,
      selectionHandleColor: $primaryColor,
    ),
    toggleableActiveColor: $primaryColor,
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      checkColor: MaterialStateProperty.all($primaryColor),
      side: const BorderSide(width: 1.5, color: $greyColor),
      splashRadius: 0,
    ),
    // dividerColor: $neutrals300,
    dividerColor: Colors.transparent,
  );
}
