import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../constants/constants.dart';
import '../../../../states/states.dart';
import '../../../../services/services.dart';
import '../../../../widgets/widgets.dart';
import '../../../../models/models.dart';
import '../../pages.dart';

class LessonDetailsController extends GetxController {
  final CustomLoader _loader = CustomLoader();
  final BuildContext myContext;

  LessonDetailsController({
    required this.myContext,
    required this.currentCourse,
    required this.listCourseItem,
    required this.idLessonInit,
  });

  /// Data init
  final int idLessonInit;
  final Rx<Course> currentCourse;
  final RxList<CourseItem> listCourseItem;

  /// Run only 1 time when init Controller
  RxList<CourseItem> flattenCourseItem = RxList<CourseItem>([]);
  RxInt indexFlatten = RxInt(0);

  /// State
  Rx<LessonData> currentLessonData = Rx<LessonData>(LessonData.emptyLessonData);
  RxBool isReloadLessonData = RxBool(false);

  Future<void> fetchLessonData(int? idLesson) async {
    isReloadLessonData.value = false;
    DataResponse res = await getDataLessonResponse(idLesson.toString());
    if (res.status) {
      currentLessonData.value = LessonData.createALessonDataFromJson(res.data["data"]);
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
    isReloadLessonData.value = true;
  }

  Future<void> reloadData() async {
    final int? idLesson = flattenCourseItem[indexFlatten.value].lessonItemId;
    await fetchLessonData(idLesson);
  }

  Future<void> fetchDataInit() async {
    flattenCourseItem.value = _flattenListLesson(listCourseItem);
    indexFlatten.value = _getLessonFromLessonId(flattenCourseItem, idLessonInit);
    if (flattenCourseItem.isNotEmpty) {
      await reloadData();
    } else {
      indexFlatten.value = -1;
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        fetchDataInit();
      },
    );
    super.onInit();
  }

  Future<void> jumpToLesson(int idLesson) async {
    indexFlatten.value = _getLessonFromLessonId(flattenCourseItem, idLesson);
    await reloadData();
  }

  Future<void> nextToLesson() async {
    indexFlatten.value += 1;
    await reloadData();
  }

  Future<void> backToLesson() async {
    indexFlatten.value -= 1;
    await reloadData();
  }

  Future<void> fetchCurriculumCourse() async {
    DataResponse res = await getCurriculumCourseResponse(currentCourse.value.id.toString());
    if (res.status) {
      listCourseItem.value = CourseItem.createListCourseItem(res.data["data"]);
    }
  }

  Future<void> doneLessonVideoAndLecture(int idLesson) async {
    _loader.showLoader(myContext);
    DataResponse res = await putFinishLessonItemResponse(idLesson.toString());
    if (res.status) {
      final AuthState auth = myContext.read<AuthState>();
      await Future.wait([
        fetchCurriculumCourse(),
        fetchLessonData(flattenCourseItem[indexFlatten.value].lessonItemId ?? 0),
        auth.reloadInfoUser(),
      ]);
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
    _loader.hideLoader();
  }

  List<CourseItem> _flattenListLesson(List<CourseItem> myList) {
    List<CourseItem> result = [];
    for (CourseItem item in myList) {
      if (item.items == null || item.items!.isEmpty) {
        result.add(item);
      } else {
        if (item.lessonItemId == null) {
          result = [...result, ..._flattenListLesson(item.items ?? [])];
        } else {
          result.add(item);
        }
      }
    }
    return result;
  }

  int _getLessonFromLessonId(List<CourseItem> myList, int idLesson) {
    if (idLesson == 0) return 0;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i].lessonItemId == idLesson) {
        return i;
      }
    }
    return 0;
  }
}
