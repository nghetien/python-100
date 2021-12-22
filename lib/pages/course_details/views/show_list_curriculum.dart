import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ShowListCurriculum extends StatefulWidget {
  final ScrollController scrollController;

  const ShowListCurriculum({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  _ShowListCurriculumState createState() => _ShowListCurriculumState();
}

class _ShowListCurriculumState extends State<ShowListCurriculum> {
  final CourseDetailController _courseDetailController = Get.find<CourseDetailController>();

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
      ).then((value){
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
      ).then((value){
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

  Widget _formShowCurriculum({
    required CourseItem courseItem,
    required List<CourseItem> listCourseItem,
    required List<Widget> listWidget,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: courseItem.userStatus == $completed ? $green100 : $neutrals200,
      ),
      child: ExpansionTile(
        onExpansionChanged: (value) {},
        title: Text(
          courseItem.name,
          style: Theme.of(context).textTheme.headline5,
        ),
        iconColor: $primaryColor,
        collapsedIconColor: $greyColor,
        collapsedBackgroundColor: Colors.transparent,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
        children: listWidget,
      ),
    );
  }

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
      ).then((value){
        _courseDetailController.fetchData();
      });
    }
  }

  Widget _buttonItem({
    required CourseItem lesson,
    required Function onPressCallBack,
  }) {
    Course courseInfo = _courseDetailController.courseInfo.value;
    Color colorBtn = Theme.of(context).backgroundColor;
    Color borderColorBtn = $neutrals300;
    Color textColorBtn = Theme.of(context).textTheme.bodyText2!.color ?? $greyColor;
    Widget iconLeft;
    Widget iconRight = const SizedBox(
      height: 0,
      width: 0,
    );
    if (lesson.isFree == null || lesson.isFree == false) {
      if (courseInfo.isPaid == null || courseInfo.isPaid == false) {
        colorBtn = $yellow100;
        borderColorBtn = $yellow500;
        textColorBtn = $yellow500;
        iconRight = SvgPicture.asset($assetSVGLock);
      }
    }
    if (lesson.userStatus == $completed) {
      colorBtn = $green100;
      borderColorBtn = $primaryColor;
      textColorBtn = $primaryColor;
      iconRight = SvgPicture.asset($assetSVGSuccess);
    }
    if (lesson.isLessonGroup == true) {
      iconLeft = Icon(
        Icons.wysiwyg,
        color: textColorBtn,
      );
    } else {
      if (lesson.contentType == $video) {
        iconLeft = SvgPicture.asset($assetSVGFilm);
      } else {
        iconLeft = SvgPicture.asset($assetSVGHelpCircle);
      }
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColorBtn, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: () {
          onPressCallBack();
        },
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          primary: colorBtn,
          onPrimary: $greyColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                style: Theme.of(context).textTheme.headline6,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buttonSingleItem({
    required CourseItem lesson,
    required Function onPressCallBack,
  }) {
    Course courseInfo = _courseDetailController.courseInfo.value;
    Color colorBtn = Theme.of(context).backgroundColor;
    Color borderColorBtn = $neutrals300;
    Color textColorBtn = Theme.of(context).textTheme.bodyText2!.color ?? $greyColor;
    if (lesson.isFree == null || lesson.isFree == false) {
      if (courseInfo.isPaid == null || courseInfo.isPaid == false) {
        colorBtn = $yellow100;
        borderColorBtn = $yellow500;
        textColorBtn = $yellow500;
      }
    }
    if (lesson.userStatus == $completed) {
      colorBtn = $green100;
      borderColorBtn = $primaryColor;
      textColorBtn = $primaryColor;
    }
    Widget iconBtn;
    if (lesson.isLessonGroup == true) {
      iconBtn = Icon(
        Icons.wysiwyg,
        color: textColorBtn,
      );
    } else {
      if (lesson.contentType == $video) {
        iconBtn = SvgPicture.asset($assetSVGFilm);
      } else {
        iconBtn = SvgPicture.asset($assetSVGHelpCircle);
      }
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: borderColorBtn, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: () {
          onPressCallBack();
        },
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          primary: colorBtn,
          onPrimary: $greyColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  iconBtn,
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      lesson.name,
                      style: Theme.of(context).textTheme.headline6,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
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
    );
  }

  Widget _showLesson({
    required CourseItem courseItem,
    required List<CourseItem> listCourseItem,
  }) {
    return _formShowCurriculum(
      courseItem: courseItem,
      listCourseItem: listCourseItem,
      listWidget: [
        GridView.builder(
          controller: widget.scrollController,
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
                validateCourse(courseItem: listCourseItem[index]);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _showChapter({
    required CourseItem courseItem,
    required List<CourseItem> listCourseItem,
  }) {
    return _formShowCurriculum(
      courseItem: courseItem,
      listCourseItem: listCourseItem,
      listWidget: listCourseItem.map<Widget>((item) {
        if (item.itemType == $lesson) {
          return _showLesson(
            courseItem: item,
            listCourseItem: item.items,
          );
        } else {
          return _buttonSingleItem(
            lesson: item,
            onPressCallBack: () {
              validateCourse(courseItem: item);
            },
          );
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _courseDetailController.listCourseItem.map<Widget>((item) {
        if (item.itemType == $chapter) {
          return _showChapter(
            courseItem: item,
            listCourseItem: item.items,
          );
        } else if (item.itemType == $lesson) {
          return _showLesson(
            courseItem: item,
            listCourseItem: item.items,
          );
        } else {
          return _buttonSingleItem(
            lesson: item,
            onPressCallBack: () {
              validateCourse(courseItem: item);
            },
          );
        }
      }).toList(),
    );
  }
}
