import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class InteractionFillIn extends StatefulWidget {
  const InteractionFillIn({Key? key}) : super(key: key);

  @override
  _InteractionFillInState createState() => _InteractionFillInState();
}

class _InteractionFillInState extends State<InteractionFillIn> {
  final QuizInteractionController _quizInteractionController = Get.find<QuizInteractionController>();
  late List<TextEditingController> listTextController;

  @override
  void initState() {
    List<TextEditingController> initList = [];
    for(var item in _quizInteractionController.optionPosition["form_top_position"]){
      initList.add(TextEditingController());
    }
    listTextController = initList;
    super.initState();
  }

  _body(){
    final size = MediaQuery.of(context).size;
    double widthImage = size.width;
    double heightImage = size.height;
    heightImage = widthImage *
        _quizInteractionController.optionPosition["image_height"].toDouble() /
        _quizInteractionController.optionPosition["image_width"].toDouble();
    final List<dynamic> optionPositionTop = _quizInteractionController.optionPosition["form_top_position"] ?? [];
    final List<dynamic> optionPositionLeft = _quizInteractionController.optionPosition["form_left_position"] ?? [];
    final List<dynamic> optionFormWidth = _quizInteractionController.optionPosition["form_width"] ?? [];
    final List<dynamic> optionFormHeight = _quizInteractionController.optionPosition["form_height"] ?? [];
    List<Widget> listItem = [];
    for (int i = 0; i < optionPositionTop.length; i++) {
      double widthBtn = 0;
      double heightBtn = 0;
      double positionTop = 0;
      double positionLeft = 0;
      if (optionFormWidth[i].runtimeType == String) {
        widthBtn = double.parse(optionFormWidth[i]) / 100;
      } else {
        widthBtn = optionFormWidth[i] / 100;
      }
      if (optionFormHeight[i].runtimeType == String) {
        heightBtn = double.parse(optionFormHeight[i]) / 100;
      } else {
        heightBtn = optionFormHeight[i] / 100;
      }
      if (optionPositionTop[i].runtimeType == String) {
        positionTop = double.parse(optionPositionTop[i]) / 100;
      } else {
        positionTop = optionPositionTop[i] / 100;
      }
      if (optionPositionLeft[i].runtimeType == String) {
        positionLeft = double.parse(optionPositionLeft[i]) / 100;
      } else {
        positionLeft = optionPositionLeft[i] / 100;
      }
      listItem.add(
        Positioned(
          top: heightImage * positionTop,
          left: widthImage * positionLeft,
          child: SizedBox(
            width: widthImage * widthBtn,
            height: heightImage * heightBtn,
            child: InputOutLine(
              hintTextInput: AppLocalizations.of(context)!.answer,
              paddingInput: const EdgeInsets.all(0),
              colorBorderInput: $neutrals300,
              colorBorderFocusInput: $primaryColor,
              textColor: $blackColor,
              onChange: (value) {
                _quizInteractionController.changeAnswerFullIn(listTextController);
              },
              textEditingController: listTextController[i],
            ),
          ),
        ),
      );
    }
    return Stack(
      children: listItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }
}
