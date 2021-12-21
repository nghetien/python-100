import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../pages.dart';

class InteractionSingleChoice extends StatefulWidget {
  const InteractionSingleChoice({Key? key}) : super(key: key);

  @override
  _InteractionSingleChoiceState createState() => _InteractionSingleChoiceState();
}

class _InteractionSingleChoiceState extends State<InteractionSingleChoice> {
  final QuizInteractionController _quizInteractionController = Get.find<QuizInteractionController>();

  int indexAnswer = -1;

  _body(){
    final size = MediaQuery.of(context).size;
    double widthImage = size.width;
    double heightImage = size.height;
    heightImage = widthImage *
        _quizInteractionController.optionPosition["image_height"].toDouble() /
        _quizInteractionController.optionPosition["image_width"].toDouble();
    final List<dynamic> optionPositionTop = _quizInteractionController.optionPosition["form_top_position"] ?? [];
    final List<dynamic> optionPositionLeft = _quizInteractionController.optionPosition["form_left_position"] ?? [];
    List<Widget> listItem = [];
    for (int i = 0; i < optionPositionTop.length; i++) {
      double positionTop = 0;
      double positionLeft = 0;
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
          child: Checkbox(
            checkColor: $primaryColor,
            fillColor: MaterialStateProperty.all($primaryColor),
            value: indexAnswer == i,
            onChanged: (bool? value) {
              setState(() {
                indexAnswer = value == true ? i : -1;
              });
              _quizInteractionController.changeAnswerSingleChoice(indexAnswer);
            },
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
