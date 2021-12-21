import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget createDialog(BuildContext context, String title, String value) => CupertinoAlertDialog(
  title: Text(
    title,
    style: const TextStyle(fontSize: 22),
  ),
  content: Text(
    value,
    style: const TextStyle(fontSize: 16),
  ),
  actions: [
    CupertinoDialogAction(
      child: Text(AppLocalizations.of(context)!.cancel),
      onPressed: () {
        Navigator.pop(context, false);
      },
    ),
    CupertinoDialogAction(
      child: Text(AppLocalizations.of(context)!.ok),
      onPressed: () {
        Navigator.pop(context, true);
      },
    ),
  ],
);