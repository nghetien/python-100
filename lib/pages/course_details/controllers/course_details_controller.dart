import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../../../services/services.dart';
import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class CourseDetailController extends GetxController {
  late Rx<Course> courseInfo;
  RxBool isLoadCourseInfo = RxBool(false);
  RxList<CourseItem> listCourseItem = RxList<CourseItem>([]);

  final BuildContext myContext;
  final Course courseInit;

  final CustomLoader _loader = CustomLoader();

  CourseDetailController({
    required this.myContext,
    required this.courseInit,
  }){
    courseInfo = Rx<Course>(courseInit);
  }

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    await Future.wait([fetchInfoCourse(), fetchCurriculumCourse()]);
  }

  Future<void> fetchInfoCourse() async {
    DataResponse res = await getInfoCourseResponse(courseInit.id.toString());
    if (res.status) {
      courseInfo.value = Course.createACourseFromJson(res.data["data"]);
      isLoadCourseInfo.value = true;
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  Future<void> fetchCurriculumCourse() async {
    DataResponse res = await getCurriculumCourseResponse(courseInit.id.toString());
    if (res.status) {
      listCourseItem.value = CourseItem.createListCourseItem(res.data["data"]);
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  Future<void> joinCourse() async {
    _loader.showLoader(myContext);
    DataResponse res = await enrollCourseResponse(courseInfo.value.id.toString());
    if (res.status) {
      await fetchData();
      Navigator.pushNamed(
        myContext,
        UrlRoutes.$lessonDetails,
        arguments: LessonDetailsPage(
          currentCourse: courseInfo.value,
          listCourseItem: listCourseItem,
        ),
      );
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.join_course_fail, backgroundColor: $errorColor);
    }
    _loader.hideLoader();
  }
}
