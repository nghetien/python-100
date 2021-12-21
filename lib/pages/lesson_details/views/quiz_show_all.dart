import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';
import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../services/services.dart';
import '../../../states/states.dart';
import '../../../widgets/widgets.dart';

class QuizShowAll extends StatefulWidget {
  const QuizShowAll({Key? key}) : super(key: key);

  @override
  _QuizShowAllState createState() => _QuizShowAllState();
}

class _QuizShowAllState extends State<QuizShowAll> {
  final LessonQuizController _lessonQuizController = Get.find<LessonQuizController>();
  final QuizShowSubmitAllController _quizShowSubmitAllController = Get.find<QuizShowSubmitAllController>();

  final _debounce = Debounce(seconds: 5);

  _sendDaft() {
    _debounce.run(() {
      _quizShowSubmitAllController.saveDaft(
        _lessonQuizController.lessonData.value.currentSubmission,
        _lessonQuizController.lessonData.value.id,
      );
    });
  }

  @override
  void initState() {
    _quizShowSubmitAllController.addQuestion();
    super.initState();
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  _body() {
    List<QuestionData> currentListQuestion = _lessonQuizController.listQuestionData;
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, index) => const Line1(
        widthLine: 0.5,
      ),
      itemCount: currentListQuestion.length,
      itemBuilder: (BuildContext context, int index) {
        final QuestionData currentQuestion = currentListQuestion[index];
        switch (currentQuestion.type) {
          case $singleChoice:
            return QuizSingleChoice(
              questionData: currentQuestion,
              index: index,
              onChangeSelect: (indexAnswer) {
                _quizShowSubmitAllController.changeSingleChoice(
                  index: index,
                  indexAnswer: indexAnswer,
                );
                _sendDaft();
              },
            );
          case $multipleChoice:
            return QuizMultipleChoice(
              questionData: currentQuestion,
              index: index,
              onChangeSelect: (listAnswer) {
                _quizShowSubmitAllController.changeMultiChoice(
                  index: index,
                  listIndexAnswer: listAnswer,
                );
                _sendDaft();
              },
            );
          case $fillIn:
            return QuizFillIn(
              questionData: currentQuestion,
              index: index,
              onChangeFunction: (value, i) {
                _quizShowSubmitAllController.changeFillIn(
                  index: index,
                  value: value,
                  indexAnswer: i,
                );
                _sendDaft();
              },
            );
          case $shortAnswer:
            return QuizShortAnswer(
              questionData: currentQuestion,
              index: index,
              onChangeFunction: (value) {
                _quizShowSubmitAllController.changeShortAnswer(
                  index: index,
                  value: value,
                );
                _sendDaft();
              },
            );
          case $longAnswer:
            return QuizLongAnswer(
              questionData: currentQuestion,
              index: index,
              onChangeFunction: (value) {
                _quizShowSubmitAllController.changeLongAnswer(
                  index: index,
                  value: value,
                );
                _sendDaft();
              },
            );
          case $theory:
            return QuizTheory(
              questionData: currentQuestion,
              index: index,
              titleStart: true,
            );
          default:
            return Text(
              AppLocalizations.of(context)!.error_loading,
              style: const TextStyle(color: $errorColor),
            );
        }
      },
    );
  }

  _submitButton() {
    return Expanded(
      child: ButtonFullColorWithIconPrefix(
        textBtn: AppLocalizations.of(context)!.finish_quiz,
        onPressCallBack: () async {
          final bool? value = await showSimpleDialog(
            context: context,
            title: AppLocalizations.of(context)!.submit,
            content: AppLocalizations.of(context)!.are_you_sure_submit,
            titlePadding: const EdgeInsets.symmetric(vertical: 12),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          );
          if (value == true) {
            final DataResponse res = await _quizShowSubmitAllController.submitQuiz(
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
    return Column(
      children: <Widget>[
        Expanded(child: _body()),
        ori == Orientation.portrait
            ? _bottomAppBar()
            : const SizedBox(
                height: 0,
                width: 0,
              ),
      ],
    );
  }
}
