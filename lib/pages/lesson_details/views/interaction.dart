import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
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

class Interaction extends StatefulWidget {
  const Interaction({
    Key? key,
  }) : super(key: key);

  @override
  _InteractionState createState() => _InteractionState();
}

class _InteractionState extends State<Interaction> {
  final LessonDetailsController _lessonDetailsController = Get.find<LessonDetailsController>();
  final LessonQuizController _lessonQuizController = Get.find<LessonQuizController>();
  late final QuizInteractionController _quizInteractionController;

  late bool arrayIsEmpty;
  late bool isCompleted;

  @override
  void initState() {
    if (_lessonQuizController.listQuestionData.isNotEmpty) {
      QuestionData firstItemQuestion = _lessonQuizController.listQuestionData[0];
      isCompleted = firstItemQuestion.userStatus != null;
      Map<String, dynamic> listPosition = {};
      if (firstItemQuestion.statementMedia != null && firstItemQuestion.statementMedia != "") {
        listPosition = json.decode(firstItemQuestion.statementMedia ?? "");
      }
      listPosition["form_top_position"] = json.decode(listPosition["form_top_position"]);
      listPosition["form_left_position"] = json.decode(listPosition["form_left_position"]);
      listPosition["form_width"] = json.decode(listPosition["form_width"]);
      listPosition["form_height"] = json.decode(listPosition["form_height"]);
      _quizInteractionController = Get.put(
        QuizInteractionController(
          currentLessonId: _lessonQuizController.lessonData.value.id,
          myContext: context,
          optionPosition: listPosition,
          currentInteraction: firstItemQuestion,
        ),
      );
      arrayIsEmpty = false;
    } else {
      arrayIsEmpty = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<QuizInteractionController>();
    super.dispose();
  }

  _getPage() {
    if (arrayIsEmpty) {
      return Text(
        AppLocalizations.of(context)!.error_process_download,
        style: Theme.of(context).textTheme.headline4,
      );
    } else {
      switch (_quizInteractionController.currentInteraction.displayType) {
        case $fillIn:
          return InteractionFillIn(key: UniqueKey(),);
        case $multipleChoice:
          return InteractionMultiChoice(key: UniqueKey(),);
        case $singleChoice:
          return InteractionSingleChoice(key: UniqueKey(),);
        default:
          return Text(
            AppLocalizations.of(context)!.error_process_download,
            style: Theme.of(context).textTheme.headline4,
          );
      }
    }
  }

  _body() {
    final size = MediaQuery.of(context).size;
    double widthImage = size.width;
    double heightImage = size.height;
    heightImage = widthImage *
        _quizInteractionController.optionPosition["image_height"].toDouble() /
        _quizInteractionController.optionPosition["image_width"].toDouble();
    return InkWell(
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.all(0),
          width: widthImage,
          height: heightImage,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(_quizInteractionController.currentInteraction.statement),
            ),
          ),
          child: _getPage(),
        ),
      ),
    );
  }

  _submitButton() {
    final LessonData currentLessonData = _lessonDetailsController.currentLessonData.value;
    return Expanded(
      child: ButtonFullColorWithIconPrefix(
        textBtn: AppLocalizations.of(context)!.submit,
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
            final DataResponse res = await _quizInteractionController.submitQuizInteraction();
            if (res.status) {
              if (res.data["data"][0]["status"] == $failed) {
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
              } else {
                final AuthState auth = context.read<AuthState>();
                showInfoDialog(
                  context: context,
                  icon: const Icon(
                    Icons.sentiment_satisfied_outlined,
                    color: $primaryColor,
                    size: 60,
                  ),
                  title: AppLocalizations.of(context)!.exactly,
                  content: "${AppLocalizations.of(context)!.you_receive}: ${currentLessonData.uCoin} uCoin",
                  titlePadding: const EdgeInsets.symmetric(vertical: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                  actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                ).then((value) async {
                  await auth.reloadInfoUser();
                  setState(() {
                    isCompleted = true;
                  });
                });
              }
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

  _bottomAppBarSubmit() {
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

  _bottomAppBar() {
    if (isCompleted) {
      return _bottomAppBarCompleted();
    } else {
      return _bottomAppBarSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ori = (MediaQuery.of(context).orientation);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(57),
        child: Obx(
              () => simpleAppBar(
            automaticallyImplyLeading: ori == Orientation.portrait,
            context: context,
            title: _lessonDetailsController.flattenCourseItem[_lessonDetailsController.indexFlatten.value].name,
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
