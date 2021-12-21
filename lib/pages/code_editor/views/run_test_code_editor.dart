import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../pages.dart';
import '../models/models.dart';
import '../../../../constants/constants.dart';
import '../../../../widgets/widgets.dart';

class RunTestCodeEditor extends StatefulWidget {
  final String tagController;

  const RunTestCodeEditor({
    Key? key,
    required this.tagController,
  }) : super(key: key);

  @override
  _RunTestCodeEditorState createState() => _RunTestCodeEditorState();
}

class _RunTestCodeEditorState extends State<RunTestCodeEditor> {
  late final CodeEditorController _codeEditorController;

  @override
  void initState() {
    _codeEditorController = Get.find<CodeEditorController>(tag: widget.tagController);
    super.initState();
  }

  _listTitleRunTest() {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ButtonFullColorWithIconPrefix(
              iconBtn: const Icon(
                Icons.account_tree_outlined,
                color: $whiteColor,
              ),
              paddingBtn: const EdgeInsets.symmetric(vertical: 8),
              onPressCallBack: () {
                _codeEditorController.runTest(true);
              },
              textBtn: AppLocalizations.of(context)!.run_test,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: ButtonFullColorWithIconPrefix(
              iconBtn: SvgPicture.asset($assetSVGSendAnswer),
              onPressCallBack: () async {
                await _codeEditorController.runTest(false);
              },
              paddingBtn: const EdgeInsets.symmetric(vertical: 8),
              textBtn: AppLocalizations.of(context)!.submit,
            ),
          )
        ],
      ),
    );
  }

  _showResultItem({
    required int flex,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
              fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
              fontFamily: Theme.of(context).textTheme.headline5!.fontFamily,
              color: Theme.of(context).textTheme.headline5!.color,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              color: color,
              child: SingleChildScrollView(
                child: Text(
                  value,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _testCaseItem({
    required int index,
    required bool status,
    required bool isLock,
    required TestCase testCase,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: InkWell(
        onTap: () {
          if (!isLock) {
            final size = MediaQuery.of(context).size;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                contentPadding: const EdgeInsets.only(right: 18, left: 18, bottom: 24),
                titlePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                title: Text(
                  "Test Case #$index (${testCase.judgeStatusDescription})",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline5!.fontSize,
                    fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
                    fontFamily: Theme.of(context).textTheme.headline5!.fontFamily,
                    color: status ? $primaryColor : $errorColor,
                  ),
                ),
                content: SizedBox(
                  height: size.height * 0.5,
                  width: size.width * 0.9,
                  child: Column(
                    children: <Widget>[
                      _showResultItem(
                        flex: 7,
                        title: AppLocalizations.of(context)!.input,
                        value: testCase.input ?? "",
                        color: $neutrals300,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      _showResultItem(
                        flex: 3,
                        title: AppLocalizations.of(context)!.output_expected,
                        value: testCase.correctOutput ?? "",
                        color: $green100,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      _showResultItem(
                        flex: 3,
                        title: AppLocalizations.of(context)!.your_output,
                        value: testCase.actualOutput ?? "",
                        color: status ? $green100 : $red100,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              isLock ? Icons.lock_outline : Icons.visibility_outlined,
              color: status ? $primaryColor : $errorColor,
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                "Test Case #$index",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: status ? $primaryColor : $errorColor,
                  fontSize: Theme.of(context).textTheme.headline5!.fontSize,
                  fontWeight: Theme.of(context).textTheme.headline5!.fontWeight,
                  fontFamily: Theme.of(context).textTheme.headline5!.fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _listTestCase() {
    return Obx(() {
      if (_codeEditorController.statusRunTest.value) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[infinityLoading(context: context)],
        );
      } else {
        List<Widget> listItem = [];
        List<TestCase> listTestCase = _codeEditorController.listTestCase;
        for (int i = 0; i < listTestCase.length; i++) {
          listItem.add(_testCaseItem(
            index: i + 1,
            status: listTestCase[i].status == $passed ? true : false,
            isLock: listTestCase[i].correctOutput == null || listTestCase[i].correctOutput!.isEmpty ? true : false,
            testCase: listTestCase[i],
          ));
        }
        return SingleChildScrollView(
          child: Wrap(
            children: listItem,
          ),
        );
      }
    });
  }

  _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _listTitleRunTest(),
        Obx(() {
          if (_codeEditorController.statusRunTest.value) {
            return Text(
              "Test Case",
              style: TextStyle(
                color: $whiteColor,
                fontFamily: Theme.of(context).textTheme.headline3!.fontFamily,
                fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
                fontSize: Theme.of(context).textTheme.headline3!.fontSize,
              ),
            );
          } else {
            if (_codeEditorController.listTestCase.isEmpty) {
              return Text(
                "Test Case",
                style: TextStyle(
                  color: $whiteColor,
                  fontFamily: Theme.of(context).textTheme.headline3!.fontFamily,
                  fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
                  fontSize: Theme.of(context).textTheme.headline3!.fontSize,
                ),
              );
            } else {
              int countPassed = 0;
              for (var item in _codeEditorController.listTestCase) {
                if (item.status == $passed) {
                  countPassed++;
                }
              }
              return Text(
                "Test Case ($countPassed/${_codeEditorController.listTestCase.length})",
                style: TextStyle(
                  color: countPassed == _codeEditorController.listTestCase.length ? $primaryColor : $errorColor,
                  fontFamily: Theme.of(context).textTheme.headline3!.fontFamily,
                  fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
                  fontSize: Theme.of(context).textTheme.headline3!.fontSize,
                ),
              );
            }
          }
        }),
        Expanded(
          child: _listTestCase(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      color: $backgroundCodeEditor,
      child: _body(),
    );
  }
}
