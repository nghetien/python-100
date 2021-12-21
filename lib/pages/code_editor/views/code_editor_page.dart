import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:highlight/languages/python.dart';

import '../../pages.dart';
import '../models/models.dart';
import '../../lesson_details/models/models.dart';
import '../../../../constants/constants.dart';
import '../../../../widgets/widgets.dart';
import '../../../../helpers/helpers.dart';

class CodeEditorPage extends StatefulWidget {
  final String statementQuestion;
  final QuestionData questionData;
  final int? quizId;
  final int? courseID;

  const CodeEditorPage({
    Key? key,
    required this.statementQuestion,
    required this.questionData,
    this.quizId,
    this.courseID,
  }) : super(key: key);

  @override
  _CodeEditorPageState createState() => _CodeEditorPageState();
}

class _CodeEditorPageState extends State<CodeEditorPage> with SingleTickerProviderStateMixin {
  final String $tagCodeEditorController = "TAG_EDITOR_CONTROLLER";

  late final CodeEditorController _codeEditorController;
  late final HistorySubmissionController _historySubmissionController;
  late final FeedbackController _feedbackController;
  late final TabController _tabController;

  final _debounce = Debounce(seconds: 5);

  _sendDaft(String value) {
    _debounce.run(() {});
  }

  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      FocusScope.of(context).requestFocus(FocusNode());
    });
    _codeEditorController = Get.put(
      CodeEditorController(
        myContext: context,
        questionData: widget.questionData,
        quizId: widget.quizId,
        currentIDLanguage: RxString("71"),
        currentNameLanguage: RxString($python3),
        codeController: customCodeEditor(
          sourceCode: "print(\"Hello, world!\");",
          languageMode: python,
          theme: atomOneDarkTheme,
          onChangeEditor: _sendDaft,
        ),
        listLanguage: RxList<Map<String, dynamic>>([]),
        listTestCase: RxList<TestCase>([]),
        mapIdWithNameLanguage: {},
        statusEnableCodeController: true,
      ),
      tag: $tagCodeEditorController,
    );
    _historySubmissionController = Get.put(
      HistorySubmissionController(
        myContext: context,
        questionData: widget.questionData,
        quizId: widget.quizId,
      ),
    );
    _feedbackController = Get.put(
      FeedbackController(
        myContext: context,
        questionData: widget.questionData,
        lessonId: widget.quizId,
        courseId: widget.courseID,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _debounce.dispose();
    Get.delete<CodeEditorController>(tag: $tagCodeEditorController);
    Get.delete<HistorySubmissionController>();
    Get.delete<FeedbackController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ori = MediaQuery.of(context).orientation;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _codeEditorController.statusQuestion.value);
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            automaticallyImplyLeading: ori == Orientation.portrait,
            leading: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: IconButton(
                onPressed: () async {
                  Navigator.pop(context, _codeEditorController.statusQuestion.value);
                },
                icon: const Icon(Icons.arrow_back_outlined),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                icon: const Icon(Icons.keyboard_hide_outlined),
              ),
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
                isScrollable: ori == Orientation.portrait,
                indicatorColor: $primaryColor,
                labelStyle: Theme.of(context).textTheme.headline6,
                labelPadding: const EdgeInsets.symmetric(horizontal: 18),
                unselectedLabelColor: $neutrals400,
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)!.problem,
                    icon: const Icon(Icons.wysiwyg_outlined),
                    iconMargin: const EdgeInsets.all(0),
                  ),
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
                  Tab(
                    text: AppLocalizations.of(context)!.submissions,
                    icon: const Icon(Icons.history_outlined),
                    iconMargin: const EdgeInsets.all(0),
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.feedback,
                    icon: const Icon(Icons.feedback_outlined),
                    iconMargin: const EdgeInsets.all(0),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              QuestionCodeEditor(
                statementQuestion: widget.statementQuestion,
                questionData: widget.questionData,
              ),
              TextCodeEditor(
                nextToConsole: () {
                  _tabController.animateTo(2); // Nhảy đến trang 2
                },
                tagController: $tagCodeEditorController,
              ),
              RunCodeEditor(
                tagController: $tagCodeEditorController,
              ),
              RunTestCodeEditor(
                tagController: $tagCodeEditorController,
              ),
              HistoryCodeEditor(
                tagController: $tagCodeEditorController,
              ),
              const FeedbackCodeEditor(),
            ],
          ),
        ),
      ),
    );
  }
}
