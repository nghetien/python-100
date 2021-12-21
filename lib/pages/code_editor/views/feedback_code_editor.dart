import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';
import '../models/models.dart';
import '../../../../constants/constants.dart';
import '../../../../widgets/widgets.dart';
import '../../../../helpers/helpers.dart';
import '../../../../components/components.dart';
import '../../../../models/models.dart';
import '../../../../states/auth_state.dart';

class FeedbackCodeEditor extends StatefulWidget {
  const FeedbackCodeEditor({Key? key}) : super(key: key);

  @override
  _FeedbackCodeEditorState createState() => _FeedbackCodeEditorState();
}

class _FeedbackCodeEditorState extends State<FeedbackCodeEditor> {
  final FeedbackController _feedbackController = Get.find<FeedbackController>();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (_feedbackController.isLoadData.value) {
      _feedbackController.fetchFeedbackSubmission();
    } else {
      _feedbackController.loadFeedbackSubmission();
    }
    super.initState();
  }

  _titleBar() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.only(right: 18, left: 18, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                "${AppLocalizations.of(context)!.feedback} (${_feedbackController.maxComment})",
                style: Theme.of(context).textTheme.headline3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  currentType = $reportAppError;
                });
                _focusNodeComment.requestFocus();
              },
              child: Row(
                children:  <Widget>[
                  Text(
                    AppLocalizations.of(context)!.report,
                    style: const TextStyle(color: $errorColor),
                  ),
                  const SizedBox(width: 8,),
                  const Icon(Icons.info_outline_rounded, color: $errorColor,)
                ],
              ),
            )
          ],
        ),
      );
    });
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

  _showPopupSelectOptions({int? parentId, required int idComment}) {
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
                _feedbackController.deleteAComment(idComment: idComment, idParent: parentId);
              }
            },
            textBtn: AppLocalizations.of(context)!.delete_feedback,
          ),
        );
      },
    );
  }

  _commentContainer({
    bool? haveParent = false,
    required Comment comment,
    required Function handleTap,
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
    return Row(
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
                          parentId: haveParent == true ? comment.id : null,
                          idComment: comment.id,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      formatTimeFromTimestamp(comment.lastReplyAt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      handleTap();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.comment,
                      style: TextStyle(
                        color: $primaryColor,
                        fontSize: Theme.of(context).textTheme.button!.fontSize,
                        fontFamily: Theme.of(context).textTheme.button!.fontFamily,
                        fontWeight: Theme.of(context).textTheme.button!.fontWeight,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  _replyCommentItem(Comment reply) {
    List<Widget> listItem = [];
    if (reply.replies != null && reply.replies!.isNotEmpty) {
      for (Comment item in reply.replies ?? []) {
        listItem.add(
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: _commentContainer(
              haveParent: true,
              comment: item,
              handleTap: () {
                Navigator.pushNamed(
                  context,
                  UrlRoutes.$replyComment,
                  arguments: ReplyCommentPage(currentComment: reply),
                );
              },
            ),
          ),
        );
      }
      if (reply.numReplies > 4) {
        // API chỉ chả ra 3 comment đầu tiên
        listItem.add(
          Container(
            margin: const EdgeInsets.only(left: 45),
            child: InkWell(
              highlightColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  UrlRoutes.$replyComment,
                  arguments: ReplyCommentPage(currentComment: reply),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.load_more,
                style: TextStyle(
                  color: $primaryColor,
                  fontSize: Theme.of(context).textTheme.button!.fontSize,
                  fontFamily: Theme.of(context).textTheme.button!.fontFamily,
                  fontWeight: Theme.of(context).textTheme.button!.fontWeight,
                ),
              ),
            ),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listItem,
    );
  }

  _commentItem(Comment comment) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        children: <Widget>[
          _commentContainer(
            comment: comment,
            handleTap: () {
              Navigator.pushNamed(
                context,
                UrlRoutes.$replyComment,
                arguments: ReplyCommentPage(currentComment: comment),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(left: 45),
            child: _replyCommentItem(comment),
          ),
        ],
      ),
    );
  }

  _body() {
    return Obx(
      () {
        if (_feedbackController.isLoadData.value) {
          return infinityLoading(context: context);
        } else {
          if (_feedbackController.listComment.isNotEmpty) {
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                /// Load more data
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if (_feedbackController.listComment.isNotEmpty &&
                      _feedbackController.page.value < _feedbackController.maxPage.value) {
                    _feedbackController.loadMoreHistorySubmission();
                  }
                }
                return false;
              },
              child: RefreshIndicator(
                backgroundColor: $green100,
                onRefresh: () async {
                  /// Refresh data
                  await _feedbackController.fetchFeedbackSubmission();
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  addAutomaticKeepAlives: false,
                  itemCount: _feedbackController.listComment.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == _feedbackController.listComment.length) {
                      if (_feedbackController.page.value >= _feedbackController.maxPage.value ||
                          _feedbackController.listComment.isEmpty) {
                        return const SizedBox(
                          height: 0,
                          width: 0,
                        );
                      } else {
                        return infinityLoading(context: context);
                      }
                    }
                    Comment comment = _feedbackController.listComment[index];
                    return _commentItem(comment);
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

  String currentType = $comment;
  static const List<String> listTypeComment = [
    $comment,
    $reportContentError,
    $reportAppError,
    $requestFeature,
    $requestSupport
  ];

  List<Map<String, String>> _listTypeComment() {
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
                  color: currentType == listTypeComment[index]
                      ? $primaryColor
                      : Theme.of(context).textTheme.bodyText2!.color,
                ),
              ),
              secondary: checkStatusFeedback(type: listTypeComment[index], size: 24),
            );
          },
        );
      },
    );
  }

  final FocusNode _focusNodeComment = FocusNode();

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
              textEditingController: _textEditingController,
              hintTextInput: AppLocalizations.of(context)!.comment,
              borderRadius: 20,
              colorBorderFocusInput: $primaryColor,
              textColor: Theme.of(context).textTheme.bodyText1!.color,
              paddingInput: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              focusInput: _focusNodeComment,
            ),
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onPressed: () async {
              if (_textEditingController.text.isNotEmpty) {
                if (_feedbackController.listComment.isNotEmpty) {
                  _scrollController.jumpTo(0);
                }
                FocusScope.of(context).requestFocus(FocusNode());
                final String contentComment = _textEditingController.text;
                _textEditingController.clear();
                final User currentUser = context.read<AuthState>().getUserModel;
                _feedbackController.insertNewComment(Comment.sampleComment(
                  content: contentComment,
                  avatar: currentUser.avatar,
                  nameUser: currentUser.fullName,
                ));
                await _feedbackController.feedbackSubmission(
                  value: contentComment,
                  type: currentType,
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
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _titleBar(),
        Expanded(
          child: _body(),
        ),
        size.height > 450
            ? _yourComment()
            : const SizedBox(
                height: 0,
                width: 0,
              ),
      ],
    );
  }
}
