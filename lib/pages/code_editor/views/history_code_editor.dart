import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../pages.dart';
import '../models/models.dart';
import '../../../../constants/constants.dart';
import '../../../../widgets/widgets.dart';
import '../../../../helpers/helpers.dart';
import '../../../../components/components.dart';

class HistoryCodeEditor extends StatefulWidget {
  final String tagController;

  const HistoryCodeEditor({
    Key? key,
    required this.tagController,
  }) : super(key: key);

  @override
  _HistoryCodeEditorState createState() => _HistoryCodeEditorState();
}

class _HistoryCodeEditorState extends State<HistoryCodeEditor> {
  final CustomLoader _loader = CustomLoader();
  final HistorySubmissionController _historySubmissionController = Get.find<HistorySubmissionController>();
  late final CodeEditorController _codeEditorController;
  final CodeController historyController = CodeController(
    theme: atomOneLightTheme,
  );

  @override
  void initState() {
    _codeEditorController = Get.find<CodeEditorController>(tag: widget.tagController);
    if (_historySubmissionController.isLoadData.value) {
      _historySubmissionController.fetchHistorySubmission();
    } else {
      _historySubmissionController.reloadHistorySubmission();
    }
    super.initState();
  }

  _showPopupSelectLanguage() async {
    final String? languageId = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return ShowSelectLanguage(
          currentLanguageId: _historySubmissionController.languageID.value,
          listLanguage: _codeEditorController.listLanguage,
        );
      },
    );
    if (languageId != null && languageId.isNotEmpty) {
      _historySubmissionController.handleChangeFilter(languageId);
      await _historySubmissionController.fetchHistorySubmission();
    }
  }

  _titleBar() {
    return Container(
      padding: const EdgeInsets.only(right: 18, left: 18, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              AppLocalizations.of(context)!.history_submission,
              style: Theme
                  .of(context)
                  .textTheme
                  .headline3,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              _showPopupSelectLanguage();
            },
            child: Row(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.language),
                const SizedBox(
                  width: 4,
                ),
                const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: $primaryColor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _historyItem(HistorySubmission history) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme
            .of(context)
            .backgroundColor,
        onPrimary: $hoverColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.symmetric(horizontal: 18),
      ),
      onPressed: () async {
        _loader.showLoader(context);
        await Future.wait([
          _historySubmissionController.getResultSubmission(history.id),
          _historySubmissionController.getInfoSubmission(history.id),
        ]);
        _loader.hideLoader();
        dynamic themeMode;
        for (var item in _codeEditorController.listLanguage) {
          if (item["id"].toString() == history.language) {
            themeMode = item["languageMode"];
          }
        }
        Navigator.pushNamed(
          context,
          UrlRoutes.$submissionDetail,
          arguments: SubmissionDetailPage(
            languageId: history.language,
            languageName: _codeEditorController.mapIdWithNameLanguage[history.language] ?? "",
            themeMode: themeMode,
            sourceCode: _historySubmissionController.currentHistorySubmission.value.sourceCode,
            questionData: _historySubmissionController.questionData,
            quizId: _historySubmissionController.quizId,
            listLanguage: _codeEditorController.listLanguage,
            listTestCase: _historySubmissionController.listTestCase,
            mapIdWithNameLanguage: _codeEditorController.mapIdWithNameLanguage,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _codeEditorController.mapIdWithNameLanguage[history.language] ?? "",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline4,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${AppLocalizations.of(context)!.score}: ${history.score.toInt()}",
                style: TextStyle(
                  color: history.score == 100 ? $primaryColor : $errorColor,
                  fontWeight: Theme
                      .of(context)
                      .textTheme
                      .headline4!
                      .fontWeight,
                  fontSize: Theme
                      .of(context)
                      .textTheme
                      .headline4!
                      .fontSize,
                  fontFamily: Theme
                      .of(context)
                      .textTheme
                      .headline4!
                      .fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            formatTimeFromTimestamp(history.submittedAt),
            style: Theme
                .of(context)
                .textTheme
                .bodyText1,
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  _listHistorySubmission() {
    return Obx(
          () {
        if (_historySubmissionController.isLoadData.value && _codeEditorController.mapIdWithNameLanguage.isEmpty) {
          return infinityLoading(context: context);
        } else {
          if (_historySubmissionController.listHistorySubmission.isNotEmpty) {
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                /// Load more data
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if (_historySubmissionController.listHistorySubmission.isNotEmpty &&
                      _historySubmissionController.page.value < _historySubmissionController.maxPage.value) {
                    _historySubmissionController.loadMoreHistorySubmission();
                  }
                }
                return false;
              },
              child: RefreshIndicator(
                backgroundColor: $green100,
                onRefresh: () async {
                  /// Refresh data
                  await _historySubmissionController.reloadHistorySubmission();
                },
                child: ListView.separated(
                  separatorBuilder: (_, index) =>
                  const Line1(
                    widthLine: 0.5,
                  ),
                  addAutomaticKeepAlives: false,
                  itemCount: _historySubmissionController.listHistorySubmission.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == _historySubmissionController.listHistorySubmission.length) {
                      if (_historySubmissionController.page.value >= _historySubmissionController.maxPage.value ||
                          _historySubmissionController.listHistorySubmission.isEmpty) {
                        return const NoMoreRecord();
                      } else {
                        return infinityLoading(context: context);
                      }
                    }
                    HistorySubmission history = _historySubmissionController.listHistorySubmission[index];
                    return _historyItem(history);
                  },
                ),
              ),
            );
          } else {
            return const NoMoreRecord();
          }
        }
      },
    );
  }

  _body() {
    return Column(
      children: <Widget>[
        _titleBar(),
        Expanded(
          child: _listHistorySubmission(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }
}
