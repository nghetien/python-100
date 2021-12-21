import 'package:flutter/material.dart';

import '../constants/constants.dart';

Widget infinityLoading({required BuildContext context}) {
  return Center(
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>($primaryColor),
      ),
    ),
  );
}