import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../models/models.dart';
import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class StepByStepCurriculum extends StatefulWidget {
  const StepByStepCurriculum({Key? key}) : super(key: key);

  @override
  _StepByStepCurriculumState createState() => _StepByStepCurriculumState();
}

class _StepByStepCurriculumState extends State<StepByStepCurriculum> {
  final CourseDetailController _courseDetailController = Get.find<CourseDetailController>();

  Widget _chapterContainer({required CourseItem lesson, bool? haveIcon = false, required int index}) {
    final size = MediaQuery.of(context).size;
    Color bgColor = $whiteColor;
    Color borderColor = $backgroundGreyColor;
    Widget content = Text(AppLocalizations.of(context)!.learn.toUpperCase());
    if (lesson.userStatus == $completed) {
      bgColor = $green100;
      borderColor = $green100;
      content = SvgPicture.asset(
        $assetSVGSuccess,
        height: 40,
        width: 40,
      );
    }
    return Container(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              if (lesson.itemType != $lessonItem) {
                Navigator.pushNamed(
                  context,
                  UrlRoutes.$infoChapterCurriculum,
                  arguments: ShowInfoChapterPage(
                    index: index,
                  ),
                ).then((value) {
                  _courseDetailController.fetchData();
                });
              }
            },
            child: CircularPercentIndicator(
              radius: 110,
              lineWidth: 10,
              percent: (lesson.userPercentComplete ?? 0 ) / 100,
              backgroundColor: generateColor($primaryColor, 0.2),
              progressColor: $primaryColor,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              center: Text(
                "${(lesson.userPercentComplete ?? 0).toInt()}%",
                style: TextStyle(
                  color: $primaryColor,
                  fontFamily: Theme.of(context).textTheme.headline4!.fontFamily,
                  fontWeight: Theme.of(context).textTheme.headline4!.fontWeight,
                  fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                  height: 1,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: bgColor,
              elevation: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24, left: 18, right: 18),
            child: Text(
              lesson.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          haveIcon == true
              ? const SizedBox(
                  height: 0,
                  width: 0,
                )
              : Icon(
                  Icons.more_vert_rounded,
                  size: 40,
                  color: generateColor($primaryColor, 0.4),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<CourseItem> listCourseItem = _courseDetailController.listCourseItem;
      List<Widget> listStep = [];
      for (int index = 0; index < listCourseItem.length; index++) {
        listStep.add(
          _chapterContainer(
            lesson: listCourseItem[index],
            haveIcon: listCourseItem[listCourseItem.length - 1].id == listCourseItem[index].id,
            index: index,
          ),
        );
      }
      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: listStep,
        ),
      );
    });
  }
}
