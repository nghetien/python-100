import 'package:flutter/material.dart';

import '../constants/constants.dart';

class InputOutLine extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputAction? actionInput;
  final TextInputType? typeInput;
  final Function(String)? onSubmit;
  final Function(String)? onChange;
  final Color? textColor;
  final Color? backgroundColor;
  final Widget? prefixIconInput;
  final Widget? suffixIconInput;
  final EdgeInsetsGeometry? paddingInput;
  final Color? colorBorderFocusInput;
  final double? widthBorderFocusInput;
  final Color? colorBorderInput;
  final double? widthBorderInput;
  final String hintTextInput;
  final Color? colorHintTextInput;
  final bool? isShow;
  final double? borderRadius;
  final FocusNode? focusInput;
  final Function? onEditingCompleteInput;
  final List<BoxShadow>? listBoxShadow;
  final bool? enable;

  const InputOutLine({
    Key? key,
    required this.textEditingController,
    this.actionInput,
    this.typeInput,
    this.onSubmit,
    this.onChange,
    this.textColor,
    this.backgroundColor,
    this.prefixIconInput,
    this.suffixIconInput,
    this.paddingInput,
    this.colorBorderFocusInput,
    this.widthBorderFocusInput,
    this.colorBorderInput,
    this.widthBorderInput,
    required this.hintTextInput,
    this.colorHintTextInput,
    this.isShow,
    this.borderRadius,
    this.focusInput,
    this.onEditingCompleteInput,
    this.listBoxShadow,
    this.enable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: listBoxShadow,
      ),
      child: TextFormField(
        enabled: enable,
        controller: textEditingController,
        textInputAction: actionInput ?? TextInputAction.done,
        keyboardType: typeInput ?? TextInputType.text,
        focusNode: focusInput ?? FocusNode(skipTraversal: false),
        style: TextStyle(
          color: textColor ?? $greyColor,
        ),
        obscureText: isShow ?? false,
        decoration: InputDecoration(
          fillColor: backgroundColor ?? $backgroundGreyColor,
          filled: true,
          prefixIcon: prefixIconInput,
          suffixIcon: suffixIconInput,
          contentPadding: paddingInput,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorBorderFocusInput ?? $greyColor,
              width: widthBorderFocusInput ?? 1,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorBorderInput ?? $backgroundGreyColor,
              width: widthBorderInput ?? 1,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
          hintText: hintTextInput,
          hintStyle: TextStyle(
            color: colorHintTextInput ?? $greyColor,
            fontWeight: Theme.of(context).textTheme.bodyText2!.fontWeight,
            fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
            fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
          ),
        ),
        onFieldSubmitted: onSubmit != null
            ? (value) {
                onSubmit!(value);
              }
            : null,
        onChanged: onChange != null
            ? (value) {
                onChange!(value);
              }
            : null,
        onEditingComplete: onEditingCompleteInput != null
            ? () {
                onEditingCompleteInput!();
              }
            : null,
      ),
    );
  }
}
