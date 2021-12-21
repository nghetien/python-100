import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/constants.dart';

void showSnackBar(BuildContext context,
    {String? title, required String message, IconData? icon, required Color backgroundColor, Color? textColor}) {
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    padding: const EdgeInsets.all(5),
    margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    title: title ?? AppLocalizations.of(context)!.notification,
    titleColor: textColor ?? $whiteColor,
    message: message,
    messageColor: textColor ?? $whiteColor,
    backgroundColor: backgroundColor,
    icon: Icon(
      icon ?? Icons.info_outline,
      size: 34,
      color: textColor ?? $whiteColor,
    ),
    duration: const Duration(seconds: 3),
    borderRadius: BorderRadius.circular(7),
  ).show(context);
}

void showSimpleSnackBar({
  required BuildContext context,
  required String value,
  IconData? icon,
  Color? textColor,
  Color? backgroundColor,
}) {
  final snackBar = SnackBar(
    content: Text(
      value,
      style: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
        fontWeight: Theme.of(context).textTheme.headline6!.fontWeight,
        color: textColor,
      ),
    ),
    backgroundColor: backgroundColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
