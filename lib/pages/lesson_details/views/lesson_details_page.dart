import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wakelock/wakelock.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

_showPopUpPayment({required BuildContext context, required Course course})async{
  final bool? isOK = await showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return createDialog(
        context,
        AppLocalizations.of(context)!.course_payment,
        course.name,
      );
    },
  );
  if (isOK == true) {
    Navigator.pushNamed(
      context,
      UrlRoutes.$payment,
      arguments: PaymentPage(
        currentCourse: course,
      ),
    );
  }
}

/// For Code, Lecture, Video
handleBtnNextAction({
  required LessonDetailsController lessonDetailsController,
  required BuildContext context,
}) async {
  if (lessonDetailsController.indexFlatten.value != lessonDetailsController.listCourseItem.length) {
    final int index = lessonDetailsController.indexFlatten.value;
    final CourseItem lesson = lessonDetailsController.flattenCourseItem[index + 1];
    if (lesson.isFree != true && lessonDetailsController.currentCourse.value.isPaid != true) {
      _showPopUpPayment(context: context, course: lessonDetailsController.currentCourse.value);
    } else {
      lessonDetailsController.nextToLesson();
    }
  }
}

handleBtnBackAction({
  required LessonDetailsController lessonDetailsController,
  required BuildContext context,
}) async {
  if (lessonDetailsController.indexFlatten.value != 0) {
    final int index = lessonDetailsController.indexFlatten.value;
    final CourseItem lesson = lessonDetailsController.flattenCourseItem[index - 1];
    if (lesson.isFree != true && lessonDetailsController.currentCourse.value.isPaid != true) {
      _showPopUpPayment(context: context, course: lessonDetailsController.currentCourse.value);
    } else {
      lessonDetailsController.backToLesson();
    }
  }
}

btnNextLesson({
  required LessonDetailsController lessonDetailsController,
  required BuildContext context,
  required Function handleAction,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: $green100,
      onPrimary: $backgroundGreyColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      padding: const EdgeInsets.all(8),
    ),
    child: const Icon(
      Icons.navigate_next_rounded,
      color: $primaryColor,
      size: 34,
    ),
    onPressed: () async {
      handleAction();
    },
  );
}

btnBackLesson({
  required LessonDetailsController lessonDetailsController,
  required BuildContext context,
  required Function handleAction,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: lessonDetailsController.indexFlatten.value != 0 ? $green100 : $backgroundGreyColor,
      onPrimary: $backgroundGreyColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      padding: const EdgeInsets.all(8),
    ),
    child: const Icon(
      Icons.navigate_before_rounded,
      color: $primaryColor,
      size: 34,
    ),
    onPressed: () async {
      handleAction();
    },
  );
}

class LessonDetailsPage extends StatefulWidget {
  final Course currentCourse;
  final List<CourseItem> listCourseItem;
  final int? idLessonStart;

  const LessonDetailsPage({
    Key? key,
    required this.currentCourse,
    required this.listCourseItem,
    this.idLessonStart,
  }) : super(key: key);

  @override
  _LessonDetailsPageState createState() => _LessonDetailsPageState();
}

class _LessonDetailsPageState extends State<LessonDetailsPage> {
  late final LessonDetailsController _lessonDetailsController;

  @override
  void initState() {
    Wakelock.enable();
    _lessonDetailsController = Get.put(
      LessonDetailsController(
        myContext: context,
        currentCourse: Rx<Course>(widget.currentCourse),
        listCourseItem: RxList<CourseItem>(widget.listCourseItem),
        idLessonInit: widget.idLessonStart ?? 0,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    Get.delete<LessonDetailsController>();
    super.dispose();
  }

  _body() {
    return Obx(
      () {
        if (_lessonDetailsController.indexFlatten.value == -1) {
          return Text(
            AppLocalizations.of(context)!.course_will_be_on_soon,
            style: Theme.of(context).textTheme.headline4,
          );
        } else {
          switch (_lessonDetailsController.currentLessonData.value.type) {
            case $video:
              return const LessonVideo();
            case $videoInteraction:
              return const LessonVideo();
            case $quiz:
              if(_lessonDetailsController.isReloadLessonData.value){
                return LessonQuiz(
                  isContest: false,
                  lessonData: _lessonDetailsController.currentLessonData.value,
                );
              }else{
                return splashLoadingPage(context);
              }
            case $lecture:
              return LessonLecture(key: UniqueKey(),);
            case $file:
              return const LessonFile();
            default:
              return splashLoadingPage(context);
          }
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
