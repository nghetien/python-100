import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../pages.dart';
import '../../../../constants/constants.dart';
import '../../../../widgets/widgets.dart';
import '../../../../helpers/helpers.dart';

const List<String> listSpecialCharacter = [
  "TAB",
  "<",
  ">",
  "/",
  "=",
  "\"",
  "'",
  "(",
  ")",
  "{",
  "}",
  "[",
  "]",
  ".",
  ":",
  ";",
  "_",
  "!",
  "&",
  "|",
  "#",
  "*",
  "+",
  "-",
  "%",
  ",",
  "@",
  "?",
  "^",
];

class TextCodeEditor extends StatefulWidget {
  final Function nextToConsole;
  final String tagController;

  const TextCodeEditor({
    Key? key,
    required this.nextToConsole,
    required this.tagController,
  }) : super(key: key);

  @override
  _TextCodeEditorState createState() => _TextCodeEditorState();
}

class _TextCodeEditorState extends State<TextCodeEditor> {
  late final CodeEditorController _codeEditorController;

  final _debounce = Debounce(seconds: 5);

  _sendDaft(String value) {
    _debounce.run(() {});
  }

  @override
  void initState() {
    _codeEditorController = Get.find<CodeEditorController>(tag: widget.tagController);
    super.initState();
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  _showPopupSelectLanguage() async {
    final languageId = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return ShowSelectLanguage(
          currentLanguageId: _codeEditorController.currentIDLanguage.value,
          listLanguage: _codeEditorController.listLanguage,
        );
      },
    );
    if (languageId != null && languageId.isNotEmpty) {
      _codeEditorController.handleChangeLanguage(idLanguage: languageId, listenChange: _sendDaft);
      setState(() {});
    }
  }

  _optionItemKeyboard(String character) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      icon: Text(
        character,
        style: Theme.of(context).textTheme.headline6,
      ),
      onPressed: () {
        if (!_codeEditorFocusNode.hasFocus) {
          _codeEditorFocusNode.requestFocus();
        } else {
          if (character == "TAB") {
            _codeEditorController.codeController.insertStr("    ");
          } else {
            _codeEditorController.codeController.insertStr(character);
          }
        }
      },
    );
  }

  final FocusNode _stdinFocusNode = FocusNode();

  _addTopKeyboard() {
    return Container(
      color: $backgroundGreyColor,
      height: 55,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _codeEditorController.statusEnableCodeController
              ? IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    _showPopupSelectLanguage();
                  },
                  icon: const Icon(
                    Icons.settings_outlined,
                  ),
                )
              : const SizedBox(
                  height: 0,
                  width: 0,
                ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listSpecialCharacter.length,
              itemBuilder: (context, index) {
                return _optionItemKeyboard(listSpecialCharacter[index]);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ButtonFullColorWithIconPrefix(
              textBtn: "RUN",
              paddingBtn: const EdgeInsets.fromLTRB(4, 6, 8, 6),
              onPressCallBack: () {
                if (_codeEditorController.codeController.text.isNotEmpty) {
                  final size = MediaQuery.of(context).size;
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: $backgroundCodeEditor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                      titlePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      title: Text(
                        "STDIN",
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.headline5!.fontSize,
                          fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
                          fontFamily: Theme.of(context).textTheme.headline5!.fontFamily,
                          color: $whiteColor,
                        ),
                      ),
                      content: InkWell(
                        highlightColor: Colors.transparent,
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          _stdinFocusNode.requestFocus();
                        },
                        child: Container(
                          height: size.height * 0.3,
                          width: size.width * 0.9,
                          color: $backgroundCodeEditor,
                          child: SingleChildScrollView(
                            child: CodeField(
                              controller: _codeEditorController.stdinController,
                              textStyle: TextStyle(
                                fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
                                fontSize: 18,
                              ),
                              focusNode: _stdinFocusNode,
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            "Run",
                            style: TextStyle(fontSize: Theme.of(context).textTheme.headline5!.fontSize),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            widget.nextToConsole();
                            _codeEditorController.runCode();
                          },
                        )
                      ],
                    ),
                  );
                }
              },
              iconBtn: const Icon(
                Icons.play_arrow,
                color: $whiteColor,
              ),
              space: 0,
            ),
          ),
        ],
      ),
    );
  }

  final FocusNode _codeEditorFocusNode = FocusNode();

  _body() {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Expanded(
          child: InkWell(
            highlightColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            onTap: () {
              _codeEditorFocusNode.requestFocus();
            },
            child: Container(
              color: $backgroundCodeEditor,
              child: SingleChildScrollView(
                child: CodeField(
                  controller: _codeEditorController.codeController,
                  textStyle: TextStyle(fontFamily: Theme.of(context).textTheme.headline6!.fontFamily, fontSize: 18),
                  focusNode: _codeEditorFocusNode,
                  enabled: _codeEditorController.statusEnableCodeController,
                ),
              ),
            ),
          ),
        ),
        size.height > 450
            ? _addTopKeyboard()
            : const SizedBox(
                height: 0,
                width: 0,
              ),

        /// 450 khi quay ngang màn hình nếu chiều cao nhỏ hơn 450 thì lỗi màn hình
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Container(
        margin: size.height > 450 ? EdgeInsets.only(bottom: Platform.isAndroid ? 45 : 10) : const EdgeInsets.only(bottom: 0),

        /// 450 khi quay ngang màn hình nếu chiều cao nhỏ hơn 450 thì lỗi màn hình
        child: Obx(() {
          return Text(
            _codeEditorController.currentNameLanguage.value,
            style: TextStyle(
              color: $whiteColor,
              fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
              fontSize: 14,
            ),
          );
        }),
      ),
      body: _body(),
    );
  }
}
