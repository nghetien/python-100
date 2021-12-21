import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/components.dart';
import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../states/states.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class QuizCode extends StatefulWidget {
  final QuestionData questionData;

  const QuizCode({
    Key? key,
    required this.questionData,
  }) : super(key: key);

  @override
  _QuizCodeState createState() => _QuizCodeState();
}

class _QuizCodeState extends State<QuizCode> {
  final LessonQuizController _lessonQuizController = Get.find<LessonQuizController>();

  late final String statement;

  @override
  void initState() {
    String temp = widget.questionData.statement;
    temp = temp.replaceAll("[//]: # ()", "");
    statement = temp;
    super.initState();
  }

  _titleText(String title) {
    return Text(
      title,
      style: TextStyle(
          color: $primaryColor,
          fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
          fontSize: Theme.of(context).textTheme.headline3!.fontSize,
          fontFamily: Theme.of(context).textTheme.headline3!.fontFamily),
    );
  }

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

  _body() {
    List<Widget> listSampleTest = [];
    if (widget.questionData.sampleTestcases != null && widget.questionData.sampleTestcases!.isNotEmpty) {
      for (int i = 0; i < widget.questionData.sampleTestcases!.length; i++) {
        listSampleTest.add(_formSampleTestCase(
          index: i + 1,
          input: widget.questionData.sampleTestcases![i].input ?? "",
          output: widget.questionData.sampleTestcases![i].output ?? "",
        ));
      }
    }
    List<Widget> inputDecsWidget = [];
    if (widget.questionData.inputDesc != null && widget.questionData.inputDesc!.isNotEmpty) {
      inputDecsWidget = [
        const SizedBox(
          height: 24,
        ),
        _titleText(AppLocalizations.of(context)!.input_description),
        const SizedBox(
          height: 8,
        ),
        showMathJaxHtml(
          widget.questionData.inputDesc ?? "",
          weight: TeXViewFontWeight.w300,
          fontSize: 18,
          fontFamily: 'Roboto',
        ),
      ];
    }
    List<Widget> constraintsWidget = [];
    if (widget.questionData.constraints != null && widget.questionData.constraints!.isNotEmpty) {
      constraintsWidget = [
        const SizedBox(
          height: 24,
        ),
        _titleText(AppLocalizations.of(context)!.constraints),
        const SizedBox(
          height: 8,
        ),
        showMathJaxHtml(
          widget.questionData.constraints ?? "",
          weight: TeXViewFontWeight.w300,
          fontSize: 18,
          fontFamily: 'Roboto',
        ),
      ];
    }
    List<Widget> outputDescWidget = [];
    if (widget.questionData.outputDesc != null && widget.questionData.outputDesc!.isNotEmpty) {
      outputDescWidget = [
        const SizedBox(
          height: 24,
        ),
        _titleText(AppLocalizations.of(context)!.output_description),
        const SizedBox(
          height: 8,
        ),
        showMathJaxHtml(
          widget.questionData.outputDesc ?? "",
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
                number: widget.questionData.uCoin,
                isStart: true,
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: Text(
                  widget.questionData.difficultLevel == $medium
                      ? AppLocalizations.of(context)!.medium
                      : widget.questionData.difficultLevel == $hard
                          ? AppLocalizations.of(context)!.hard
                          : AppLocalizations.of(context)!.easy,
                  style: TextStyle(
                    height: 1.2,
                    fontWeight: Theme.of(context).textTheme.headline4!.fontWeight,
                    fontFamily: Theme.of(context).textTheme.headline4!.fontFamily,
                    color: widget.questionData.difficultLevel == $medium
                        ? $yellow500
                        : widget.questionData.difficultLevel == $hard
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
          _titleText(widget.questionData.name),
          const SizedBox(
            height: 8,
          ),
          showMathJaxHtml(
            statement,
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
            height: 8,
          ),
          ...listSampleTest,
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: $primaryColor,
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            UrlRoutes.$codeEditor,
            arguments: CodeEditorPage(
              statementQuestion: statement,
              quizId: _lessonQuizController.lessonData.value.id,
              questionData: widget.questionData,
              courseID: _lessonQuizController.lessonData.value.courseId != null
                  ? int.parse(_lessonQuizController.lessonData.value.courseId ?? "0")
                  : null,
            ),
          );
          if (result == $passed) {
            final AuthState auth = context.read<AuthState>();
            await Future.wait([
              _lessonQuizController.reloadQuestionData(),
              auth.reloadInfoUser(),
              showInfoDialog(
                context: context,
                icon: const Icon(
                  Icons.sentiment_very_satisfied_outlined,
                  color: $primaryColor,
                  size: 60,
                ),
                title: AppLocalizations.of(context)!.congratulation,
                content: "${AppLocalizations.of(context)!.you_receive}: ${widget.questionData.uCoin} uCoin",
                titlePadding: const EdgeInsets.symmetric(vertical: 12),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              ),
            ]);
            return;
          }
          if (result == $failed) {
            await Future.wait([
              _lessonQuizController.reloadQuestionData(),
              showInfoDialog(
                context: context,
                icon: const Icon(
                  Icons.sentiment_dissatisfied_outlined,
                  color: $errorColor,
                  size: 60,
                ),
                title: AppLocalizations.of(context)!.wrong_answer,
                content: AppLocalizations.of(context)!.try_again,
                titlePadding: const EdgeInsets.symmetric(vertical: 12),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              ),
            ]);
          }
        },
        child: const Icon(
          Icons.code_outlined,
          color: $whiteColor,
        ),
      ),
      body: _body(),
    );
  }
}
