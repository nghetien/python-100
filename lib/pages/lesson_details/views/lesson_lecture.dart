import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../widgets/widgets.dart';
import '../../../layouts/layouts.dart';
import '../../../states/states.dart';

class LessonLecture extends StatefulWidget {
  const LessonLecture({Key? key}) : super(key: key);

  @override
  _LessonLectureState createState() => _LessonLectureState();
}

class _LessonLectureState extends State<LessonLecture> {
  final LessonDetailsController _lessonDetailsController = Get.find<LessonDetailsController>();
  late WebViewController _controller;

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  _body() {
    String userId = context.watch<AuthState>().getUserModel.id.toString();
    String lessonId =
        _lessonDetailsController.flattenCourseItem[_lessonDetailsController.indexFlatten.value].lessonItemId.toString();
    String slug = _lessonDetailsController.currentCourse.value.slug;
    String urlWeb = "${$urlWebViewCourseStudy}$slug?l=$lessonId&u=$userId";
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: urlWeb,
      onWebViewCreated: (controller) async {
        _controller = controller;
        _controller.evaluateJavascript("document.getElementsByTagName('header')[0].style.display='none'");
        _controller.evaluateJavascript("document.getElementsByClassName('facebook-chat')[0].style.display='none'");
        _controller.evaluateJavascript("document.getElementsByClassName('cs-footer')[0].style.display='none'");
        _controller.evaluateJavascript("document.getElementById('responsive-layout-header').style.display='none'");
      },
      onPageFinished: (url) {
        _controller.evaluateJavascript("document.getElementsByTagName('header')[0].style.display='none'");
        _controller.evaluateJavascript("document.getElementsByClassName('facebook-chat')[0].style.display='none'");
        _controller.evaluateJavascript("document.getElementsByClassName('cs-footer')[0].style.display='none'");
        _controller.evaluateJavascript("document.getElementById('responsive-layout-header').style.display='none'");
      },
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
