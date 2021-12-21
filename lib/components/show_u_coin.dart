import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../helpers/helpers.dart';

class ShowUCoinWithBorder extends StatelessWidget {
  final int totalUCoin;
  final Color? backgroundColor;

  const ShowUCoinWithBorder({
    Key? key,
    required this.totalUCoin,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: $hoverColor, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor ?? Theme.of(context).backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            truncateNumberToUCoin(totalUCoin),
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(
            width: 5,
          ),
          Image.asset(
            $assetsImageUCoin,
            height: 16,
            fit: BoxFit.fitHeight,
          ),
        ],
      ),
    );
  }
}

class ShowUCoin extends StatelessWidget {
  final double? heightItem;
  final double? widthItem;
  final int totalUCoin;
  final EdgeInsets? paddingItem;

  const ShowUCoin({
    Key? key,
    this.heightItem,
    this.widthItem,
    required this.totalUCoin,
    this.paddingItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddingItem,
      height: heightItem,
      width: widthItem,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Text(
              truncateNumberToString(totalUCoin),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Image.asset($assetsImageUCoin),
        ],
      ),
    );
  }
}

class ShowUCoinTextBold extends StatelessWidget {
  final dynamic number;
  final double? height;
  final bool? isStart;

  const ShowUCoinTextBold({Key? key, required this.number, this.height,this.isStart,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 25,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: isStart == true ? MainAxisAlignment.start :MainAxisAlignment.end,
        children: <Widget>[
          Text(
            truncateNumberToString(number),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              height: 1.2,
              fontWeight: Theme.of(context).textTheme.headline4!.fontWeight,
              fontFamily: Theme.of(context).textTheme.headline4!.fontFamily,
              color: Theme.of(context).textTheme.headline4!.color,
              fontSize: Theme.of(context).textTheme.headline4!.fontSize,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Image.asset($assetsImageUCoin),
        ],
      ),
    );
  }
}
