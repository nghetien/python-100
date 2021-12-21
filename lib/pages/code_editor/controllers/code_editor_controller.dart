import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/bash.dart';
import 'package:highlight/languages/basic.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/cs.dart';
import 'package:highlight/languages/lisp.dart';
import 'package:highlight/languages/elixir.dart';
import 'package:highlight/languages/erlang.dart';
import 'package:highlight/languages/fsharp.dart';
import 'package:highlight/languages/fortran.dart';
import 'package:highlight/languages/go.dart';
import 'package:highlight/languages/groovy.dart';
import 'package:highlight/languages/haskell.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/kotlin.dart';
import 'package:highlight/languages/lua.dart';
import 'package:highlight/languages/objectivec.dart';
import 'package:highlight/languages/ocaml.dart';
import 'package:highlight/languages/perl.dart';
import 'package:highlight/languages/php.dart';
import 'package:highlight/languages/r.dart';
import 'package:highlight/languages/ruby.dart';
import 'package:highlight/languages/rust.dart';
import 'package:highlight/languages/scala.dart';
import 'package:highlight/languages/swift.dart';
import 'package:highlight/languages/typescript.dart';
import 'package:highlight/languages/vbnet.dart';
import 'package:highlight/languages/sql.dart';
import 'package:highlight/languages/prolog.dart';
import 'package:highlight/languages/plaintext.dart';
import 'package:highlight/languages/d.dart';
import 'package:highlight/languages/clojure.dart';

import '../models/models.dart';
import '../../lesson_details/models/models.dart';
import '../../../../constants/constants.dart';
import '../../../../services/services.dart';
import '../../../../widgets/widgets.dart';

List<dynamic> listLanguageCodeEditor = [
  null, // assembly
  bash, // bash
  basic, // basic
  null, // C
  cpp, // C++
  cs, // C#
  null, // COBOL
  lisp, // Lisp
  elixir, // elixir
  erlang, // erlang
  fsharp, // F#
  fortran, // fortran
  go, // go
  groovy, // groovy
  haskell, // haskell
  java, // java
  javascript, // javascript
  kotlin, // kotlin
  lua, // lua
  objectivec, // objectiveC
  ocaml, // ocaml
  null, // octave
  null, // pascal
  perl, // perl
  php, // php
  python, // python 2.7.17
  python, // python 3.8.1
  r, // r
  ruby, // ruby
  rust, // rust
  swift, // swift
  typescript, // typescript
  scala, // scala
  vbnet, // visual basic.net
  null, // scratch 3
  null, // multi-file programing
  sql, // sql
  prolog, // prolog
  plaintext, // plaintext
  null, // Executable
  d, // d
  clojure, // clojure
];

class CodeEditorController extends GetxController {
  /// init
  final BuildContext myContext;
  final QuestionData questionData;
  final int? quizId;
  CodeController codeController;
  final bool statusEnableCodeController;

  CodeEditorController({
    required this.myContext,
    required this.questionData,
    this.quizId,
    required this.codeController,
    required this.mapIdWithNameLanguage,
    required this.listLanguage,
    required this.statusEnableCodeController,
    required this.listTestCase,
    required this.currentIDLanguage,
    required this.currentNameLanguage,
  });

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if (mapIdWithNameLanguage.isEmpty) {
        fetchListLanguage();
      }
    });
  }

  /// -----------------------------------------------------------------------
  /// code editor
  Map<String, String> saveHistoryCode = {};
  final CodeController stdinController = CodeController(
    theme: atomOneDarkTheme,
  );

  /// -----------------------------------------------------------------------

  /// -----------------------------------------------------------------------
  /// handle language
  RxList<Map<String, dynamic>> listLanguage;
  Map<String, String> mapIdWithNameLanguage;
  RxString currentIDLanguage;
  RxString currentNameLanguage;

  Future<void> fetchListLanguage() async {
    DataResponse res = await getSnippetJudgeLanguageResponse();
    if (res.status) {
      Map<String, String> mapTemp = {$python: $pythonInteractive};
      List<Map<String, dynamic>> listItem = [];
      for (int i = 0; i < res.data["data"].length; i++) {
        mapTemp[res.data["data"][i]["id"].toString()] = res.data["data"][i]["name"];
        listItem.add({
          "id": res.data["data"][i]["id"],
          "name": res.data["data"][i]["name"],
          "languageMode": listLanguageCodeEditor[i],
        });
      }
      listItem.add({
        "id": $python,
        "name": $pythonInteractive,
        "languageMode": python,
      });
      mapIdWithNameLanguage = mapTemp;
      listLanguage.value = listItem;
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  void handleChangeLanguage({required String idLanguage, required Function(String) listenChange}) {
    saveHistoryCode[currentIDLanguage.value] = codeController.text;
    codeController.clear();
    for (var item in listLanguage) {
      if (item["id"].toString() == idLanguage) {
        currentNameLanguage.value = item["name"];
        codeController = customCodeEditor(
          sourceCode: saveHistoryCode[item["id"].toString()] ?? "",
          languageMode: item["languageMode"],
          theme: atomOneDarkTheme,
          onChangeEditor: listenChange,
        );
        break;
      }
    }
    currentIDLanguage.value = idLanguage;
  }

  /// -----------------------------------------------------------------------

  /// -----------------------------------------------------------------------
  /// run code
  RxString showStdout = RxString("");
  RxString showStderr = RxString("");
  RxString showCompile = RxString("");
  RxString showMessage = RxString("");
  RxBool isRunCode = RxBool(false);

  Future<void> runCode() async {
    isRunCode.value = true;
    showStdout.value = "";
    showStderr.value = "";
    showCompile.value = "";
    showMessage.value = "";
    final SnippetJudgeSubmissionForm snippetJudgeSubmissionForm = SnippetJudgeSubmissionForm(
      languageId: currentIDLanguage.value == $python ? "71" : currentIDLanguage.value,
      sourceCode: codeController.text,
      inputData: stdinController.text,
      expectedOutput: "",
    );
    try {
      DataResponse submit = await submissionJudgeCodeResponse(snippetJudgeSubmissionForm.convertToJSON());
      if (submit.status) {
        if (submit.data["data"]["token"] != null && submit.data["data"]["token"].isNotEmpty) {
          DataResponse getDataWithToken = await getSubmissionJudgeTokenResponse(submit.data["data"]["token"]);
          if (getDataWithToken.status) {
            SnippetJudgeSubmissionToken getToken =
                SnippetJudgeSubmissionToken.createASnippetJudgeSubmissionFromJSON(getDataWithToken.data["data"]);
            while (getToken.status.description == $inQueue || getToken.status.description == $processing) {
              await Future.delayed(const Duration(seconds: 1));
              getDataWithToken = await getSubmissionJudgeTokenResponse(getDataWithToken.data["data"]["token"]);
              if (getDataWithToken.status) {
                getToken =
                    SnippetJudgeSubmissionToken.createASnippetJudgeSubmissionFromJSON(getDataWithToken.data["data"]);
              } else {
                break;
              }
            }
            if (getToken.status.description == $accepted) {
              showStdout.value = getToken.stdout ?? "";
            } else {
              showStderr.value = getToken.stderr ?? "";
              showCompile.value = getToken.compileOutput ?? "";
              showMessage.value = getToken.message ?? "";
            }
          } else {
            showSnackBar(myContext,
                message: AppLocalizations.of(myContext)!.run_code_fail, backgroundColor: $errorColor);
          }
        } else {
          showSnackBar(myContext, message: AppLocalizations.of(myContext)!.run_code_fail, backgroundColor: $errorColor);
        }
      } else {
        showSnackBar(myContext, message: AppLocalizations.of(myContext)!.run_code_fail, backgroundColor: $errorColor);
      }
      isRunCode.value = false;
    } catch (e) {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.run_code_fail, backgroundColor: $errorColor);
    }
  }

  RxBool statusRunTest = RxBool(false);
  RxList<TestCase> listTestCase;

  RxString statusQuestion = RxString($pending);

  Future<void> runTest(bool isSubmit) async {
    try {
      statusRunTest.value = true;
      DataResponse runTestCase = await submissionJudgeQuestionResponse(questionData.id, <String, dynamic>{
        "is_run_sample_test": isSubmit,
        "language_id": currentIDLanguage.value == $python ? 71 : int.parse(currentIDLanguage.value),
        "source_code": codeController.text,
        "quiz_id": quizId ?? ""
      });
      if (runTestCase.status) {
        if (runTestCase.data["data"]["submission_id"] != null) {
          DataResponse getResult =
              await getSubmissionJudgeResultResponse(runTestCase.data["data"]["submission_id"].toString());
          if (getResult.status) {
            SubmissionCodeResult submissionCodeResult =
                SubmissionCodeResult.createASubmissionCodeResultFromJSON(getResult.data["data"]);
            while (submissionCodeResult.status != $passed && submissionCodeResult.status != $failed) {
              await Future.delayed(const Duration(seconds: 1));
              getResult = await getSubmissionJudgeResultResponse(runTestCase.data["data"]["submission_id"].toString());
              if (getResult.status) {
                submissionCodeResult = SubmissionCodeResult.createASubmissionCodeResultFromJSON(getResult.data["data"]);
              } else {
                break;
              }
            }
            listTestCase.value = submissionCodeResult.testcases;
            if (submissionCodeResult.status == $passed) {
              statusQuestion.value = $passed;
            } else {
              statusQuestion.value = $failed;
            }
          } else {
            showSnackBar(myContext,
                message: AppLocalizations.of(myContext)!.run_test_case_fail, backgroundColor: $errorColor);
          }
        } else {
          showSnackBar(myContext,
              message: AppLocalizations.of(myContext)!.run_test_case_fail, backgroundColor: $errorColor);
        }
      } else {
        showSnackBar(myContext,
            message: AppLocalizations.of(myContext)!.run_test_case_fail, backgroundColor: $errorColor);
      }
      statusRunTest.value = false;
    } catch (e) {
      showSnackBar(myContext,
          message: AppLocalizations.of(myContext)!.run_test_case_fail, backgroundColor: $errorColor);
    }
  }

  /// -----------------------------------------------------------------------
}
