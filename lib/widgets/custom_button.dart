import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ButtonFullColor extends StatelessWidget {
  final double? heightBtn;
  final double? widthBtn;
  final double? radiusBtn;
  final EdgeInsetsGeometry? paddingBtn;
  final String textBtn;
  final Color? colorBtn;
  final Color? colorTextBtn;
  final Color? shadowColorBtn;
  final VoidCallback onPressCallBack;
  final double? elevation;

  const ButtonFullColor({
    Key? key,
    this.heightBtn,
    this.widthBtn,
    this.radiusBtn,
    this.paddingBtn,
    required this.textBtn,
    this.colorBtn,
    this.colorTextBtn,
    this.shadowColorBtn,
    required this.onPressCallBack,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightBtn,
      width: widthBtn,
      child: ElevatedButton(
        onPressed: () {
          onPressCallBack();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radiusBtn ?? 12))),
          primary: colorBtn ?? $primaryColor,
          onPrimary: $greyColor,
          padding: paddingBtn,
          shadowColor: shadowColorBtn,
          elevation: elevation,
        ),
        child: Text(
          textBtn,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.button!.fontSize,
            fontWeight: Theme.of(context).textTheme.button!.fontWeight,
            color: colorTextBtn ?? Theme.of(context).textTheme.button!.color,
          ),
        ),
      ),
    );
  }
}

class ButtonFullColorWithIcon extends StatelessWidget {
  final double? heightBtn;
  final double? widthBtn;
  final double? radiusBtn;
  final EdgeInsetsGeometry? paddingBtn;
  final String textBtn;
  final Color? colorBtn;
  final Color? shadowColorBtn;
  final Color? colorTextBtn;
  final VoidCallback onPressCallBack;
  final IconData iconBtn;
  final Color? colorIcon;

  const ButtonFullColorWithIcon({
    Key? key,
    this.heightBtn,
    this.widthBtn,
    this.radiusBtn,
    this.paddingBtn,
    required this.textBtn,
    this.colorBtn,
    this.shadowColorBtn,
    this.colorTextBtn,
    required this.onPressCallBack,
    required this.iconBtn,
    this.colorIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightBtn,
      width: widthBtn,
      child: ElevatedButton(
        onPressed: () {
          onPressCallBack();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radiusBtn ?? 12))),
          primary: colorBtn ?? $primaryColor,
          onPrimary: $greyColor,
          padding: paddingBtn,
          shadowColor: shadowColorBtn,
        ),
        child: Wrap(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              textBtn,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.button!.fontSize,
                fontWeight: Theme.of(context).textTheme.button!.fontWeight,
                color: colorTextBtn ?? Theme.of(context).textTheme.button!.color,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Icon(
              iconBtn,
              color: colorIcon ?? $whiteColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonOutLineWithIcon extends StatelessWidget {
  final double? heightBtn;
  final double? widthBtn;
  final double? radiusBtn;
  final EdgeInsetsGeometry? paddingBtn;
  final String textBtn;
  final Color? colorBtn;
  final Color? borderColorBtn;
  final Color? shadowColorBtn;
  final VoidCallback onPressCallBack;
  final Widget iconBtn;
  final Color? textColor;
  final Color? onPrimaryBtn;
  final double? positionLeft;

  const ButtonOutLineWithIcon({
    Key? key,
    this.heightBtn,
    this.widthBtn,
    this.radiusBtn,
    this.paddingBtn,
    required this.textBtn,
    this.colorBtn,
    this.borderColorBtn,
    this.shadowColorBtn,
    required this.onPressCallBack,
    required this.iconBtn,
    this.textColor,
    this.onPrimaryBtn,
    this.positionLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressCallBack();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColorBtn ?? $greyColor),
          borderRadius: BorderRadius.all(Radius.circular(radiusBtn ?? 12)),
        ),
        primary: colorBtn ?? $whiteColor,
        onPrimary: onPrimaryBtn ?? $greyColor,
        padding: paddingBtn,
        shadowColor: shadowColorBtn,
      ),
      child: SizedBox(
        height: heightBtn,
        width: widthBtn,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Text(
              textBtn,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor ?? $blackColor,
                fontSize: Theme.of(context).textTheme.button!.fontSize,
                fontWeight: Theme.of(context).textTheme.button!.fontWeight,
                fontFamily: Theme.of(context).textTheme.button!.fontFamily,
                letterSpacing: Theme.of(context).textTheme.button!.letterSpacing,
              ),
            ),
            Positioned(
              child: iconBtn,
              left: positionLeft ?? 16,
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonOutLine extends StatelessWidget {
  final double? heightBtn;
  final double? widthBtn;
  final double? radiusBtn;
  final EdgeInsetsGeometry? paddingBtn;
  final String textBtn;
  final Color? colorBtn;
  final Color? borderColorBtn;
  final Color? shadowColorBtn;
  final VoidCallback onPressCallBack;
  final Color? textColor;
  final Color? onPrimaryBtn;

  const ButtonOutLine({
    Key? key,
    this.heightBtn,
    this.widthBtn,
    this.radiusBtn,
    this.paddingBtn,
    required this.textBtn,
    this.colorBtn,
    this.borderColorBtn,
    this.shadowColorBtn,
    required this.onPressCallBack,
    this.textColor,
    this.onPrimaryBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressCallBack();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColorBtn ?? $greyColor),
          borderRadius: BorderRadius.all(Radius.circular(radiusBtn ?? 12)),
        ),
        primary: colorBtn ?? $whiteColor,
        onPrimary: onPrimaryBtn ?? $greyColor,
        padding: paddingBtn,
        shadowColor: shadowColorBtn,
      ),
      child: SizedBox(
        height: heightBtn,
        width: widthBtn,
        child: Text(
          textBtn,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor ?? $blackColor,
            fontSize: Theme.of(context).textTheme.button!.fontSize,
            fontWeight: Theme.of(context).textTheme.button!.fontWeight,
            fontFamily: Theme.of(context).textTheme.button!.fontFamily,
            letterSpacing: Theme.of(context).textTheme.button!.letterSpacing,
          ),
        ),
      ),
    );
  }
}

class ButtonFullColorWithIconPrefix extends StatelessWidget {
  final double? heightBtn;
  final double? widthBtn;
  final double? radiusBtn;
  final EdgeInsetsGeometry? paddingBtn;
  final String textBtn;
  final Color? colorBtn;
  final Color? shadowColorBtn;
  final Color? colorTextBtn;
  final VoidCallback onPressCallBack;
  final Widget iconBtn;
  final double? space;

  const ButtonFullColorWithIconPrefix({
    Key? key,
    this.heightBtn,
    this.widthBtn,
    this.radiusBtn,
    this.paddingBtn,
    required this.textBtn,
    this.colorBtn,
    this.shadowColorBtn,
    this.colorTextBtn,
    required this.onPressCallBack,
    required this.iconBtn,
    this.space,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightBtn,
      width: widthBtn,
      child: ElevatedButton(
        onPressed: () {
          onPressCallBack();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radiusBtn ?? 12))),
          primary: colorBtn ?? $primaryColor,
          onPrimary: $greyColor,
          padding: paddingBtn,
          shadowColor: shadowColorBtn,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            iconBtn,
            SizedBox(
              width: space ?? 12,
            ),
            Text(
              textBtn,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.button!.fontSize,
                fontWeight: Theme.of(context).textTheme.button!.fontWeight,
                color: colorTextBtn ?? Theme.of(context).textTheme.button!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
