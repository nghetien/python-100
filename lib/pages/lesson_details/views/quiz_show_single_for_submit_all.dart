import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../services/services.dart';
import '../../../states/states.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class QuizShowSingleForSubmitAll extends StatefulWidget {
  const QuizShowSingleForSubmitAll({Key? key}) : super(key: key);

  @override
  _QuizShowSingleForSubmitAllState createState() => _QuizShowSingleForSubmitAllState();
}

class _QuizShowSingleForSubmitAllState extends State<QuizShowSingleForSubmitAll> {
  final LessonQuizController _lessonQuizController = Get.find<LessonQuizController>();
  final QuizShowSingleSubmitAllController _quizShowSingleSubmitAllController =
      Get.find<QuizShowSingleSubmitAllController>();

  final _debounce = Debounce(seconds: 5);

  _sendDaft() {
    _debounce.run(() {
      _quizShowSingleSubmitAllController.saveDaft(
        _lessonQuizController.lessonData.value.currentSubmission,
        _lessonQuizController.lessonData.value.id,
      );
    });
  }

  int currentIndexQuestion = 0;

  @override
  void initState() {
    _quizShowSingleSubmitAllController.addQuestion();
    super.initState();
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  _showListQuestionBtn() {
    List<Widget> listItem = [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          AppLocalizations.of(context)!.list_quiz,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    ];
    for (int i = 0; i < _lessonQuizController.listQuestionData.length; i++) {
      Color colorBtn = Theme.of(context).textTheme.headline3!.color ?? $blackColor;
      Color? bgColorBtn;
      if (_lessonQuizController.listQuestionData[i].id ==
          _lessonQuizController.listQuestionData[currentIndexQuestion].id) {
        colorBtn = $whiteColor;
        bgColorBtn = $primaryColor;
      } else if (_lessonQuizController.listQuestionData[i].userStatus == $completed) {
        colorBtn = $primaryColor;
        bgColorBtn = $green100;
      } else if (_lessonQuizController.listQuestionData[i].userStatus == $failed) {
        colorBtn = $errorColor;
        bgColorBtn = $red100;
      } else if (_lessonQuizController.listQuestionData[i].userStatus == $waitingManualJudge) {
        colorBtn = $yellow400;
        bgColorBtn = $yellow100;
      } else {
        bgColorBtn = null;
      }
      listItem.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ButtonOutLineWithIcon(
            borderColorBtn: colorBtn,
            textColor: colorBtn,
            colorBtn: bgColorBtn,
            paddingBtn: const EdgeInsets.symmetric(vertical: 16),
            widthBtn: double.infinity,
            textBtn: _lessonQuizController.listQuestionData[i].name,
            onPressCallBack: () {
              Navigator.pop(context);
              setState(() {
                currentIndexQuestion = i;
              });
            },
            iconBtn: Text(
              (i + 1).toString(),
              style: TextStyle(
                color: colorBtn,
              ),
            ),
          ),
        ),
      );
    }

    return Positioned(
      right: 16,
      top: 16,
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.all(5),
          color: $primaryColor,
          child: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
                backgroundColor: Theme.of(context).backgroundColor,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: listItem,
                      ),
                    ),
                  );
                },
              );
            },
            icon: SvgPicture.asset(
              $assetSVGListQuestion,
              color: $whiteColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _questionContainer({required Widget child}) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: child,
    );
  }

  _showListQuestion() {
    final QuestionData currentQuestion = _lessonQuizController.listQuestionData[currentIndexQuestion];
    switch (currentQuestion.type) {
      case $code:
        return QuizCode(questionData: currentQuestion, key: Key("question_$currentIndexQuestion"));
      case $singleChoice:
        return _questionContainer(
          child: QuizSingleChoice(
            key: Key("question_$currentIndexQuestion"),
            questionData: currentQuestion,
            index: currentIndexQuestion,
            onChangeSelect: (indexAnswer) {
              _quizShowSingleSubmitAllController.changeSingleChoice(
                index: currentIndexQuestion,
                indexAnswer: indexAnswer,
              );
              _sendDaft();
            },
            titleStart: true,
            defaultValue: _quizShowSingleSubmitAllController.listAnswer[currentIndexQuestion]["user_answer"],
          ),
        );
      case $multipleChoice:
        return _questionContainer(
          child: QuizMultipleChoice(
            key: Key("question_$currentIndexQuestion"),
            questionData: currentQuestion,
            index: currentIndexQuestion,
            onChangeSelect: (listAnswer) {
              _quizShowSingleSubmitAllController.changeMultiChoice(
                index: currentIndexQuestion,
                listIndexAnswer: listAnswer,
              );
              _sendDaft();
            },
            titleStart: true,
            defaultValue: _quizShowSingleSubmitAllController.listAnswer[currentIndexQuestion]["user_answer"],
          ),
        );
      case $fillIn:
        return _questionContainer(
          child: QuizFillIn(
            key: Key("question_$currentIndexQuestion"),
            questionData: currentQuestion,
            index: currentIndexQuestion,
            onChangeFunction: (value, i) {
              _quizShowSingleSubmitAllController.changeFillIn(
                index: currentIndexQuestion,
                value: value,
                indexAnswer: i,
              );
              _sendDaft();
            },
            titleStart: true,
            defaultValue: _quizShowSingleSubmitAllController.listAnswer[currentIndexQuestion]["user_answer"],
          ),
        );
      case $shortAnswer:
        return _questionContainer(
          child: QuizShortAnswer(
            key: Key("question_$currentIndexQuestion"),
            questionData: currentQuestion,
            index: currentIndexQuestion,
            onChangeFunction: (value) {
              _quizShowSingleSubmitAllController.changeShortAnswer(
                index: currentIndexQuestion,
                value: value,
              );
              _sendDaft();
            },
            titleStart: true,
            defaultValue: _quizShowSingleSubmitAllController.listAnswer[currentIndexQuestion]["user_answer"],
          ),
        );
      case $longAnswer:
        return _questionContainer(
          child: QuizLongAnswer(
            key: Key("question_$currentIndexQuestion"),
            questionData: currentQuestion,
            index: currentIndexQuestion,
            onChangeFunction: (value) {
              _quizShowSingleSubmitAllController.changeLongAnswer(
                index: currentIndexQuestion,
                value: value,
              );
              _sendDaft();
            },
            titleStart: true,
            defaultValue: _quizShowSingleSubmitAllController.listAnswer[currentIndexQuestion]["user_answer"],
          ),
        );
      case $theory:
        return _questionContainer(
          child: QuizTheory(
            key: Key("question_$currentIndexQuestion"),
            questionData: currentQuestion,
            index: currentIndexQuestion,
            titleStart: true,
          ),
        );
      default:
        return Container(
          key: Key("question_$currentIndexQuestion"),
          margin: const EdgeInsets.only(top: 24),
          width: double.infinity,
          child: Text(
            AppLocalizations.of(context)!.error_loading,
            textAlign: TextAlign.center,
            style: const TextStyle(color: $errorColor),
          ),
        );
    }
  }

  _body() {
    return Stack(
      children: <Widget>[
        _showListQuestion(),
        _showListQuestionBtn(),
      ],
    );
  }

  _submitButton() {
    return Expanded(
      child: ButtonFullColorWithIconPrefix(
        textBtn: AppLocalizations.of(context)!.finish_quiz,
        onPressCallBack: () async {
          final value = await showSimpleDialog(
            context: context,
            title: AppLocalizations.of(context)!.submit,
            content: AppLocalizations.of(context)!.are_you_sure_submit,
            titlePadding: const EdgeInsets.symmetric(vertical: 12),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          );
          if (value == true) {
            final DataResponse res = await _quizShowSingleSubmitAllController.submitQuiz(
              _lessonQuizController.lessonData.value.currentSubmission,
              _lessonQuizController.lessonData.value.id,
            );
            if (res.status) {
              final AuthState auth = context.read<AuthState>();
              await Future.wait([
                _lessonQuizController.reloadLessonData(),
                auth.reloadInfoUser(),
              ]);
            } else {
              showSnackBar(
                context,
                message: AppLocalizations.of(context)!.submission_fail,
                backgroundColor: $errorColor,
              );
            }
          }
        },
        iconBtn: SvgPicture.asset($assetSVGSendAnswer),
        paddingBtn: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        colorBtn: $red500,
      ),
    );
  }

  _bottomAppBar() {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _submitButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ori = (MediaQuery.of(context).orientation);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(child: _body()),
          ori == Orientation.portrait
              ? _bottomAppBar()
              : const SizedBox(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
    );
  }
}
