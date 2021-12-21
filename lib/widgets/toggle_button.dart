import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'widgets.dart';

class ToggleButton extends StatelessWidget {
  final String title1;
  final String title2;
  final bool value;
  final Function handleChangeValue1;
  final Function handleChangeValue2;

  const ToggleButton({
    Key? key,
    required this.title1,
    required this.title2,
    required this.value,
    required this.handleChangeValue1,
    required this.handleChangeValue2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      decoration: BoxDecoration(
        color: $backgroundGreyColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          ButtonFullColor(
            textBtn: title1,
            colorBtn: value ? $whiteColor : $backgroundGreyColor,
            colorTextBtn: value ? $blackColor : $greyColor,
            elevation: 0,
            onPressCallBack: () {
              handleChangeValue1();
            },
          ),
          ButtonFullColor(
            textBtn: title2,
            colorBtn: !value ? $whiteColor : $backgroundGreyColor,
            colorTextBtn: !value ? $blackColor : $greyColor,
            elevation: 0,
            onPressCallBack: () {
              handleChangeValue2();
            },
          ),
        ],
      ),
    );
  }
}
