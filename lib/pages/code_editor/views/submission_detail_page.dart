import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../pages.dart';
import '../models/models.dart';
import '../../../../constants/constants.dart';
import '../../../../widgets/widgets.dart';
import '../../lesson_details/models/models.dart';

class SubmissionDetailPage extends StatefulWidget {
  final String languageId;
  final String languageName;
  final dynamic themeMode;
  final String sourceCode;
  final QuestionData questionData;
  final int? quizId;
  final List<Map<String, dynamic>> listLanguage;
  final List<TestCase> listTestCase;
  final Map<String, String> mapIdWithNameLanguage;

  const SubmissionDetailPage({
    Key? key,
    required this.languageId,
    required this.languageName,
    this.themeMode,
    required this.sourceCode,
    required this.questionData,
    this.quizId,
    required this.listLanguage,
    required this.listTestCase,
    required this.mapIdWithNameLanguage,
  }) : super(key: key);

  @override
  _SubmissionDetailPageState createState() => _SubmissionDetailPageState();
}

class _SubmissionDetailPageState extends State<SubmissionDetailPage> with SingleTickerProviderStateMixin {
  final String $tagCodeEditorController = "HISTORY_SUBMISSION_CONTROLLER";
  late final CodeEditorController _codeEditorController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      FocusScope.of(context).requestFocus(FocusNode());
    });
    _codeEditorController = Get.put(
      CodeEditorController(
        myContext: context,
        questionData: widget.questionData,
        quizId: widget.quizId,
        currentNameLanguage: RxString(widget.languageName),
        currentIDLanguage: RxString(widget.languageId),
        codeController: customCodeEditor(
          sourceCode: widget.sourceCode,
          languageMode: widget.themeMode,
          theme: atomOneDarkTheme,
          onChangeEditor: (value){},
        ),
        listLanguage: RxList<Map<String, dynamic>>(widget.listLanguage),
        listTestCase: RxList<TestCase>(widget.listTestCase),
        mapIdWithNameLanguage: widget.mapIdWithNameLanguage,
        statusEnableCodeController: false,
      ),
      tag: $tagCodeEditorController,
    );
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CodeEditorController>(tag: $tagCodeEditorController);
    super.dispose();
  }

  late final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final ori = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: Text(
            widget.languageName,
            style: Theme.of(context).textTheme.headline3,
          ),
          centerTitle: true,
          automaticallyImplyLeading: ori == Orientation.portrait,
          leading: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_outlined),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () async {
                  if (ori == Orientation.portrait) {
                    await SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
                  } else {
                    await SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                  }
                },
                icon: const Icon(Icons.sync_rounded),
              ),
            ),
          ],
          elevation: 0,
          bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).shadowColor,
              height: 1.0,
            ),
            preferredSize: const Size.fromHeight(1),
          ),
        ),
      ),
      body: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size(55, 55),
          child: Container(
            height: 55,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: $backgroundGreyColor, width: 1)),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: $primaryColor,
              labelStyle: Theme.of(context).textTheme.headline6,
              labelPadding: const EdgeInsets.symmetric(horizontal: 18),
              unselectedLabelColor: $neutrals400,
              tabs: [
                const Tab(
                  text: "Code",
                  icon: Icon(Icons.code),
                  iconMargin: EdgeInsets.all(0),
                ),
                Tab(
                  text: AppLocalizations.of(context)!.run_code,
                  icon: const Icon(Icons.play_arrow_outlined),
                  iconMargin: const EdgeInsets.all(0),
                ),
                Tab(
                  text: AppLocalizations.of(context)!.run_test,
                  icon: const Icon(Icons.account_tree_outlined),
                  iconMargin: const EdgeInsets.all(0),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            TextCodeEditor(
              nextToConsole: () {
                _tabController.animateTo(1); // Nhảy đến trang 2
              },
              tagController: $tagCodeEditorController,
            ),
            RunCodeEditor(
              tagController: $tagCodeEditorController,
            ),
            RunTestCodeEditor(
              tagController: $tagCodeEditorController,
            ),
          ],
        ),
      ),
    );
  }
}
