import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../layouts/layouts.dart';
import '../../../services/services.dart';
import '../../../states/states.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class QuizShowSingleSubmitAll extends StatefulWidget {
  const QuizShowSingleSubmitAll({Key? key}) : super(key: key);

  @override
  _QuizShowSingleSubmitAllState createState() => _QuizShowSingleSubmitAllState();
}

class _QuizShowSingleSubmitAllState extends State<QuizShowSingleSubmitAll> {
  final LessonQuizController _lessonQuizController = Get.find<LessonQuizController>();
  late final QuizShowSingleSubmitAllController _quizShowSingleSubmitAllController;

  /// count down
  late StatusButton statusShowButton;
  late int timestampStart;
  Timer? _timer;

  Future<void> _startTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (timestampStart > 0) {
        setState(() {
          timestampStart--;
        });
      } else {
        timer.cancel();
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
    });
  }

  @override
  void initState() {
    _quizShowSingleSubmitAllController = Get.put(
      QuizShowSingleSubmitAllController(
        myContext: context,
        listQuestionData: _lessonQuizController.listQuestionData,
      ),
    );
    LessonData lessonData = _lessonQuizController.lessonData.value;
    if (lessonData.currentSubmission != null) {
      if (lessonData.quizDuration != null && lessonData.quizDuration != 0) {
        if (lessonData.startTime != null) {
          timestampStart =
              lessonData.startTime!.toInt() + lessonData.quizDuration! - lessonData.serverTime!;
        } else {
          timestampStart = lessonData.quizDuration!;
        }
        _startTimer();
      } else {
        timestampStart = -1;
      }
    } else {
      timestampStart = -1;
    }
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    Get.delete<QuizShowSingleSubmitAllController>();
    super.dispose();
  }

  _body() {
    return Obx(
      () {
        if (_lessonQuizController.lessonData.value.currentSubmission != null) {
          return const QuizShowSingleForSubmitAll();
        } else {
          return const CountDownQuiz();
        }
      },
    );
  }

  _countDownItem(String time) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: $red500,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: $whiteColor,
          fontSize: 16,
          height: 1.1,
        ),
      ),
    );
  }

  _showCountDown() {
    Duration duration = Duration(seconds: timestampStart);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final hours = twoDigits(duration.inHours.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _countDownItem(hours),
        _countDownItem(minutes),
        _countDownItem(seconds),
      ],
    );
  }

  Widget _checkShowCountDown() {
    return Obx(() {
      LessonData lessonDataState = _lessonQuizController.lessonData.value;
      if (timestampStart == -1) {
        if (lessonDataState.currentSubmission != null) {
          if (lessonDataState.quizDuration != null && lessonDataState.quizDuration != 0) {
            if (lessonDataState.startTime != null) {
              timestampStart =
                  lessonDataState.startTime!.toInt() + lessonDataState.quizDuration! - lessonDataState.serverTime!;
            } else {
              timestampStart = lessonDataState.quizDuration!;
            }
            _startTimer();
            return _showCountDown();
          } else {
            return Text(
              _lessonQuizController.lessonData.value.name,
              style: Theme.of(context).textTheme.headline3,
            );
          }
        } else {
          return Text(
            _lessonQuizController.lessonData.value.name,
            style: Theme.of(context).textTheme.headline3,
          );
        }
      } else if (timestampStart != -1 && lessonDataState.currentSubmission == null) {
        _timer?.cancel();
        return Text(
          _lessonQuizController.lessonData.value.name,
          style: Theme.of(context).textTheme.headline3,
        );
      } else {
        return _showCountDown();
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
          titleWidget: _checkShowCountDown(),
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
      body: _body(),
    );
  }
}
