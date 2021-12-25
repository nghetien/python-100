import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/constants.dart';
import '../../../../services/services.dart';
import '../../../../widgets/widgets.dart';
import '../../../../helpers/helpers.dart';
import '../../pages.dart';

enum StatusButton {
  hidden,
  show,
  countDown,
  haveSubmitted,
}

class CountDownQuiz extends StatefulWidget {
  const CountDownQuiz({
    Key? key,
  }) : super(key: key);

  @override
  _CountDownQuizState createState() => _CountDownQuizState();
}

class _CountDownQuizState extends State<CountDownQuiz> {
  final LessonQuizController _lessonQuizController = Get.find<LessonQuizController>();
  late final LessonDetailsController _lessonDetailsController;

  final String $tagFeedbackCountDown = "TAG_FEEDBACK_COUNT_DOWN";

  /// Load result
  late Result _result;
  String typeLoading = $runningTest;

  /// count down
  late StatusButton statusShowButton;
  late int timestampStart;
  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timestampStart > 0) {
        setState(() {
          timestampStart--;
        });
      } else {
        timer.cancel();
        setState(() {
          statusShowButton = StatusButton.show;
        });
      }
    });
  }

  @override
  void initState() {
    if (!_lessonQuizController.isContest) {
      _lessonDetailsController = Get.find<LessonDetailsController>();
    }
    LessonData lessonDataState = _lessonQuizController.lessonData.value;
    if (lessonDataState.lastQuizSubmission != null && lessonDataState.isGradedQuiz == true) {
      statusShowButton = StatusButton.haveSubmitted;
    } else if (lessonDataState.activeToTime == null && lessonDataState.activeFromTime == null) {
      statusShowButton = StatusButton.show;
    } else if (lessonDataState.serverTime != null) {
      if (lessonDataState.activeFromTime != null && lessonDataState.activeToTime != null) {
        if (lessonDataState.activeFromTime! > lessonDataState.serverTime!) {
          statusShowButton = StatusButton.countDown;
          timestampStart = lessonDataState.activeFromTime! - lessonDataState.serverTime!;
          _startTimer();
        } else if (lessonDataState.serverTime! > lessonDataState.activeToTime!) {
          statusShowButton = StatusButton.hidden;
        } else {
          statusShowButton = StatusButton.show;
        }
      } else {
        statusShowButton = StatusButton.show;
      }
    } else {
      statusShowButton = StatusButton.show;
    }
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _showInfoItem({required String svgIcon, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(svgIcon),
        const SizedBox(
          width: 8,
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
            fontWeight: Theme.of(context).textTheme.bodyText1!.fontWeight,
            fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
            height: Theme.of(context).textTheme.bodyText1!.height,
            color: $primaryColor,
          ),
        )
      ],
    );
  }

  _showDesItem({required String name, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            name,
            style: Theme.of(context).textTheme.bodyText2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
            fontWeight: Theme.of(context).textTheme.bodyText2!.fontWeight,
            fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
            height: Theme.of(context).textTheme.bodyText2!.height,
            color: $primaryColor,
          ),
        ),
      ],
    );
  }

  _countDownItem(String time, String type) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: $primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: $whiteColor,
              fontSize: 35,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          type,
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
  }

  _showCountDown() {
    Duration duration = Duration(seconds: timestampStart);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final hours = twoDigits(duration.inHours.remainder(60));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.start_at,
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _countDownItem(hours, AppLocalizations.of(context)!.hours),
            _countDownItem(minutes, AppLocalizations.of(context)!.minutes),
            _countDownItem(seconds, AppLocalizations.of(context)!.seconds),
          ],
        )
      ],
    );
  }

  _showButton() {
    if (statusShowButton == StatusButton.show) {
      return Obx(() {
        LessonData lessonDataState = _lessonQuizController.lessonData.value;
        return ButtonFullColorWithIconPrefix(
          textBtn: lessonDataState.lastQuizSubmission != null
              ? AppLocalizations.of(context)!.try_again
              : AppLocalizations.of(context)!.start_quiz,
          paddingBtn: const EdgeInsets.symmetric(vertical: 16),
          onPressCallBack: () {
            _lessonQuizController.startQuiz();
          },
          iconBtn: SvgPicture.asset(
            $assetSVGPlay,
          ),
        );
      });
    } else if (statusShowButton == StatusButton.hidden) {
      return ButtonFullColor(
        widthBtn: double.infinity,
        colorBtn: $greyColor,
        textBtn: AppLocalizations.of(context)!.end,
        paddingBtn: const EdgeInsets.symmetric(vertical: 16),
        onPressCallBack: () async {},
      );
    } else if (statusShowButton == StatusButton.haveSubmitted) {
      return Text(
        AppLocalizations.of(context)!.you_have_submitted_quiz,
        style: Theme.of(context).textTheme.headline6,
      );
    } else {
      return _showCountDown();
    }
  }

  _infoQuestion() {
    return Obx(() {
      LessonData lessonDataState = _lessonQuizController.lessonData.value;
      return Column(
        children: <Widget>[
          const SizedBox(
            height: 12,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 32),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            decoration: BoxDecoration(
              color: $green100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: $primaryColor, width: 1),
            ),
            child: Column(
              children: <Widget>[
                _showInfoItem(
                  svgIcon: $assetSVGPaper3,
                  value: "${lessonDataState.numQuestions} ${AppLocalizations.of(context)!.question.toLowerCase()}",
                ),
                const SizedBox(
                  height: 18,
                ),
                _showInfoItem(
                  svgIcon: $assetSVGClock,
                  value: lessonDataState.quizDuration == null || lessonDataState.quizDuration == 0
                      ? AppLocalizations.of(context)!.unlimited
                      : formatTime(lessonDataState.quizDuration ?? 0),
                ),
              ],
            ),
          ),
          _showDesItem(
              name: AppLocalizations.of(context)!.number_of_submissions,
              value: lessonDataState.isGradedQuiz
                  ? "1 ${AppLocalizations.of(context)!.times.toLowerCase()}"
                  : AppLocalizations.of(context)!.unlimited),
          const SizedBox(
            height: 12,
          ),
          _showDesItem(
            name: "${AppLocalizations.of(context)!.from}:",
            value: lessonDataState.activeFromTime != null
                ? formatTimeFromTimestamp(lessonDataState.activeFromTime ?? 0)
                : AppLocalizations.of(context)!.unlimited,
          ),
          const SizedBox(
            height: 12,
          ),
          _showDesItem(
            name: "${AppLocalizations.of(context)!.to}:",
            value: lessonDataState.activeToTime != null
                ? formatTimeFromTimestamp(lessonDataState.activeToTime ?? 0)
                : AppLocalizations.of(context)!.unlimited,
          ),
          const SizedBox(
            height: 32,
          ),
          _showButton(),
        ],
      );
    });
  }

  _showHisSubItem({required String name, required String value, Color? textColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            name,
            style: Theme.of(context).textTheme.bodyText2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
            fontWeight: Theme.of(context).textTheme.bodyText2!.fontWeight,
            fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
            height: Theme.of(context).textTheme.bodyText2!.height,
            color: textColor ?? Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
      ],
    );
  }

  _historySubmit() {
    return Column(
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.history_submission,
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(
          height: 32,
        ),
        _showHisSubItem(
            name: AppLocalizations.of(context)!.create_at, value: formatTimeFromTimestamp(_result.createdAt)),
        const SizedBox(
          height: 12,
        ),
        _showHisSubItem(
            name: AppLocalizations.of(context)!.submitted_at, value: formatTimeFromTimestamp(_result.submittedAt)),
        const SizedBox(
          height: 12,
        ),
        _showHisSubItem(
            name: AppLocalizations.of(context)!.total_time, value: formatTime(_result.submittedAt - _result.createdAt)),
        const SizedBox(
          height: 12,
        ),
        _showHisSubItem(
          name: AppLocalizations.of(context)!.question_passed,
          value: "${_result.numPassed} / ${_result.numQuestions}",
          textColor: $primaryColor,
        ),
        const SizedBox(
          height: 12,
        ),
        _showHisSubItem(
          name: AppLocalizations.of(context)!.question_failed,
          value: "${_result.numFailed} / ${_result.numQuestions}",
          textColor: $errorColor,
        ),
        const SizedBox(
          height: 12,
        ),
        _showHisSubItem(
          name: AppLocalizations.of(context)!.question_waiting_judge,
          value: "${_result.numWaitingJudge} / ${_result.numQuestions}",
          textColor: $yellow400,
        ),
        const SizedBox(
          height: 12,
        ),
        _showHisSubItem(
          name: AppLocalizations.of(context)!.score,
          value: "${_result.score} / ${_result.quizScore}",
          textColor: $primaryColor,
        ),
      ],
    );
  }

  _loadingHistory() async {
    LessonData lessonDataState = _lessonQuizController.lessonData.value;
    DataResponse res = await getResultQuizResponse(lessonDataState.lastQuizSubmission ?? 0);
    if (res.status) {
      _result = Result.createAResultFromJSON(res.data["data"]);
      setState(() {
        typeLoading = $passed;
      });
    } else {
      setState(() {
        typeLoading = $failed;
      });
    }
  }

  _showHistory() {
    return Obx(() {
      switch (typeLoading) {
        case $runningTest:
          if (_lessonQuizController.lessonData.value.lastQuizSubmission != null &&
              _lessonQuizController.lessonData.value.lastQuizSubmission != 0) {
            _loadingHistory();
            return infinityLoading(context: context);
          } else {
            return const SizedBox(
              height: 0,
              width: 0,
            );
          }
        case $passed:
          return _historySubmit();
        case $failed:
          return Text(
            AppLocalizations.of(context)!.load_history_submission_failed,
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
              fontWeight: Theme.of(context).textTheme.bodyText2!.fontWeight,
              fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
              height: Theme.of(context).textTheme.bodyText2!.height,
              color: $errorColor,
            ),
          );
        default:
          return const SizedBox(
            height: 0,
            width: 0,
          );
      }
    });
  }

  _body() {
    return Column(
      children: <Widget>[
        _infoQuestion(),
        const SizedBox(
          height: 32,
        ),
        _showHistory(),
        const SizedBox(
          height: 24,
        ),
        ButtonOutLineWithIcon(
          widthBtn: double.infinity,
          paddingBtn: const EdgeInsets.symmetric(vertical: 16),
          textColor: $primaryColor,
          borderColorBtn: $primaryColor,
          textBtn: AppLocalizations.of(context)!.comment,
          onPressCallBack: () {
            Navigator.pushNamed(
              context,
              UrlRoutes.$feedback,
              arguments: FeedbackCodeEditor(
                haveAppBar: true,
                tag: $tagFeedbackCountDown,
                lessonId: _lessonQuizController.lessonData.value.id,
              ),
            );
          },
          iconBtn: const Icon(
            Icons.comment_outlined,
            color: $primaryColor,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
      ],
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
            handleAction: () => handleBtnBackAction(
              context: context,
              lessonDetailsController: _lessonDetailsController,
            ),
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
            handleAction: () => handleBtnNextAction(
              context: context,
              lessonDetailsController: _lessonDetailsController,
            ),
          ),
        ],
      ),
    );
  }

  _bottomAppBar() {
    return Obx(() {
      if (_lessonDetailsController.currentLessonData.value.userStatus == $completed) {
        return _bottomAppBarCompleted();
      } else {
        return const SizedBox(
          height: 0,
          width: 0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ori = (MediaQuery.of(context).orientation);
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            physics: const BouncingScrollPhysics(),
            child: _body(),
          ),
        ),
        _lessonQuizController.isContest
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : ori == Orientation.portrait
                ? _bottomAppBar()
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
      ],
    );
  }
}
