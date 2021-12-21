import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class AppThemeLight {
  AppThemeLight._();
  static const Color black = $blackColor;
  static const Color primary = $primaryColor;
  static const Color grey = $greyColor;
  static const Color white = $whiteColor;
  static const String roboto = 'Roboto';
  static const String lexend = 'Lexend';
  static const TextTheme textTheme = TextTheme(
    headline3: headline3,
    headline4: headline4,
    headline5: headline5,
    headline6: headline6,
    bodyText1: body1,
    bodyText2: body2,
    caption: caption1,
    button: button1,
  );

  static const TextStyle headline3 = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w600,
    fontSize: 24,
    letterSpacing: -0.03,
    height: 1.4,
    color: black,
  );

  static const TextStyle headline4 = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    letterSpacing: -0.03,
    height: 1.4,
    color: black,
  );

  static const TextStyle headline5 = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    letterSpacing: -0.03,
    height: 1.4,
    color: black,
  );

  static const TextStyle headline6 = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.02,
    height: 1.4,
    color: black,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: roboto,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 1.1,
    color: black,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: roboto,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.6,
    color: grey,
  );

  static const TextStyle caption3 = TextStyle(
    fontFamily: roboto,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.6,
    color: primary,
  );

  static const TextStyle caption2 = TextStyle(
    fontFamily: roboto,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.6,
    color: primary,
  );

  static const TextStyle caption1 = TextStyle(
    fontFamily: roboto,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.4,
    color: grey,
  );

  static const TextStyle button1 = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    letterSpacing: -0.02,
    color: white,
  );

  static const TextStyle button2 = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.02,
    color: $neutrals500,
  );
}

class AppThemeDark {
  AppThemeDark._();
  static const Color black = $blackColor;
  static const Color primary = $primaryColor;
  static const Color grey = $greyColor;
  static const Color white = $whiteColor;
  static const String roboto = 'Roboto';
  static const String lexend = 'Lexend';
  static const TextTheme textTheme = TextTheme(
    headline3: headline3,
    headline5: headline5,
    headline6: headline6,
    bodyText1: body1,
    bodyText2: body2,
    caption: caption1,
    button: button1,
    // subtitle1: caption2,
    // subtitle2: button2,
  );

  static const TextStyle headline3 = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w600,
    fontSize: 24,
    letterSpacing: -0.03,
    height: 1.4,
    color: white,
  );

  static const TextStyle headline4 = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    letterSpacing: -0.03,
    height: 1.4,
    color: white,
  );

  static const TextStyle headline5 = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    letterSpacing: -0.03,
    height: 1.4,
    color: white,
  );

  static const TextStyle headline6 = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.02,
    height: 1.4,
    color: white,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: roboto,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 1.1,
    color: white,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: roboto,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.6,
    color: white,
  );

  static const TextStyle caption2 = TextStyle(
    fontFamily: roboto,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.6,
    color: primary,
  );

  static const TextStyle caption1 = TextStyle(
    fontFamily: roboto,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.4,
    color: grey,
  );

  static const TextStyle button1 = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    letterSpacing: -0.02,
    color: white,
  );

  static const TextStyle button2 = TextStyle(
    fontFamily: lexend,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.02,
    color: $neutrals500,
  );
}