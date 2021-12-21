import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/components.dart';
import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class QuizTheory extends StatefulWidget {
  final QuestionData questionData;
  final int index;
  final bool titleStart;

  const QuizTheory({
    Key? key,
    required this.questionData,
    required this.index,
    this.titleStart = false,
  }) : super(key: key);

  @override
  _QuizTheoryState createState() => _QuizTheoryState();
}

class _QuizTheoryState extends State<QuizTheory> {
  late final Map<String, dynamic> listTheory;

  @override
  void initState() {
    if (widget.questionData.options != null) {
      listTheory = json.decode(widget.questionData.statementMedia ?? "");
    } else {
      listTheory = {};
    }
    super.initState();
  }

  _container({required String name, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 8,
          ),
          child,
        ],
      ),
    );
  }

  _body() {
    final size = MediaQuery.of(context).size;
    final ori = MediaQuery.of(context).orientation;
    List<Widget> listItem = [];
    if (listTheory[$text] != null && listTheory[$text].isNotEmpty) {
      switch (listTheory[$textType]) {
        case $markdown:
          listItem.add(
            answerKatexToHtml(katex: listTheory[$text], onSelect: () {}),
          );
          break;
        case $html:
          listItem.add(renderHtml(htmlString: listTheory[$text], context: context));
          break;
        default:
          listItem.add(
            Text(
              listTheory[$text],
              style: Theme.of(context).textTheme.headline6,
            ),
          );
          break;
      }
    }
    if (listTheory[$image] != null && listTheory[$image].isNotEmpty) {
      listItem.add(
        _container(
            child: CachedNetworkImage(
              imageUrl: listTheory[$image],
              fit: BoxFit.fitWidth,
              errorWidget: (context, url, error) {
                return Image.asset($assetsImageDefaultBanner);
              },
            ),
            name: "${AppLocalizations.of(context)!.image}:"),
      );
    }
    if (listTheory[$video] != null && listTheory[$video].isNotEmpty) {
      listItem.add(_container(
          child: Container(
            color: Colors.black,
            height: ori == Orientation.portrait ? size.width * 9 / 16 : size.height * 0.4,
            width: size.width,
            child: Center(
              child: YoutubeViewer(
                videoUrl: listTheory[$video],
                autoPlayVideo: false,
              ),
            ),
          ),
          name: "Video:"));
    }
    if (listTheory[$sound] != null && listTheory[$sound].isNotEmpty) {
      listItem.add(
        _container(child: PlaySound(urlSound: listTheory[$sound]), name: "${AppLocalizations.of(context)!.sound}:"),
      );
    }
    if (listTheory[$fileQuestion] != null && listTheory[$fileQuestion].isNotEmpty) {
      listItem.add(
        _container(child: DownloadFile(urlFile: listTheory[$fileQuestion]), name: "File:"),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: widget.titleStart == true ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                    child: Text(
                  "${AppLocalizations.of(context)!.question} ${(widget.index + 1).toString()} :",
                  style: Theme.of(context).textTheme.headline4,
                )),
                const SizedBox(
                  width: 8,
                ),
                ShowUCoinWithBorder(totalUCoin: widget.questionData.uCoin),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            _body(),
          ],
        ),
      ),
    );
  }
}
