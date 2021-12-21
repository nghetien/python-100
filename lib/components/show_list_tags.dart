import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ShowListTags extends StatelessWidget {
  final List<dynamic>? listTags;

  const ShowListTags({
    Key? key,
    required this.listTags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (listTags == null || listTags!.isEmpty) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Wrap(
          children: listTags!
              .map<Widget>((tag) => TagItem(
                    nameTag: tag.toString(),
                  ))
              .toList(),
        ),
      );
    }
  }
}

class TagItem extends StatelessWidget {
  final String nameTag;
  final Color? colorTag;
  final Color? colorTextTag;

  const TagItem({
    Key? key,
    required this.nameTag,
    this.colorTag,
    this.colorTextTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: colorTag ?? $backgroundGreyColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "#$nameTag",
        style: TextStyle(
          color: colorTextTag ?? Theme.of(context).textTheme.caption!.color,
          fontFamily: Theme.of(context).textTheme.caption!.fontFamily,
          fontWeight: Theme.of(context).textTheme.caption!.fontWeight,
          fontSize: Theme.of(context).textTheme.caption!.fontSize,
          height: Theme.of(context).textTheme.caption!.height,
        ),
      ),
    );
  }
}
