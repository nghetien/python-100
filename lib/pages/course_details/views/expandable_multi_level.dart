import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ExpandableMultiLevel extends StatefulWidget {
  final CourseItem lessonItem;
  final Course courseInfo;

  const ExpandableMultiLevel({
    Key? key,
    required this.lessonItem,
    required this.courseInfo,
  }) : super(key: key);

  @override
  State<ExpandableMultiLevel> createState() => _ExpandableMultiLevelState();
}

class _ExpandableMultiLevelState extends State<ExpandableMultiLevel> {
  final CourseDetailController _courseDetailController = Get.find<CourseDetailController>();

  _buttonItem({
    required CourseItem lesson,
    required Function onPressCallBack,
  }) {
    Color colorBtn = Theme.of(context).backgroundColor;
    Color borderColorBtn = $neutrals300;
    Color textColorBtn = Theme.of(context).textTheme.bodyText2!.color ?? $greyColor;
    if (lesson.isFree == null || lesson.isFree == false) {
      if (widget.courseInfo.isPaid == null || widget.courseInfo.isPaid == false) {
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
    Icon iconBtn;
    if (lesson.isLessonGroup == true) {
      iconBtn = Icon(
        Icons.wysiwyg,
        color: textColorBtn,
      );
    } else {
      if (lesson.contentType == $video) {
        iconBtn = Icon(
          Icons.play_circle_outline_outlined,
          color: textColorBtn,
        );
      } else {
        iconBtn = Icon(
          Icons.help_outline_outlined,
          color: textColorBtn,
        );
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
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.button!.fontSize,
                        fontWeight: Theme.of(context).textTheme.button!.fontWeight,
                        color: textColorBtn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              "${lesson.uCoin.toString()} EXP",
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.button!.fontSize,
                fontWeight: Theme.of(context).textTheme.button!.fontWeight,
                color: textColorBtn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showPopUpPayment() async {
    final bool? isOK = await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return createDialog(context, AppLocalizations.of(context)!.course_payment, widget.courseInfo.name);
      },
    );
    if (isOK == true) {
      Navigator.pushNamed(
        context,
        UrlRoutes.$payment,
        arguments: PaymentPage(
          currentCourse: widget.courseInfo,
        ),
      );
    }
  }

  _body(CourseItem lesson) {
    if (lesson.items!.isEmpty || lesson.isLessonGroup == true) {
      return _buttonItem(
        lesson: lesson,
        onPressCallBack: () async {
          CourseItem currentLesson = lesson;
          if (lesson.isLessonGroup == true) {
            if (lesson.items!.isNotEmpty) {
              currentLesson = lesson.items![0];
            } else {
              return;
            }
          }
          if (widget.courseInfo.isEnrolled == true && widget.courseInfo.isPaid == true) {
            /// Đăng ký rồi + Mua rồi --> lesson detail
            Navigator.pushReplacementNamed(
              context,
              UrlRoutes.$lessonDetails,
              arguments: LessonDetailsPage(
                currentCourse: _courseDetailController.courseInfo.value,
                listCourseItem: _courseDetailController.listCourseItem,
                idLessonStart: currentLesson.lessonItemId,
              ),
            );
          } else if (widget.courseInfo.isEnrolled == true && currentLesson.isFree == true) {
            /// Đăng ký rồi + Chưa mua + miễn phí --> lesson detail
            Navigator.pushReplacementNamed(
              context,
              UrlRoutes.$lessonDetails,
              arguments: LessonDetailsPage(
                currentCourse: _courseDetailController.courseInfo.value,
                listCourseItem: _courseDetailController.listCourseItem,
                idLessonStart: currentLesson.lessonItemId,
              ),
            );
          } else if (widget.courseInfo.isEnrolled == true && currentLesson.isFree != true) {
            /// Đăng ký rồi + Chưa mua + không miễn phí --> Hiển thị hỏi mua
            await _showPopUpPayment();
          } else if (widget.courseInfo.isEnrolled != true && currentLesson.isFree == true) {
            /// Chưa đăng ký + Chưa mua + miễn phí --> Hiển thị hỏi tham gia
            final bool isOK = await showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return createDialog(context, AppLocalizations.of(context)!.sure_join_course, widget.courseInfo.name);
              },
            );
            if (isOK) {
              await _courseDetailController.joinCourse();
            }
          } else {
            /// Dẫn đến trang thanh toán
            await _showPopUpPayment();
          }
        },
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: $neutrals200,
        ),
        child: ExpansionTile(
          onExpansionChanged: (value) {},
          title: Text(
            lesson.name,
            style: Theme.of(context).textTheme.headline5,
          ),
          iconColor: $primaryColor,
          collapsedIconColor: $greyColor,
          collapsedBackgroundColor: Colors.transparent,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
          children: lesson.items!.map<Widget>((item) {
            return _body(item);
          }).toList(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _body(widget.lessonItem);
  }
}
