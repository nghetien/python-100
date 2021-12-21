import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/constants.dart';
import '../../../../widgets/widgets.dart';
import '../../../../components/components.dart';
import '../../lesson_details/models/models.dart';

class QuestionCodeEditor extends StatefulWidget {
  final String statementQuestion;
  final QuestionData questionData;

  const QuestionCodeEditor({
    Key? key,
    required this.statementQuestion,
    required this.questionData,
  }) : super(key: key);

  @override
  _QuestionCodeEditorState createState() => _QuestionCodeEditorState();
}

class _QuestionCodeEditorState extends State<QuestionCodeEditor> {
  _formSampleTestCase({required int index, required String input, required String output}) {
    List<Widget> inputWidget = [];
    if (input.isNotEmpty) {
      inputWidget = [
        Text(
          "${AppLocalizations.of(context)!.input_example} $index",
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
            fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
            fontFamily: Theme.of(context).textTheme.headline5!.fontFamily,
            color: Theme.of(context).textTheme.headline5!.color,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          color: $backgroundGreyColor,
          child: Text(
            input,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ];
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...inputWidget,
          Text(
            "${AppLocalizations.of(context)!.output_example} $index",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
              fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
              fontFamily: Theme.of(context).textTheme.headline5!.fontFamily,
              color: Theme.of(context).textTheme.headline5!.color,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: $backgroundGreyColor,
            child: Text(
              output,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }

  _titleText(String title) {
    return Text(
      title,
      style: TextStyle(
        color: $primaryColor,
        fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
        fontSize: Theme.of(context).textTheme.headline3!.fontSize,
        fontFamily: Theme.of(context).textTheme.headline3!.fontFamily,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listSampleTest = [];
    final QuestionData questionData = widget.questionData;
    final List<QuestionTestCase> listQuestionTestCase = questionData.sampleTestcases ?? [];
    for (int i = 0; i < listQuestionTestCase.length; i++) {
      listSampleTest.add(_formSampleTestCase(
        index: i + 1,
        input: listQuestionTestCase[i].input ?? "",
        output: listQuestionTestCase[i].output ?? "",
      ));
    }
    List<Widget> inputDecsWidget = [];
    if (questionData.inputDesc != null && questionData.inputDesc!.isNotEmpty) {
      inputDecsWidget = [
        const SizedBox(
          height: 24,
        ),
        _titleText(AppLocalizations.of(context)!.input_description),
        const SizedBox(
          height: 8,
        ),
        showMathJaxHtml(
          questionData.inputDesc ?? "",
          weight: TeXViewFontWeight.w300,
          fontSize: 18,
          fontFamily: 'Roboto',
        ),
      ];
    }
    List<Widget> constraintsWidget = [];
    if (questionData.constraints != null && questionData.constraints!.isNotEmpty) {
      constraintsWidget = [
        const SizedBox(
          height: 24,
        ),
        _titleText(AppLocalizations.of(context)!.constraints),
        const SizedBox(
          height: 8,
        ),
        showMathJaxHtml(
          questionData.constraints ?? "",
          weight: TeXViewFontWeight.w300,
          fontSize: 18,
          fontFamily: 'Roboto',
        ),
      ];
    }
    List<Widget> outputDescWidget = [];
    if (questionData.outputDesc != null && questionData.outputDesc!.isNotEmpty) {
      outputDescWidget = [
        const SizedBox(
          height: 24,
        ),
        _titleText(AppLocalizations.of(context)!.output_description),
        const SizedBox(
          height: 8,
        ),
        showMathJaxHtml(
          questionData.outputDesc ?? "",
          weight: TeXViewFontWeight.w300,
          fontSize: 18,
          fontFamily: 'Roboto',
        ),
      ];
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 24,
          ),
          Row(
            children: <Widget>[
              ShowUCoinTextBold(
                number: questionData.uCoin,
                isStart: true,
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: Text(
                  questionData.difficultLevel == $medium
                      ? AppLocalizations.of(context)!.medium
                      : questionData.difficultLevel == $hard
                          ? AppLocalizations.of(context)!.hard
                          : AppLocalizations.of(context)!.easy,
                  style: TextStyle(
                    height: 1.2,
                    fontWeight: Theme.of(context).textTheme.headline4!.fontWeight,
                    fontFamily: Theme.of(context).textTheme.headline4!.fontFamily,
                    color: questionData.difficultLevel == $medium
                        ? $yellow500
                        : questionData.difficultLevel == $hard
                            ? $errorColor
                            : $greyColor,
                    fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          _titleText(questionData.name),
          const SizedBox(
            height: 8,
          ),
          showMathJaxHtml(
            widget.statementQuestion,
            weight: TeXViewFontWeight.w300,
            fontSize: 18,
            fontFamily: 'Roboto',
          ),
          ...inputDecsWidget,
          ...constraintsWidget,
          ...outputDescWidget,
          const SizedBox(
            height: 24,
          ),
          _titleText(AppLocalizations.of(context)!.testcase_example),
          const SizedBox(
            height: 12,
          ),
          ...listSampleTest,
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
