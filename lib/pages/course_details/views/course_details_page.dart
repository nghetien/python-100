import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    _courseDetailController = Get.put(CourseDetailController(myContext: context, idCourse: widget.currentCourse.id));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CourseDetailController>();
    super.dispose();
  }

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

  Widget createDialog(BuildContext context) => CupertinoAlertDialog(
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
      Widget showPrice = Column(
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

            /// check trạng thái thanh toán để hiển thị
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
                        Navigator.pushReplacementNamed(
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
                          builder: createDialog,
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

  _curriculumCourse() {
    if (_courseDetailController.listCourseItem.isEmpty) {
      return infinityLoading(context: context);
    }
    return Column(
      children: _courseDetailController.listCourseItem.map<Widget>((item) {
        return ExpandableMultiLevel(
          lessonItem: item,
          courseInfo: _courseDetailController.courseInfo.value,
        );
      }).toList(),
    );
  }

  _teacherInfo() {
    if (_courseDetailController.courseInfo.value.isEmpty) {
      return infinityLoading(context: context);
    }
    return InfoTeacher(
      imageUrl: _courseDetailController.courseInfo.value.teacherAvatar,
      name: _courseDetailController.courseInfo.value.teacherName,
      width: 64,
      height: 64,
      radius: 34,
    );
  }

  _showButtonPurchase() {
    return Obx(() {
      if (_courseDetailController.courseInfo.value.isPaid != true) {
        return Container(
          padding: const EdgeInsets.only(bottom: 16, top: 8),
          color: Theme.of(context).backgroundColor,
          child: Row(
            children: <Widget>[
              Text(
                "${truncateNumberToString(widget.currentCourse.price.toInt())} đ",
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
                    );
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

  _body() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _header(),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context)!.list_of_lectures,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    const SizedBox(height: 8),
                    _curriculumCourse(),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context)!.teacher,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    const SizedBox(height: 8),
                    _teacherInfo(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),

          /// check trạng thái thanh toán để hiển thị
          _showButtonPurchase(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        mouseCursor: MouseCursor.defer,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree),
            label: "Mục lục",
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
            label: "Thông tin",
            backgroundColor: Colors.blueAccent,
          ),
        ],
      ),
      body: _body(),
    );
  }
}
