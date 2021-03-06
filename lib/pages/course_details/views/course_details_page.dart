import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class CourseDetailsPage extends StatefulWidget {
  final Course currentCourse;

  const CourseDetailsPage({
    Key? key,
    required this.currentCourse,
  }) : super(key: key);

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  late CourseDetailController _courseDetailController;
  final ScrollController _scrollController = ScrollController();

  static const $tagFeedbackPage = "TAG_FEEDBACK_PAGE";

  @override
  void initState() {
    _courseDetailController = Get.put(CourseDetailController(
      myContext: context,
      courseInit: widget.currentCourse,
    ));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CourseDetailController>();
    super.dispose();
  }

  /// Dialog
  //------------------------------------
  Widget createDialogJoinCourse(BuildContext context) => CupertinoAlertDialog(
        title: Text(
          AppLocalizations.of(context)!.sure_join_course,
          style: const TextStyle(fontSize: 22),
        ),
        content: Text(
          _courseDetailController.courseInfo.value.name,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );

  //------------------------------------

  /// Container
  //------------------------------------
  _infoItemContainer({required String assetImage, required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: SvgPicture.asset(assetImage),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: $green100,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        )
      ],
    );
  }

  //------------------------------------

  /// Item widget
  //------------------------------------

  _listInfoCourse() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: _infoItemContainer(
                assetImage: $assetSVGPaper5,
                title: AppLocalizations.of(context)!.time,
                value:
                    "${_courseDetailController.courseInfo.value.suggestedDuration} ${AppLocalizations.of(context)!.days}",
              ),
            ),
            Expanded(
              child: _infoItemContainer(
                assetImage: $assetSVGPaper2,
                title: "Video",
                value:
                    "${_courseDetailController.courseInfo.value.videoDuration} ${AppLocalizations.of(context)!.minutes}",
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: _infoItemContainer(
                assetImage: $assetSVGPaper4,
                title: AppLocalizations.of(context)!.number_of_lectures,
                value: _courseDetailController.courseInfo.value.numLectures.toString(),
              ),
            ),
            Expanded(
              child: _infoItemContainer(
                assetImage: $assetSVGPaper3,
                title: AppLocalizations.of(context)!.number_of_quizzes,
                value: _courseDetailController.courseInfo.value.numQuizzes.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        _infoItemContainer(
          assetImage: $assetSVGPaper1,
          title: AppLocalizations.of(context)!.pass_percentage,
          value: "${_courseDetailController.courseInfo.value.passPercentage.toString()} %",
        ),
      ],
    );
  }

  _teacherInfo() {
    return InfoTeacher(
      imageUrl: _courseDetailController.courseInfo.value.teacherAvatar,
      name: _courseDetailController.courseInfo.value.teacherName,
      width: 64,
      height: 64,
      radius: 34,
    );
  }

  _header() {
    final size = MediaQuery.of(context).size;
    final List<Widget> listItem = [
      const SizedBox(height: 16),
      Text(
        widget.currentCourse.name,
        style: Theme.of(context).textTheme.headline3,
      ),
      const SizedBox(height: 16),
      BannerImg(
        imageBanner: widget.currentCourse.coverImage,
        width: size.width - 18 * 2,
        height: ((size.width - 18 * 2) * 9) / 16,
      ),
      const SizedBox(height: 16),
      Text(
        AppLocalizations.of(context)!.course_information,
        style: Theme.of(context).textTheme.headline3,
      ),
      const SizedBox(height: 8),
    ];
    if (_courseDetailController.courseInfo.value.isEmpty) {
      listItem.add(infinityLoading(context: context));
    } else {
      Widget showPrice;
      if (_courseDetailController.courseInfo.value.isPaid != true) {
        showPrice = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Text(
                  "${AppLocalizations.of(context)!.origin_price}: ",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                originPriceWidget(context: context, originPrice: _courseDetailController.courseInfo.value.originPrice),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Text(
                  "${AppLocalizations.of(context)!.price}: ",
                  style: Theme.of(context).textTheme.headline5,
                ),
                priceWidget(context: context, price: _courseDetailController.courseInfo.value.price),
              ],
            ),
          ],
        );
      } else {
        showPrice = Container(
          margin: const EdgeInsets.only(top: 16),
          child: Text(
            AppLocalizations.of(context)!.course_is_unlocked,
            style: TextStyle(
              color: $primaryColor,
              fontSize: 24,
              fontWeight: Theme.of(context).textTheme.headline5!.fontWeight,
              fontFamily: Theme.of(context).textTheme.headline5!.fontFamily,
            ),
          ),
        );
      }
      listItem.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _courseDetailController.courseInfo.value.shortDescription,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: 16),
            _listInfoCourse(),

            /// check tr???ng th??i thanh to??n ????? hi???n th???
            showPrice,
            ShowListTags(
              listTags: _courseDetailController.courseInfo.value.tags,
            ),
            const SizedBox(height: 16),
            _courseDetailController.listCourseItem.isEmpty
                ? infinityLoading(context: context)
                : ButtonFullColor(
                    widthBtn: double.infinity,
                    paddingBtn: const EdgeInsets.symmetric(vertical: 16),
                    colorBtn: $primaryColor,
                    textBtn: _courseDetailController.courseInfo.value.isEnrolled == true
                        ? AppLocalizations.of(context)!.learn_continue
                        : AppLocalizations.of(context)!.try_course,
                    onPressCallBack: () async {
                      if (_courseDetailController.courseInfo.value.isEnrolled == true) {
                        Navigator.pushNamed(
                          context,
                          UrlRoutes.$lessonDetails,
                          arguments: LessonDetailsPage(
                            currentCourse: _courseDetailController.courseInfo.value,
                            listCourseItem: _courseDetailController.listCourseItem,
                          ),
                        );
                      } else {
                        final bool isOK = await showCupertinoDialog(
                          context: context,
                          builder: createDialogJoinCourse,
                        );
                        if (isOK) {
                          await _courseDetailController.joinCourse();
                        }
                      }
                    },
                  ),
          ],
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listItem,
    );
  }

  //------------------------------------

  /// Button
  //------------------------------------
  _showButtonPurchase() {
    return Obx(() {
      if (_courseDetailController.courseInfo.value.isPaid != true) {
        return Container(
          padding: const EdgeInsets.only(bottom: 8, top: 8, left: 18, right: 18),
          color: Theme.of(context).backgroundColor,
          child: Row(
            children: <Widget>[
              Text(
                "${truncateNumberToString(widget.currentCourse.price.toInt())} ??",
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: ButtonFullColor(
                  widthBtn: double.infinity,
                  paddingBtn: const EdgeInsets.symmetric(vertical: 16),
                  colorBtn: $yellow500,
                  textBtn: AppLocalizations.of(context)!.buy_now,
                  onPressCallBack: () {
                    Navigator.pushNamed(
                      context,
                      UrlRoutes.$payment,
                      arguments: PaymentPage(
                        currentCourse: _courseDetailController.courseInfo.value,
                      ),
                    ).then((value) {
                      _courseDetailController.fetchData();
                    });
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox(
          height: 0,
          width: 0,
        );
      }
    });
  }

  //------------------------------------

  /// Body widget
  //------------------------------------
  _infoCourse() {
    return Obx(
      () {
        return Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _header(),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context)!.teacher,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    const SizedBox(height: 8),
                    _teacherInfo(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _showButtonPurchase(),
          ],
        );
      },
    );
  }

  _descriptionCourse() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 16,
          ),
          showMathJaxHtml(_courseDetailController.courseInfo.value.description),
        ],
      ),
    );
  }

  _curriculumCourse() {
    return Obx(
      () {
        if (_courseDetailController.listCourseItem.isEmpty) {
          return infinityLoading(context: context);
        } else {
          final Size size = MediaQuery.of(context).size;
          final Course currentCourse = _courseDetailController.courseInfo.value;
          return Container(
            color: generateColor($primaryColor, 0.1),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: ( size.width * 9 ) / 16,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  flexibleSpace: _MyAppSpace(course: currentCourse,),
                  toolbarHeight: 85,
                ),
                SliverList(
                  delegate: SliverChildListDelegate([const StepByStepCurriculum()]),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  _commentCourse() {
    String getDomain = FlavorConfig.instance.variables["course_id"];
    return FeedbackCodeEditor(
      haveAppBar: false,
      tag: $tagFeedbackPage,
      courseId: int.parse(getDomain),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabContainer(
      info: _infoCourse(),
      description: _descriptionCourse(),
      curriculum: _curriculumCourse(),
      comment: _commentCourse(),
    );
  }
}

class _MyAppSpace extends StatefulWidget {
  final Course course;

  const _MyAppSpace({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  State<_MyAppSpace> createState() => _MyAppSpaceState();
}

class _MyAppSpaceState extends State<_MyAppSpace> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t = (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
        return Stack(
          children: [
            Opacity(
              opacity: 1 - opacity,
              child: _showPassPercentage(),
            ),
            Opacity(
              opacity: opacity,
              child: getImage(),
            ),
          ],
        );
      },
    );
  }

  Widget getImage() {
    final Size size = MediaQuery.of(context).size;
    return BannerImg(
      imageBanner: widget.course.coverImage,
      width: size.width,
      height: (size.width * 9) / 16,
      radius: 0,
    );
  }

  Widget _processPercentage() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 5,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).shadowColor,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 5,
            width: (size.width - 36) * ((widget.course.progress ?? 0) / 100),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              color: $primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _showPassPercentage() {
    final Course currentCourse = widget.course;
    return Container(
      padding: const EdgeInsets.all(8),
      height: 85,
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: $hoverColor, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BannerImg(
            height: 69,
            width: 122,
            imageBanner: currentCourse.coverImage,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  currentCourse.name,
                  style: Theme.of(context).textTheme.headline4,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                _processPercentage(),
                Text(
                  "${AppLocalizations.of(context)!.completed}: ${(currentCourse.progress ?? 0).toInt()}%",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
