import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/components.dart';
import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class QuizShortAnswer extends StatefulWidget {
  final QuestionData questionData;
  final int index;
  final Function(String) onChangeFunction;
  final bool titleStart;
  final String? defaultValue;

  const QuizShortAnswer({
    Key? key,
    required this.questionData,
    required this.index,
    required this.onChangeFunction,
    this.titleStart = false,
    this.defaultValue,
  }) : super(key: key);

  @override
  _QuizShortAnswerState createState() => _QuizShortAnswerState();
}

class _QuizShortAnswerState extends State<QuizShortAnswer> {
  late final TextEditingController simpleController;

  @override
  void initState() {
    if(widget.defaultValue != null){
      simpleController = TextEditingController(text: widget.defaultValue!);
    }else {
      simpleController = TextEditingController();
    }
    super.initState();
  }

  _body() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InputOutLine(
        textEditingController: simpleController,
        hintTextInput: AppLocalizations.of(context)!.answer,
        colorBorderFocusInput: $primaryColor,
        colorBorderInput: $neutrals300,
        textColor: $blackColor,
        onChange: (value) {
          widget.onChangeFunction(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: widget.titleStart == true ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                    child: Text(
                      "${AppLocalizations.of(context)!.question} ${(widget.index + 1).toString()} :",
                      style: Theme.of(context).textTheme.headline4,
                    )),
                const SizedBox(
                  width: 8,
                ),
                ShowUCoinWithBorder(totalUCoin: widget.questionData.uCoin),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            showMathJaxHtml(widget.questionData.statement),
            const SizedBox(
              height: 24,
            ),
            Text(
              AppLocalizations.of(context)!.answer,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            _body(),
          ],
        ),
      ),
    );
  }
}
