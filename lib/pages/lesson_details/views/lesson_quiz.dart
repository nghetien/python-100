import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/constants.dart';
import '../../pages.dart';

class LessonQuiz extends StatefulWidget {
  final bool isContest;
  final LessonData lessonData;

  const LessonQuiz({
    Key? key,
    required this.isContest,
    required this.lessonData,
  }) : super(key: key);

  @override
  _LessonQuizState createState() => _LessonQuizState();
}

class _LessonQuizState extends State<LessonQuiz> {
  late final LessonQuizController _lessonQuizController;

  @override
  void initState() {
    _lessonQuizController = Get.put(
      LessonQuizController(
        myContext: context,
        lessonData: widget.lessonData,
        isContest: widget.isContest
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<LessonQuizController>();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  _body() {
    return Obx(
      () {
        try {
          if (_lessonQuizController.isReloadListQuestionData.value) {
            LessonData lessonData = _lessonQuizController.lessonData.value;
            if(_lessonQuizController.isContest){
              if (lessonData.isShowAllQuestions == true) {
                /// Hiển thị tất cả
                return const QuizShowSubmitAll();
              } else {
                /// Hiển thị từng câu
                if (lessonData.quizType == $submitAll) {
                  /// Submit All
                  return const QuizShowSingleSubmitAll();
                } else {
                  /// Submit từng câu
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.no_more_question,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  );
                }
              }
            }
            List<QuestionData> currentListQuestion = _lessonQuizController.listQuestionData;
            if (currentListQuestion[0].type == $interaction) {
              return const Interaction();
            }
            if (lessonData.isShowAllQuestions == true) {
              /// Hiển thị tất cả
              return const QuizShowSubmitAll();
            } else {
              /// Hiển thị từng câu
              if (lessonData.quizType == $submitAll) {
                /// Submit All
                return const QuizShowSingleSubmitAll();
              } else {
                /// Submit từng câu
                return const QuizShowSingleSubmitSingle();
              }
            }
          } else {
            return splashLoadingPage(context);
          }
        } catch (e) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.no_more_question,
              style: Theme.of(context).textTheme.headline4,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: _body(),
    );
  }
}
