import 'package:flutter/material.dart';

List<int> getRGB(Color color) {
  return [color.red, color.green, color.blue];
}

Color generateColor(Color color, double alpha){
  final List<int> rgb = getRGB(color);
  return Color.fromRGBO(rgb[0], rgb[1], rgb[2], alpha);
}

/// green
const $green600 = Color(0xFF1A8E3A);
const $green500 = Color(0xFF20B149);
const $green400 = Color(0xFF4DC16D);
const $green300 = Color(0xFF79D092);
const $green200 = Color(0xFFD2EFDB);
const $green100 = Color(0xFFE9F7ED);

/// yellow
const $yellow600 = Color(0xFFE3A200);
const $yellow500 = Color(0xFFFCB400);
const $yellow400 = Color(0xFFFCBC19);
const $yellow300 = Color(0xFFFDCB4D);
const $yellow200 = Color(0xFFFEDA80);
const $yellow100 = Color(0xFFFFEFC7);

/// neutrals
const $neutrals700 = Color(0xFF141416);
const $neutrals600 = Color(0xFF23262F);
const $neutrals500 = Color(0xFF353945);
const $neutrals400 = Color(0xFF777E90);
const $neutrals350 = Color(0xFFAAABB4);
const $neutrals300 = Color(0xFFE6E8EC);
const $neutrals200 = Color(0xFFF4F5F6);
const $neutrals100 = Color(0xFFFCFCFD);

/// red
const $red700 = Color(0xFFCC1D1D);
const $red600 = Color(0xFFE62020);
const $red500 = Color(0xFFFF2424);
const $red300 = Color(0xFFFF7C7C);
const $red200 = Color(0xFFFFA7A7);
const $red100 = Color(0xFFFFE5E5);

/// shadow
const $shadow7 = Color.fromRGBO(15, 15, 15, 0.07);
const $shadow8 = Color.fromRGBO(15, 15, 15, 0.08);

/// App Color
const $primaryColor = $green500;

/// green 500
const $whiteColor = Color(0xFFFFFFFF);
const $blackColor = $neutrals700;

/// neutrals 700
const $greyColor = Color(0xFF777E91);
const $backgroundGreyColor = $neutrals200;

/// neutrals 200
const $loaderColor = Color(0x75FCFCFD);
const $errorColor = Color(0xFFFA5C5C);
const $hoverColor = $neutrals300;

/// Code Editor
const $backgroundCodeEditor = Color(0xff282c34);
const $backgroundBtnCodeEditor = Color(0xff38383e);

// const $uPrimaryDarkColor = Color(0xFF1e1e2f);
// const $uPrimaryDarkColorLight = Color(0xFF27293d);
