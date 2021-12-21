import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/components.dart';
import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class LessonVideo extends StatefulWidget {
  const LessonVideo({Key? key}) : super(key: key);

  @override
  _LessonVideoState createState() => _LessonVideoState();
}

class _LessonVideoState extends State<LessonVideo> {
  final ScrollController _scrollController = ScrollController();
  final LessonDetailsController _lessonDetailsController = Get.find<LessonDetailsController>();

  _youtubePlayerVideo() {
    double pointStart = 0;
    double pointUp = 0;
    return Obx(() {
      final size = MediaQuery.of(context).size;
      final ori = (MediaQuery.of(context).orientation);
      if (_lessonDetailsController.isReloadLessonData.value) {
        return Listener(
          onPointerDown: (moveEvent){
            pointStart = moveEvent.position.dy;
          },
          onPointerUp: (moveEvent){
            pointUp = moveEvent.position.dy;
            if(pointUp - pointStart > 100){
              Navigator.pop(context);
            }
          },
          child: Container(
            color: Colors.black,
            height: ori == Orientation.portrait ? size.width * 9 / 16 : size.height * 0.4,
            width: size.width,
            child: Center(
              child: YoutubeViewer(videoUrl: _lessonDetailsController.currentLessonData.value.videoUrl ?? $videoDefault),
            ),
          ),
        );
      } else {
        return SizedBox(
          height: ori == Orientation.portrait ? size.width * 9 / 16 : size.height * 0.4,
          width: size.width,
          child: Container(
            color: $blackColor,
            child: Center(
              child: infinityLoading(context: context),
            ),
          ),
        );
      }
    });
  }

  _curriculumCourse() {
    return Column(
      children: _lessonDetailsController.listCourseItem.map<Widget>((item) {
        return ExpandableMultiLevelLesson(
          lessonItem: item,
          courseInfo: _lessonDetailsController.currentCourse.value,
        );
      }).toList(),
    );
  }

  _showCurriculum() {
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Obx(() {
            final Course currentCourse = _lessonDetailsController.currentCourse.value;
            final LessonData currentLessonData = _lessonDetailsController.currentLessonData.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        currentCourse.name,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    ShowUCoinWithBorder(totalUCoin: currentLessonData.uCoin)
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  currentLessonData.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 26),
                Text(
                  AppLocalizations.of(context)!.list_of_lectures,
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(height: 8),
                _curriculumCourse(),
              ],
            );
          }),
        ),
      ),
    );
  }

  _body() {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _youtubePlayerVideo(),
            _showCurriculum(),
          ],
        ),
      ),
    );
  }

  _bottomAppBar() {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Obx(
        () {
          final LessonData currentLessonData = _lessonDetailsController.currentLessonData.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              btnBackLesson(
                context: context,
                lessonDetailsController: _lessonDetailsController,
                handleAction:() =>  handleBtnBackAction(
                  context: context,
                  lessonDetailsController: _lessonDetailsController,
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              currentLessonData.userStatus == $completed
                  ? Text(
                      AppLocalizations.of(context)!.finished,
                      style: AppThemeLight.caption3,
                    )
                  : Expanded(
                      child: ButtonFullColorWithIconPrefix(
                        textBtn: AppLocalizations.of(context)!.got_it,
                        onPressCallBack: () {
                          _lessonDetailsController.doneLessonVideoAndLecture(currentLessonData.id);
                        },
                        iconBtn: SvgPicture.asset($assetSVGDoneLesson),
                        paddingBtn: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
              const SizedBox(
                width: 18,
              ),
              btnNextLesson(
                context: context,
                lessonDetailsController: _lessonDetailsController,
                handleAction:() =>  handleBtnNextAction(
                  context: context,
                  lessonDetailsController: _lessonDetailsController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: _body()),
        _bottomAppBar(),
      ],
    );
  }
}
