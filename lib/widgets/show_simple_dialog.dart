import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/constants.dart';
import 'widgets.dart';

Future<bool?> showSimpleDialog({
  required BuildContext context,
  EdgeInsetsGeometry? titlePadding,
  required EdgeInsetsGeometry contentPadding,
  required EdgeInsetsGeometry actionsPadding,
  required String title,
  required String content,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: titlePadding,
        contentPadding: contentPadding,
        actionsPadding: actionsPadding,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.headline4!.color,
            fontFamily: Theme.of(context).textTheme.headline4!.fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: Theme.of(context).textTheme.headline4!.fontSize,
            height: Theme.of(context).textTheme.headline4!.height,
            letterSpacing: Theme.of(context).textTheme.headline4!.letterSpacing,
          ),
        ),
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: $neutrals500,
            fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
            fontWeight: Theme.of(context).textTheme.bodyText2!.fontWeight,
            fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
            height: Theme.of(context).textTheme.bodyText2!.height,
          ),
        ),
        actions: [
          Row(
            children: <Widget>[
              Expanded(
                child: ButtonOutLine(
                  borderColorBtn: $neutrals300,
                  paddingBtn: const EdgeInsets.symmetric(vertical: 12),
                  textBtn: AppLocalizations.of(context)!.cancel,
                  onPressCallBack: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: ButtonFullColor(
                  paddingBtn: const EdgeInsets.symmetric(vertical: 12),
                  textBtn: AppLocalizations.of(context)!.ok,
                  onPressCallBack: () {
                    Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<bool?> showInfoDialog({
  required BuildContext context,
  EdgeInsetsGeometry? titlePadding,
  required EdgeInsetsGeometry contentPadding,
  required EdgeInsetsGeometry actionsPadding,
  required String title,
  required String content,
  required Widget icon,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: titlePadding,
        contentPadding: contentPadding,
        actionsPadding: actionsPadding,
        title: icon,
        content: SizedBox(
          height: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline4!.color,
                  fontFamily: Theme.of(context).textTheme.headline4!.fontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                  height: Theme.of(context).textTheme.headline4!.height,
                  letterSpacing: Theme.of(context).textTheme.headline4!.letterSpacing,
                ),
              ),
              Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: $neutrals500,
                  fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
                  fontWeight: Theme.of(context).textTheme.bodyText2!.fontWeight,
                  fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
                  height: Theme.of(context).textTheme.bodyText2!.height,
                ),
              ),
            ],
          ),
        )
      );
    },
  );
}

Future<bool?> showWidgetDialog({
  required BuildContext context,
  EdgeInsetsGeometry? titlePadding,
  required EdgeInsetsGeometry contentPadding,
  required EdgeInsetsGeometry actionsPadding,
  required Widget widget,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          titlePadding: titlePadding,
          contentPadding: contentPadding,
          actionsPadding: actionsPadding,
          content: widget
      );
    },
  );
}