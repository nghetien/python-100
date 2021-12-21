import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../pages.dart';
import '../models/models.dart';
import '../../../../constants/constants.dart';
import '../../../../widgets/widgets.dart';
import '../../../../helpers/helpers.dart';
import '../../../../components/components.dart';
import '../../../../models/models.dart';
import '../../../../states/auth_state.dart';

class ReplyCommentPage extends StatefulWidget {
  final Comment currentComment;

  const ReplyCommentPage({
    Key? key,
    required this.currentComment,
  }) : super(key: key);

  @override
  _ReplyCommentPageState createState() => _ReplyCommentPageState();
}

class _ReplyCommentPageState extends State<ReplyCommentPage> {
  final FeedbackController _feedbackController = Get.find<FeedbackController>();
  late final ReplyCommentController _replyCommentController;
  final TextEditingController _replyEditorController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _replyCommentController = Get.put(
      ReplyCommentController(
        myContext: context,
        questionData: _feedbackController.questionData,
        parentComment: widget.currentComment,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ReplyCommentController>();
    super.dispose();
  }

  Icon checkStatusFeedback({required String type, double? size = 18}) {
    switch (type) {
      case $comment:
        return Icon(
          Icons.message_outlined,
          size: size,
          color: $primaryColor,
        );
      case $reportContentError:
        return Icon(
          Icons.text_fields_rounded,
          size: size,
          color: $errorColor,
        );
      case $reportAppError:
        return Icon(
          Icons.app_blocking_rounded,
          size: size,
          color: $errorColor,
        );
      case $requestFeature:
        return Icon(
          Icons.account_tree_rounded,
          size: size,
          color: Colors.blueAccent,
        );
      case $requestSupport:
        return Icon(
          Icons.support_agent_rounded,
          size: size,
          color: $yellow400,
        );
      default:
        return Icon(
          Icons.message_outlined,
          size: size,
          color: $primaryColor,
        );
    }
  }

  _showPopupSelectOptions({required int idComment}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
          child: ButtonFullColorWithIconPrefix(
            iconBtn: const Icon(
              Icons.delete,
              color: $whiteColor,
            ),
            colorBtn: $errorColor,
            paddingBtn: const EdgeInsets.symmetric(vertical: 12),
            onPressCallBack: () async {
              final value = await showSimpleDialog(
                context: context,
                title: AppLocalizations.of(context)!.delete_feedback,
                content: AppLocalizations.of(context)!.are_you_sure_delete_feedback,
                titlePadding: const EdgeInsets.symmetric(vertical: 12),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              );
              if (value == true) {
                Navigator.pop(context);
                _replyCommentController.deleteAComment(idComment: idComment);
              }
            },
            textBtn: AppLocalizations.of(context)!.delete_feedback,
          ),
        );
      },
    );
  }

  _commentContainer({
    required Comment comment,
  }) {
    if (comment.id == -1) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatarWithOutClick(
              imageUrl: comment.userAvatar,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(color: $backgroundGreyColor, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          comment.userName ?? "",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          comment.content,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8, top: 8),
                    height: 15,
                    width: 15,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>($primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatarWithOutClick(
            imageUrl: comment.userAvatar,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(color: $backgroundGreyColor, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  comment.userName ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              checkStatusFeedback(type: comment.type),
                            ],
                          ),
                          Text(
                            comment.content,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -5,
                      right: -6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          shape: const CircleBorder(),
                          primary: Colors.transparent,
                          onPrimary: $green200,
                          elevation: 0,
                        ),
                        child: const Icon(
                          Icons.more_horiz_rounded,
                          color: $greyColor,
                        ),
                        onPressed: () {
                          _showPopupSelectOptions(
                            idComment: comment.id,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  formatTimeFromTimestamp(comment.lastReplyAt),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _listReplyComment() {
    return Obx(
      () {
        if (_replyCommentController.listReply.isNotEmpty) {
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              /// Load more data
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                if (_replyCommentController.listReply.isNotEmpty &&
                    _replyCommentController.page.value < _replyCommentController.maxPage.value) {
                  _replyCommentController.loadMoreListReply();
                }
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _replyCommentController.listReply.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: _commentContainer(comment: _replyCommentController.listReply[0]),
                  );
                } else {
                  if (index == _replyCommentController.listReply.length) {
                    if (_replyCommentController.page.value >= _replyCommentController.maxPage.value) {
                      return const SizedBox(
                        height: 0,
                        width: 0,
                      );
                    } else {
                      return infinityLoading(context: context);
                    }
                  } else {
                    Comment comment = _replyCommentController.listReply[index];
                    return Container(
                      margin: const EdgeInsets.only(left: 45),
                      child: _commentContainer(comment: comment),
                    );
                  }
                }
              },
            ),
          );
        } else {
          return Container(
            margin: const EdgeInsets.only(top: 24),
            child: _commentContainer(comment: widget.currentComment),
          );
        }
      },
    );
  }

  _body() {
    final size = MediaQuery.of(context).size;
    return InkWell(
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _listReplyComment(),
            ),
          ),
          size.height > 450
              ? _yourComment()
              : const SizedBox(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
    );
  }

  String currentType = $comment;
  static const List<String> listTypeComment = [
    $comment,
    $reportContentError,
    $reportAppError,
    $requestFeature,
    $requestSupport
  ];

  List<Map<String, String>> _listTypeComment(){
    return [
      {"key": $comment, "value": AppLocalizations.of(context)!.comment},
      {"key": $reportContentError, "value": AppLocalizations.of(context)!.report_content_error},
      {"key": $reportAppError, "value": AppLocalizations.of(context)!.report_app_error},
      {"key": $requestFeature, "value": AppLocalizations.of(context)!.request_feature},
      {"key": $requestSupport, "value": AppLocalizations.of(context)!.request_support},
    ];
  }

  _showPopupSelectType() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          physics: const BouncingScrollPhysics(),
          itemCount: _listTypeComment().length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              activeColor: $primaryColor,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: currentType == _listTypeComment()[index]["key"],
              onChanged: (value) {
                Navigator.pop(context);
                if (value == true) {
                  setState(() {
                    currentType = _listTypeComment()[index]["key"] ?? $comment;
                  });
                }
              },
              title: Text(
                _listTypeComment()[index]["value"] ?? "",
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
                  fontWeight: Theme.of(context).textTheme.headline6!.fontWeight,
                  fontSize: Theme.of(context).textTheme.headline6!.fontSize,
                  letterSpacing: Theme.of(context).textTheme.headline6!.letterSpacing,
                  height: Theme.of(context).textTheme.headline6!.height,
                  color: currentType == listTypeComment[index] ? $primaryColor : Theme.of(context).textTheme.bodyText2!.color,
                ),
              ),
              secondary: checkStatusFeedback(type: listTypeComment[index], size: 24),
            );
          },
        );
      },
    );
  }

  _yourComment() {
    return SizedBox(
      height: 65,
      child: Row(
        children: <Widget>[
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onPressed: () {
              _showPopupSelectType();
            },
            icon: checkStatusFeedback(type: currentType, size: 30),
          ),
          Expanded(
            child: InputOutLine(
              textEditingController: _replyEditorController,
              hintTextInput: AppLocalizations.of(context)!.comment,
              borderRadius: 20,
              colorBorderFocusInput: $primaryColor,
              textColor: Theme.of(context).textTheme.bodyText1!.color,
              paddingInput: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onPressed: () async {
              if (_replyEditorController.text.isNotEmpty) {
                _scrollController.jumpTo(0);
                FocusScope.of(context).requestFocus(FocusNode());
                final String contentReply = _replyEditorController.text;
                _replyEditorController.clear();
                final User currentUser = context.read<AuthState>().getUserModel;
                _replyCommentController.insertNewComment(Comment.sampleComment(
                  content: contentReply,
                  avatar: currentUser.avatar,
                  nameUser: currentUser.fullName,
                ));
                await _replyCommentController.feedbackSubmission(
                  value: contentReply,
                  type: currentType,
                  parentID: widget.currentComment.id,
                );
              }
            },
            icon: const Icon(
              Icons.send_rounded,
              color: $primaryColor,
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ori = MediaQuery.of(context).orientation;
    return WillPopScope(
      onWillPop: () async {
        _feedbackController.fetchFeedbackSubmission();
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            title: Text(
              AppLocalizations.of(context)!.comment,
              style: Theme.of(context).textTheme.headline3,
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: IconButton(
                onPressed: () {
                  _feedbackController.fetchFeedbackSubmission();
                  Navigator.pop(context);
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
        body: _body(),
      ),
    );
  }
}
