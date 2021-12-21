import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../widgets/widgets.dart';
import '../../../layouts/layouts.dart';
import '../../../states/states.dart';
import '../../../services/services.dart';
import '../../pages.dart';

class QuizShowSingleSubmitSingle extends StatefulWidget {
  const QuizShowSingleSubmitSingle({Key? key}) : super(key: key);

  @override
  _QuizShowSingleSubmitSingleState createState() => _QuizShowSingleSubmitSingleState();
}

class _QuizShowSingleSubmitSingleState extends State<QuizShowSingleSubmitSingle> {
  final LessonDetailsController _lessonDetailsController = Get.find<LessonDetailsController>();
  final LessonQuizController _lessonQuizController = Get.find<LessonQuizController>();
  late final QuizShowSingleSubmitSingleController _quizShowSingleSubmitSingleController;

  int currentIndexQuestion = 0;

  @override
  void initState() {
    _quizShowSingleSubmitSingleController = Get.put(
      QuizShowSingleSubmitSingleController(
        myContext: context,
        listQuestionData: _lessonQuizController.listQuestionData,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<QuizShowSingleSubmitSingleController>();
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
              _quizShowSingleSubmitSingleController.changeSingleChoice(
                index: currentIndexQuestion,
                indexAnswer: indexAnswer,
              );
            },
            titleStart: true,
            defaultValue: _quizShowSingleSubmitSingleController.listAnswer[currentIndexQuestion]["user_answer"],
          ),
        );
      case $multipleChoice:
        return _questionContainer(
          child: QuizMultipleChoice(
            key: Key("question_$currentIndexQuestion"),
            questionData: currentQuestion,
            index: currentIndexQuestion,
            onChangeSelect: (listAnswer) {
              _quizShowSingleSubmitSingleController.changeMultiChoice(
                index: currentIndexQuestion,
                listIndexAnswer: listAnswer,
              );
            },
            titleStart: true,
            defaultValue: _quizShowSingleSubmitSingleController.listAnswer[currentIndexQuestion]["user_answer"],
          ),
        );
      case $fillIn:
        return _questionContainer(
          child: QuizFillIn(
            key: Key("question_$currentIndexQuestion"),
            questionData: currentQuestion,
            index: currentIndexQuestion,
            onChangeFunction: (value, i) {
              _quizShowSingleSubmitSingleController.changeFillIn(
                index: currentIndexQuestion,
                value: value,
                indexAnswer: i,
              );
            },
            titleStart: true,
            defaultValue: _quizShowSingleSubmitSingleController.listAnswer[currentIndexQuestion]["user_answer"],
          ),
        );
      case $shortAnswer:
        return _questionContainer(
          child: QuizShortAnswer(
            key: Key("question_$currentIndexQuestion"),
            questionData: currentQuestion,
            index: currentIndexQuestion,
            onChangeFunction: (value) {
              _quizShowSingleSubmitSingleController.changeShortAnswer(
                index: currentIndexQuestion,
                value: value,
              );
            },
            titleStart: true,
            defaultValue: _quizShowSingleSubmitSingleController.listAnswer[currentIndexQuestion]["user_answer"],
          ),
        );
      case $longAnswer:
        return _questionContainer(
          child: QuizLongAnswer(
            key: Key("question_$currentIndexQuestion"),
            questionData: currentQuestion,
            index: currentIndexQuestion,
            onChangeFunction: (value) {
              _quizShowSingleSubmitSingleController.changeLongAnswer(
                index: currentIndexQuestion,
                value: value,
              );
            },
            titleStart: true,
            defaultValue: _quizShowSingleSubmitSingleController.listAnswer[currentIndexQuestion]["user_answer"],
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
        textBtn: AppLocalizations.of(context)!.submit,
        onPressCallBack: () async {
          final DataResponse res = await _quizShowSingleSubmitSingleController.submitSingleQuiz(
            index: currentIndexQuestion,
            idLesson: _lessonDetailsController.currentLessonData.value.id,
          );
          if (res.status) {
            switch (res.data["data"][0]["status"]) {
              case $failed:
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
                );
                break;
              case $passed:
                final AuthState auth = context.read<AuthState>();
                showInfoDialog(
                  context: context,
                  icon: const Icon(
                    Icons.sentiment_very_satisfied_outlined,
                    color: $primaryColor,
                    size: 60,
                  ),
                  title: AppLocalizations.of(context)!.exactly,
                  content:
                      "${AppLocalizations.of(context)!.you_receive}: ${_lessonDetailsController.currentLessonData.value.uCoin} uCoin",
                  titlePadding: const EdgeInsets.symmetric(vertical: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                  actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                ).then((value) async {
                  await Future.wait([
                    _lessonQuizController.reloadQuestionData(),
                    auth.reloadInfoUser(),
                  ]);
                });
                break;
              case $waitingManualJudge:
                showInfoDialog(
                  context: context,
                  icon: const Icon(
                    Icons.sentiment_satisfied_outlined,
                    color: $yellow500,
                    size: 60,
                  ),
                  title: AppLocalizations.of(context)!.assignment_has_been_submitted,
                  content: AppLocalizations.of(context)!.waiting_for_grading,
                  titlePadding: const EdgeInsets.symmetric(vertical: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                  actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                ).then((value) async {
                  await _lessonQuizController.reloadQuestionData();
                });
                break;
              default:
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
                );
                break;
            }
          } else {
            showSnackBar(
              context,
              message: AppLocalizations.of(context)!.submission_fail,
              backgroundColor: $errorColor,
            );
          }
        },
        iconBtn: SvgPicture.asset($assetSVGSendAnswer),
        paddingBtn: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  _doneButton() {
    return Expanded(
      child: ButtonFullColorWithIconPrefix(
        textBtn: AppLocalizations.of(context)!.got_it,
        onPressCallBack: () async {
          final DataResponse res = await _quizShowSingleSubmitSingleController.submitSingleQuiz(
            index: currentIndexQuestion,
            idLesson: _lessonDetailsController.currentLessonData.value.id,
          );
          if (res.status) {
            if (res.data["data"][0]["status"] == $failed) {
              showInfoDialog(
                context: context,
                icon: const Icon(
                  Icons.sentiment_dissatisfied_outlined,
                  color: $errorColor,
                  size: 60,
                ),
                title: AppLocalizations.of(context)!.error_submitted,
                content: AppLocalizations.of(context)!.try_again,
                titlePadding: const EdgeInsets.symmetric(vertical: 12),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              );
            } else {
              final AuthState auth = context.read<AuthState>();
              showInfoDialog(
                context: context,
                icon: const Icon(
                  Icons.sentiment_very_satisfied_outlined,
                  color: $primaryColor,
                  size: 60,
                ),
                title: AppLocalizations.of(context)!.congratulation,
                content:
                    "${AppLocalizations.of(context)!.you_receive}: ${_lessonQuizController.listQuestionData[currentIndexQuestion].uCoin} uCoin",
                titlePadding: const EdgeInsets.symmetric(vertical: 12),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              ).then((value) async {
                await Future.wait([
                  _lessonQuizController.reloadQuestionData(),
                  auth.reloadInfoUser(),
                ]);
              });
            }
          } else {
            showSnackBar(
              context,
              message: AppLocalizations.of(context)!.submission_fail,
              backgroundColor: $errorColor,
            );
          }
        },
        iconBtn: SvgPicture.asset($assetSVGSendAnswer),
        paddingBtn: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _customBtnNextAction() {
    if (currentIndexQuestion >= _quizShowSingleSubmitSingleController.listQuestionData.length - 1) {
      handleBtnNextAction(
        context: context,
        lessonDetailsController: _lessonDetailsController,
      );
    } else {
      setState(() {
        currentIndexQuestion = currentIndexQuestion + 1;
      });
    }
  }

  void _customBtnBackAction() {
    if (currentIndexQuestion <= 0) {
      handleBtnBackAction(
        context: context,
        lessonDetailsController: _lessonDetailsController,
      );
    } else {
      setState(() {
        currentIndexQuestion = currentIndexQuestion - 1;
      });
    }
  }

  _bottomAppBarSimple() {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          btnBackLesson(
            context: context,
            lessonDetailsController: _lessonDetailsController,
            handleAction: () => _customBtnBackAction(),
          ),
          const SizedBox(
            width: 18,
          ),
          const SizedBox(
            width: 18,
          ),
          btnNextLesson(
            context: context,
            lessonDetailsController: _lessonDetailsController,
            handleAction: () => _customBtnNextAction(),
          ),
        ],
      ),
    );
  }

  _bottomAppBarCompleted() {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          btnBackLesson(
            context: context,
            lessonDetailsController: _lessonDetailsController,
            handleAction: () => _customBtnBackAction(),
          ),
          const SizedBox(
            width: 18,
          ),
          Text(
            AppLocalizations.of(context)!.finished,
            style: AppThemeLight.caption3,
          ),
          const SizedBox(
            width: 18,
          ),
          btnNextLesson(
            context: context,
            lessonDetailsController: _lessonDetailsController,
            handleAction: () => _customBtnNextAction(),
          ),
        ],
      ),
    );
  }

  _bottomAppBarSubmit() {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          btnBackLesson(
            context: context,
            lessonDetailsController: _lessonDetailsController,
            handleAction: () => _customBtnBackAction(),
          ),
          const SizedBox(
            width: 18,
          ),
          _submitButton(),
          const SizedBox(
            width: 18,
          ),
          btnNextLesson(
            context: context,
            lessonDetailsController: _lessonDetailsController,
            handleAction: () => _customBtnNextAction(),
          ),
        ],
      ),
    );
  }

  _bottomAppBarDone() {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          btnBackLesson(
            context: context,
            lessonDetailsController: _lessonDetailsController,
            handleAction: () => _customBtnBackAction(),
          ),
          const SizedBox(
            width: 18,
          ),
          _doneButton(),
          const SizedBox(
            width: 18,
          ),
          btnNextLesson(
            context: context,
            lessonDetailsController: _lessonDetailsController,
            handleAction: () => _customBtnNextAction(),
          ),
        ],
      ),
    );
  }

  Widget _bottomAppBar() {
    return Obx(() {
      Widget item = const SizedBox(
        height: 0,
        width: 0,
      );
      final QuestionData currentQuestion = _lessonQuizController.listQuestionData[currentIndexQuestion];
      if (currentQuestion.userStatus == $completed) {
        return _bottomAppBarCompleted();
      }
      switch (currentQuestion.type) {
        case $code:
          return _bottomAppBarSimple();
        case $singleChoice:
          return _bottomAppBarSubmit();
        case $multipleChoice:
          return _bottomAppBarSubmit();
        case $fillIn:
          return _bottomAppBarSubmit();
        case $shortAnswer:
          return _bottomAppBarSubmit();
        case $longAnswer:
          return _bottomAppBarSubmit();
        case $theory:
          return _bottomAppBarDone();
        default:
          return item;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ori = (MediaQuery.of(context).orientation);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(57),
        child: widgetTitleAppBar(
          automaticallyImplyLeading: ori == Orientation.portrait,
          context: context,
          titleWidget: Text(
            _quizShowSingleSubmitSingleController.listQuestionData[currentIndexQuestion].name,
            style: Theme.of(context).textTheme.headline3,
          ),
          actionsAppBar: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () async {
                  if (ori == Orientation.portrait) {
                    await SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
                  } else {
                    await SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                  }
                },
                icon: const Icon(Icons.sync_rounded),
              ),
            ),
          ],
        ),
      ),
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
