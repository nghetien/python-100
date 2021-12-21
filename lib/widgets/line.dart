import 'package:flutter/material.dart';

import '../constants/constants.dart';

class Line1 extends StatelessWidget {
  final double? widthLine;
  const Line1({Key? key, this.widthLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: $hoverColor,
          width: widthLine ?? 1,
          style: BorderStyle.solid,
        ),
      ),
    );
  }
}
