import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages.dart';
import '../../../../constants/constants.dart';
import '../../../../widgets/widgets.dart';

enum PageRunCode {
  stdout,
  stderr,
  compile,
  message,
}

class RunCodeEditor extends StatefulWidget {
  final String tagController;

  const RunCodeEditor({
    Key? key,
    required this.tagController,
  }) : super(key: key);

  @override
  _RunCodeEditorState createState() => _RunCodeEditorState();
}

class _RunCodeEditorState extends State<RunCodeEditor> {
  late final CodeEditorController _codeEditorController;
  PageRunCode currentIndex = PageRunCode.stdout;

  @override
  void initState() {
    _codeEditorController = Get.find<CodeEditorController>(tag: widget.tagController);
    super.initState();
  }

  _titleItem({required bool value, required Widget title, required PageRunCode valueChange}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: value ? $primaryColor : Colors.transparent,
          ),
        ),
        color: value ? $backgroundCodeEditor : $backgroundBtnCodeEditor,
      ),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            currentIndex = valueChange;
          });
        },
        child: title,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: $backgroundCodeEditor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // <-- Radius
          ),
        ),
      ),
    );
  }

  _showText(String value) {
    return Text(
      value,
      style: const TextStyle(color: $whiteColor),
    );
  }

  _showTextError(String value) {
    return Row(
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(color: $errorColor),
        ),
        const SizedBox(
          width: 8,
        ),
        const Icon(
          Icons.info_outline,
          color: $errorColor,
        ),
      ],
    );
  }

  _listTitleRun() {
    return Obx(
      () {
        return Container(
          color: $backgroundBtnCodeEditor,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _titleItem(
                  value: currentIndex == PageRunCode.stdout,
                  title: _showText("STDOUT"),
                  valueChange: PageRunCode.stdout,
                ),
                _titleItem(
                  value: currentIndex == PageRunCode.stderr,
                  title:
                      _codeEditorController.showStderr.value.isEmpty ? _showText("STDERR") : _showTextError("STDERR"),
                  valueChange: PageRunCode.stderr,
                ),
                _titleItem(
                  value: currentIndex == PageRunCode.compile,
                  title: _codeEditorController.showCompile.value.isEmpty
                      ? _showText("COMPILE")
                      : _showTextError("COMPILE"),
                  valueChange: PageRunCode.compile,
                ),
                _titleItem(
                  value: currentIndex == PageRunCode.message,
                  title: _codeEditorController.showMessage.value.isEmpty
                      ? _showText("MESSAGE")
                      : _showTextError("MESSAGE"),
                  valueChange: PageRunCode.message,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _listShowSTD() {
    return Obx(() {
      if (_codeEditorController.isRunCode.value) {
        return Center(
          child: infinityLoading(context: context),
        );
      } else {
        if (currentIndex == PageRunCode.stdout) {
          return Text(
            _codeEditorController.showStdout.value,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: $whiteColor,
              fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
              fontSize: Theme.of(context).textTheme.headline5!.fontSize,
            ),
          );
        } else if (currentIndex == PageRunCode.stderr) {
          return Text(
            _codeEditorController.showStderr.value,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: $errorColor,
              fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
              fontSize: Theme.of(context).textTheme.headline5!.fontSize,
            ),
          );
        } else if (currentIndex == PageRunCode.compile) {
          return Text(
            _codeEditorController.showCompile.value,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: $errorColor,
              fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
              fontSize: Theme.of(context).textTheme.headline5!.fontSize,
            ),
          );
        } else {
          return Text(
            _codeEditorController.showMessage.value,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: $errorColor,
              fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
              fontSize: Theme.of(context).textTheme.headline5!.fontSize,
            ),
          );
        }
      }
    });
  }

  _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _listTitleRun(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              alignment: Alignment.topLeft,
              color: $backgroundCodeEditor,
              child: _listShowSTD(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      color: $backgroundCodeEditor,
      child: _body(),
    );
  }
}
