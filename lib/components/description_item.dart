import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constants.dart';

class DescriptionItem extends StatelessWidget {
  final String urlSvg;
  final String title;
  final String text;
  final VoidCallback onPressCallBack;

  const DescriptionItem({
    Key? key,
    required this.urlSvg,
    required this.title,
    required this.text,
    required this.onPressCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: -8,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          onPressCallBack();
        },
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          primary: Theme.of(context).backgroundColor,
          onPrimary: $green100,
          padding: const EdgeInsets.all(24),
        ),
        child: Column(
          children: <Widget>[
            SvgPicture.asset(
              urlSvg,
              width: 56,
              height: 56,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
