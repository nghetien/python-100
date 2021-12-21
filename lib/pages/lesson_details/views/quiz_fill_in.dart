import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/components.dart';
import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class QuizFillIn extends StatefulWidget {
  final QuestionData questionData;
  final int index;
  final Function(String, int) onChangeFunction;
  final bool titleStart;
  final Map<int, String>? defaultValue;

  const QuizFillIn({
    Key? key,
    required this.questionData,
    required this.index,
    required this.onChangeFunction,
    this.titleStart = false,
    this.defaultValue,
  }) : super(key: key);

  @override
  _QuizFillInState createState() => _QuizFillInState();
}

class _QuizFillInState extends State<QuizFillIn> {
  late final List<Map<String, dynamic>> listShow;
  late List<TextEditingController> listTextController;

  @override
  void initState() {
    List<TextEditingController> textController = [];
    List<String> listQuestionSplit = [];
    List<String> temper = widget.questionData.statement.split("{{");
    for (var item in temper) {
      listQuestionSplit = [...listQuestionSplit, ...item.split("}}")];
      textController.add(TextEditingController());
    }
    if (widget.defaultValue != null) {
      for (int key in widget.defaultValue!.keys) {
        textController[key].text = widget.defaultValue![key] ?? "";
      }
    }
    List<Map<String, dynamic>> listTemper = [];
    int indexStart = 0;
    for (int i = 0; i < listQuestionSplit.length; i++) {
      String item = listQuestionSplit[i];
      if (item.contains(RegExp(r'^x_[0-9]*$'))) {
        listTemper.add({
          "type": $fillIn,
          "editor": indexStart,
        });
        indexStart += 1;
      } else {
        listTemper.add({
          "latex": item,
        });
      }
    }
    listShow = listTemper;
    listTextController = textController;
    super.initState();
  }

  _body() {
    List<Widget> listItem = [];
    for (int i = 0; i < listShow.length; i++) {
      Map<String, dynamic> item = listShow[i];
      if (item["type"] == $fillIn) {
        listItem.add(
          Container(
            width: 100,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: InputOutLine(
              paddingInput: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              textEditingController: listTextController[item["editor"]],
              hintTextInput: AppLocalizations.of(context)!.answer,
              colorBorderFocusInput: $primaryColor,
              colorBorderInput: $neutrals300,
              textColor: $blackColor,
              onChange: (value) {
                widget.onChangeFunction(value, item["editor"]);
              },
            ),
          ),
        );
      } else {
        if (widget.questionData.statementFormat == $html) {
          listItem.add(renderHtml(context: context, htmlString: item["latex"]));
        } else {
          listItem.add(showMathJaxHtml(item["latex"]));
        }
      }
    }
    return Wrap(
      children: listItem,
      crossAxisAlignment: WrapCrossAlignment.center,
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
            _body(),
          ],
        ),
      ),
    );
  }
}
