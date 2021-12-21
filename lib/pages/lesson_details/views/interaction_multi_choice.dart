import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../pages.dart';

class InteractionMultiChoice extends StatefulWidget {
  const InteractionMultiChoice({Key? key}) : super(key: key);

  @override
  _InteractionMultiChoiceState createState() => _InteractionMultiChoiceState();
}

class _InteractionMultiChoiceState extends State<InteractionMultiChoice> {
  final QuizInteractionController _quizInteractionController = Get.find<QuizInteractionController>();

  late List<bool> listAnswer;

  @override
  void initState() {
    List<bool> initList = [];
    for (var item in _quizInteractionController.optionPosition["form_top_position"]) {
      initList.add(false);
    }
    listAnswer = initList;
    super.initState();
  }

  _body() {
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
          top: heightImage * (positionTop - 0.045),
          left: widthImage * (positionLeft - 0.045),
          child: Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                side: const BorderSide(width: 1, color: $greyColor),
                splashRadius: 0,
              ),
            ),
            child: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all($primaryColor),
              value: listAnswer[i],
              onChanged: (bool? value) {
                setState(() {
                  listAnswer[i] = value ?? false;
                });
                _quizInteractionController.changeAnswerMultiChoice(listAnswer);
              },
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
