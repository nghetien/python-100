import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ItemContainer extends StatelessWidget {
  final Widget child;
  final Function onClickItem;

  const ItemContainer({
    Key? key,
    required this.child,
    required this.onClickItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).backgroundColor,
        onPrimary: $hoverColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
        // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // alignment: Alignment.centerLeft,
      ),
      onPressed: () {
        onClickItem();
      },
      child: child,
    );
  }
}
