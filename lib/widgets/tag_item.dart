// import 'package:flutter/material.dart';
// import 'package:uschool/constants/constants.dart';
//
// class TagItem extends StatelessWidget {
//   final String nameTag;
//   final Color? colorTag;
//
//   const TagItem({
//     Key? key,
//     required this.nameTag,
//     this.colorTag,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(right: 5),
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       decoration:
//           BoxDecoration(color: colorTag ?? $backgroundGreyColor, borderRadius: const BorderRadius.all(Radius.circular(4))),
//       child: Text(
//         "#$nameTag",
//         style: TextStyle(
//           color: colorTag == $green100 ? $primaryColor : Theme.of(context).textTheme.caption!.color,
//           fontSize: Theme.of(context).textTheme.caption!.fontSize,
//           fontWeight: Theme.of(context).textTheme.caption!.fontWeight,
//         ),
//       ),
//     );
//   }
// }
