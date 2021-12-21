import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/components.dart';
import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class QuizMultipleChoice extends StatefulWidget {
  final QuestionData questionData;
  final int index;
  final Function(List<bool>) onChangeSelect;
  final bool titleStart;
  final List<bool>? defaultValue;

  const QuizMultipleChoice({
    Key? key,
    required this.questionData,
    required this.index,
    required this.onChangeSelect,
    this.titleStart = false,
    this.defaultValue,
  }) : super(key: key);

  @override
  _QuizMultipleChoiceState createState() => _QuizMultipleChoiceState();
}

class _QuizMultipleChoiceState extends State<QuizMultipleChoice> {
  late final List<dynamic> listAnswerChoice;
  late List<bool> myAnswer;

  @override
  void initState() {
    if (widget.questionData.options != null) {
      listAnswerChoice = json.decode(widget.questionData.options ?? "");
    }else{
      listAnswerChoice = [];
    }
    if(widget.defaultValue != null && widget.defaultValue!.isNotEmpty){
      myAnswer = widget.defaultValue!;
    }else{
      myAnswer = listAnswerChoice.map((e) => false).toList();
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

  _showAnswerChoice(int indexAnswerChoice) {
    final size = MediaQuery.of(context).size;
    final ori = MediaQuery.of(context).orientation;
    List<Widget> listItem = [];
    final currentAnswer = listAnswerChoice[indexAnswerChoice];
    if (currentAnswer[$text] != null && currentAnswer[$text].isNotEmpty) {
      switch (currentAnswer[$textType]) {
        case $markdown:
          listItem.add(
            answerKatexToHtml(
              katex: currentAnswer[$text],
              onSelect: () {
                setState(() {
                  myAnswer[indexAnswerChoice] = !myAnswer[indexAnswerChoice];
                });
                widget.onChangeSelect(myAnswer);
              },
            ),
          );
          break;
        case $html:
          listItem.add(renderHtml(htmlString: currentAnswer[$text], context: context));
          break;
        default:
          listItem.add(Text(
            currentAnswer[$text],
            style: Theme.of(context).textTheme.headline6,
          ));
          break;
      }
    }
    if (currentAnswer[$image] != null && currentAnswer[$image].isNotEmpty) {
      listItem.add(
        _container(
            child: CachedNetworkImage(
              imageUrl: currentAnswer[$image],
              fit: BoxFit.fitWidth,
              errorWidget: (context, url, error) {
                return Image.asset($assetsImageDefaultBanner);
              },
            ),
            name: "${AppLocalizations.of(context)!.image}:"),
      );
    }
    if (currentAnswer[$video] != null && currentAnswer[$video].isNotEmpty) {
      listItem.add(_container(
          child: Container(
            color: Colors.black,
            height: ori == Orientation.portrait ? size.width * 9 / 16 : size.height * 0.4,
            width: size.width,
            child: Center(
              child: YoutubeViewer(
                videoUrl: currentAnswer[$video],
                autoPlayVideo: false,
              ),
            ),
          ),
          name: "Video:"));
    }
    if (currentAnswer[$sound] != null && currentAnswer[$sound].isNotEmpty) {
      listItem.add(
        _container(child: PlaySound(urlSound: currentAnswer[$sound]), name: "${AppLocalizations.of(context)!.sound}:"),
      );
    }
    if (currentAnswer[$fileQuestion] != null && currentAnswer[$fileQuestion].isNotEmpty) {
      listItem.add(
        _container(child: DownloadFile(urlFile: currentAnswer[$fileQuestion]), name: "File:"),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listItem,
    );
  }

  _choiceItem({
    required Function(bool?) onChoiceAnswer,
    required int index,
  }) {
    bool valueChoice = myAnswer[index];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: valueChoice ? $primaryColor : $hoverColor),
          borderRadius: BorderRadius.circular(15)),
      child: Theme(
        data: ThemeData(
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(width: 1, color: $greyColor),
            splashRadius: 0,
          ),
        ),
        child: CheckboxListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          tileColor: $whiteColor,
          activeColor: $primaryColor,
          contentPadding: const EdgeInsets.only(right: 8),
          controlAffinity: ListTileControlAffinity.leading,
          value: valueChoice,
          onChanged: (value) {
            onChoiceAnswer(value);
          },
          title: _showAnswerChoice(index),
        ),
      ),
    );
  }

  _body() {
    if (listAnswerChoice.isNotEmpty) {
      List<Widget> listChoice = [];
      for (int index = 0; index < listAnswerChoice.length; index++) {
        listChoice.add(
          _choiceItem(
            onChoiceAnswer: (value) {
              setState(() {
                myAnswer[index] = !myAnswer[index];
              });
              widget.onChangeSelect(myAnswer);
            },
            index: index,
          ),
        );
      }
      return Column(
        children: listChoice,
      );
    }
    return infinityLoading(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const SizedBox(width: 8,),
              ShowUCoinWithBorder(totalUCoin: widget.questionData.uCoin),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          showMathJaxHtml(widget.questionData.statement),
          const SizedBox(
            height: 24,
          ),
          Text(
            AppLocalizations.of(context)!.select_multiple_answer,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          _body(),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
