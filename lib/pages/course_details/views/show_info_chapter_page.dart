import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ShowInfoChapterPage extends StatefulWidget {
  final int index;
  final int? parentIndex;

  const ShowInfoChapterPage({
    Key? key,
    required this.index,
    this.parentIndex,
  }) : super(key: key);

  @override
  _ShowInfoChapterPageState createState() => _ShowInfoChapterPageState();
}

class _ShowInfoChapterPageState extends State<ShowInfoChapterPage> {
  final CourseDetailController _courseDetailController = Get.find<CourseDetailController>();
  final ScrollController _scrollController = ScrollController();

  _showPopUpPayment() async {
    Course courseInfo = _courseDetailController.courseInfo.value;
    final bool? isOK = await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return createDialog(context, AppLocalizations.of(context)!.course_payment, courseInfo.name);
      },
    );
    if (isOK == true) {
      Navigator.pushNamed(
        context,
        UrlRoutes.$payment,
        arguments: PaymentPage(
          currentCourse: courseInfo,
        ),
      ).then((value) {
        _courseDetailController.fetchData();
      });
    }
  }

  Future validateCourse({
    required CourseItem courseItem,
  }) async {
    if (courseItem.isLessonGroup == true) {
      if (courseItem.items.isNotEmpty) {
        courseItem = courseItem.items[0];
      } else {
        return;
      }
    }
    Course courseInfo = _courseDetailController.courseInfo.value;
    if (courseInfo.isEnrolled == true && courseInfo.isPaid == true) {
      /// Đăng ký rồi + Mua rồi --> lesson detail
      Navigator.pushNamed(
        context,
        UrlRoutes.$lessonDetails,
        arguments: LessonDetailsPage(
          currentCourse: _courseDetailController.courseInfo.value,
          listCourseItem: _courseDetailController.listCourseItem,
          idLessonStart: courseItem.lessonItemId,
        ),
      ).then((value) {
        _courseDetailController.fetchData();
      });
    } else if (courseInfo.isEnrolled == true && courseItem.isFree == true) {
      /// Đăng ký rồi + Chưa mua + miễn phí --> lesson detail
      Navigator.pushNamed(
        context,
        UrlRoutes.$lessonDetails,
        arguments: LessonDetailsPage(
          currentCourse: _courseDetailController.courseInfo.value,
          listCourseItem: _courseDetailController.listCourseItem,
          idLessonStart: courseItem.lessonItemId,
        ),
      ).then((value) {
        _courseDetailController.fetchData();
      });
    } else if (courseInfo.isEnrolled == true && courseItem.isFree != true) {
      /// Đăng ký rồi + Chưa mua + không miễn phí --> Hiển thị hỏi mua
      await _showPopUpPayment();
    } else if (courseInfo.isEnrolled != true && courseItem.isFree == true) {
      /// Chưa đăng ký + Chưa mua + miễn phí --> Hiển thị hỏi tham gia
      final bool isOK = await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return createDialog(context, AppLocalizations.of(context)!.sure_join_course, courseInfo.name);
        },
      );
      if (isOK) {
        await _courseDetailController.joinCourse();
      }
    } else {
      /// Dẫn đến trang thanh toán
      await _showPopUpPayment();
    }
  }

  Widget _buttonItem({
    required CourseItem lesson,
    required Function onPressCallBack,
  }) {
    Course courseInfo = _courseDetailController.courseInfo.value;

    Color colorBtn = Theme.of(context).backgroundColor;
    Color textColorBtn = generateColor($primaryColor, 0.7);
    Color? borderColor;
    Widget iconLeft;
    Widget iconRight = const SizedBox(height: 0, width: 0);
    if (lesson.isFree == null || lesson.isFree == false) {
      if (courseInfo.isPaid == null || courseInfo.isPaid == false) {
        colorBtn = generateColor($primaryColor, 0.12);
        textColorBtn = generateColor($primaryColor, 0.35);
        iconRight = SvgPicture.asset($assetSVGLock, color: textColorBtn, height: 25, width: 25);
      }
    }
    if (lesson.userStatus == $completed) {
      textColorBtn = $primaryColor;
    }
    if (lesson.isLessonGroup == true) {
      iconLeft = Icon(CustomIcons.readme, color: textColorBtn);
    } else {
      if (lesson.contentType == $video) {
        iconLeft = SvgPicture.asset($assetSVGFilm, color: textColorBtn, height: 25, width: 25);
      } else if (lesson.contentType == $lecture) {
        iconLeft = Icon(CustomIcons.readme, color: textColorBtn);
      } else {
        iconLeft = SvgPicture.asset($assetSVGHelpCircle, color: textColorBtn, height: 25, width: 25);
      }
    }
    if (lesson.itemType == $lesson) {
      colorBtn = Theme.of(context).backgroundColor;
      textColorBtn = generateColor($primaryColor, 0.7);
      iconRight = const SizedBox(height: 0, width: 0);
      iconLeft = Icon(CustomIcons.elementor, color: textColorBtn);
    }
    if (lesson.userStatus == $completed) {
      textColorBtn = $primaryColor;
      borderColor = $primaryColor;
      iconRight = SvgPicture.asset($assetSVGSuccess, height: 20, width: 20);
    }
    return Container(
      decoration: BoxDecoration(
        border: borderColor != null ? Border.all(color: borderColor, width: 1) : null,
        borderRadius: BorderRadius.circular(12.5),
      ),
      child: ElevatedButton(
        onPressed: () {
          onPressCallBack();
        },
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          primary: colorBtn,
          onPrimary: $greyColor,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          elevation: 0,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    right: 16,
                    left: 16,
                    top: 16,
                    bottom: widget.parentIndex == null &&
                            lesson.userPercentComplete != null &&
                            lesson.userPercentComplete != 0
                        ? 8
                        : 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              iconLeft,
                              iconRight,
                            ],
                          ),
                          Flexible(
                            child: Text(
                              lesson.name,
                              style: TextStyle(color: textColorBtn),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: textColorBtn,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "${truncateNumberToUCoin(lesson.uCoin)} EXP",
                        style: const TextStyle(
                          color: $whiteColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.parentIndex == null && lesson.userPercentComplete != null && lesson.userPercentComplete != 0
                ? Container(
                    padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
                    child: LinearPercentIndicator(
                      lineHeight: 8.0,
                      percent: (lesson.userPercentComplete ?? 0) / 100,
                      progressColor: $primaryColor,
                      backgroundColor: generateColor($primaryColor, 0.2),
                      animation: true,
                    ),
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Obx(() {
      final List<CourseItem> listCourseItem;
      final CourseItem courseItem;
      if (widget.parentIndex != null) {
        courseItem = _courseDetailController.listCourseItem[widget.parentIndex!].items[widget.index];
        listCourseItem = _courseDetailController.listCourseItem[widget.parentIndex!].items[widget.index].items;
      } else {
        courseItem = _courseDetailController.listCourseItem[widget.index];
        listCourseItem = _courseDetailController.listCourseItem[widget.index].items;
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    courseItem.name,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                CircularPercentIndicator(
                  radius: 65,
                  lineWidth: 6,
                  percent: (courseItem.userPercentComplete ?? 0) / 100,
                  backgroundColor: generateColor($primaryColor, 0.2),
                  progressColor: $primaryColor,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  center: Text(
                    "${(courseItem.userPercentComplete ?? 0).toInt()}%",
                    style: TextStyle(
                      color: $primaryColor,
                      fontFamily: Theme.of(context).textTheme.headline5!.fontFamily,
                      fontWeight: Theme.of(context).textTheme.headline5!.fontWeight,
                      fontSize: 16,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              shrinkWrap: true,
              itemCount: listCourseItem.length,
              itemBuilder: (context, index) {
                return _buttonItem(
                  lesson: listCourseItem[index],
                  onPressCallBack: () {
                    if (listCourseItem[index].itemType == $lessonItem || listCourseItem[index].isLessonGroup == true) {
                      validateCourse(courseItem: listCourseItem[index]);
                    } else {
                      Navigator.pushNamed(
                        context,
                        UrlRoutes.$infoChapterCurriculum,
                        arguments: ShowInfoChapterPage(
                          index: index,
                          parentIndex: widget.index,
                        ),
                      ).then((value) {
                        _courseDetailController.fetchData();
                      });
                    }
                  },
                );
              },
            ),
            // _buttonPurchase(),
            // const SizedBox(
            //   height: 24,
            // ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottom: PreferredSize(
          child: Container(
            color: Theme.of(context).shadowColor,
            height: 0,
          ),
          preferredSize: const Size.fromHeight(1),
        ),
      ),
      backgroundColor: $green100,
      body: _body(),
    );
  }
}
