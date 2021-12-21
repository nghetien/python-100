import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ShowListCurriculum extends StatefulWidget {
  const ShowListCurriculum({Key? key}) : super(key: key);

  @override
  _ShowListCurriculumState createState() => _ShowListCurriculumState();
}

class _ShowListCurriculumState extends State<ShowListCurriculum> {
  final CourseDetailController _courseDetailController = Get.find<CourseDetailController>();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
