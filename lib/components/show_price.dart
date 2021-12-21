import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../helpers/helpers.dart';

Widget originPriceWidget({required BuildContext context, required dynamic originPrice}){
  return Text(
    "${truncateNumberToString(originPrice.toInt())} đ",
    style: TextStyle(
      decoration: TextDecoration.lineThrough,
      color: $greyColor,
      fontWeight: Theme.of(context).textTheme.headline5!.fontWeight,
      fontSize: Theme.of(context).textTheme.headline5!.fontSize,
      height: Theme.of(context).textTheme.headline5!.height,
      letterSpacing: Theme.of(context).textTheme.headline5!.letterSpacing,
    ),
  );
}

Widget priceWidget({required BuildContext context, required dynamic price}){
  return Text(
    "${truncateNumberToString(price.toInt())} đ",
    style: TextStyle(
      color: $yellow500,
      fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
      fontSize: Theme.of(context).textTheme.headline3!.fontSize,
      height: Theme.of(context).textTheme.headline3!.height,
      letterSpacing: Theme.of(context).textTheme.headline3!.letterSpacing,
    ),
  );
}