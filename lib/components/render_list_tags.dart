// import 'package:flutter/material.dart';
// import 'package:uschool/constants/constants.dart';
// import 'package:uschool/widget/widget.dart';
//
// class RenderListTags extends StatelessWidget {
//   final List<dynamic> listTags;
//
//   const RenderListTags({
//     Key? key,
//     required this.listTags,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (listTags.isEmpty) {
//       return const SizedBox(
//         height: 0,
//         width: 0,
//       );
//     } else {
//       List<Widget> listItem = [];
//       for (int i = 0; i < listTags.length; i++) {
//         if (i % 2 == 0) {
//           listItem.add(TagItem(nameTag: "#${listTags[i].toString()}", colorTag: $green100));
//         } else {
//           listItem.add(TagItem(nameTag: "#${listTags[i].toString()}"));
//         }
//       }
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Wrap(
//           children: listItem,
//         ),
//       );
//     }
//   }
// }
