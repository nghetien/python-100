import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../widgets/widgets.dart';
import '../../../layouts/layouts.dart';
import '../../pages.dart';

class LessonFile extends StatefulWidget {
  const LessonFile({Key? key}) : super(key: key);

  @override
  _LessonFileState createState() => _LessonFileState();
}

class _LessonFileState extends State<LessonFile> {
  final LessonDetailsController _lessonDetailsController = Get.find<LessonDetailsController>();

  _body() {
    if (_lessonDetailsController.isReloadLessonData.value) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
        child: Column(
          children: <Widget>[
            Text(
              "File: ${_lessonDetailsController.currentLessonData.value.fileType}",
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 55,
              child: DownloadFile(urlFile: _lessonDetailsController.currentLessonData.value.fileUrl ?? ""),
            ),
          ],
        ),
      );
    } else {
      return infinityLoading(context: context);
    }
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
    final ori = (MediaQuery.of(context).orientation);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(57),
        child: simpleAppBar(
          automaticallyImplyLeading: ori == Orientation.portrait,
          context: context,
          title: _lessonDetailsController.flattenCourseItem[_lessonDetailsController.indexFlatten.value].name,
        ),
      ),
      body: Column(
        children: <Widget>[
          _body(),
          Expanded(child: Container()),
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
