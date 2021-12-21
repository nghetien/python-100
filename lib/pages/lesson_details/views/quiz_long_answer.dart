import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../../components/components.dart';
import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class QuizLongAnswer extends StatefulWidget {
  final QuestionData questionData;
  final int index;
  final Function(String) onChangeFunction;
  final bool titleStart;
  final String? defaultValue;

  const QuizLongAnswer({
    Key? key,
    required this.questionData,
    required this.index,
    required this.onChangeFunction,
    this.titleStart = false,
    this.defaultValue,
  }) : super(key: key);

  @override
  _QuizLongAnswerState createState() => _QuizLongAnswerState();
}

class _QuizLongAnswerState extends State<QuizLongAnswer> {
  late final quill.QuillController _controller;

  @override
  void initState() {
    if (widget.defaultValue != null && widget.defaultValue!.isNotEmpty) {
      final myJSON = jsonDecode(widget.defaultValue!);
      _controller = quill.QuillController(
        document: quill.Document.fromJson(myJSON),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _controller = quill.QuillController.basic();
    }
    _controller.addListener(() {
      widget.onChangeFunction(jsonEncode(_controller.document.toDelta().toJson()));
    });
    super.initState();
  }

  _body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          quill.QuillToolbar.basic(controller: _controller, locale: const Locale('en')),
          Expanded(
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: $greyColor, width: 1)),
              child: quill.QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode
              ),
            ),
          )
        ],
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
