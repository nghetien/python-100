import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/components.dart';
import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../layouts/layouts.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

enum ToggleAffiliatePage {
  create,
  listAffiliate,
}

class AffiliatePage extends StatefulWidget {
  const AffiliatePage({Key? key}) : super(key: key);

  @override
  _AffiliatePageState createState() => _AffiliatePageState();
}

class _AffiliatePageState extends State<AffiliatePage> {
  late AffiliateController _affiliateController;

  /// toggle page
  ToggleAffiliatePage togglePage = ToggleAffiliatePage.listAffiliate;

  @override
  void initState() {
    _affiliateController = Get.put(AffiliateController(myContext: context));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<AffiliateController>();
    super.dispose();
  }

  /// Show Form create ----------------------------------------

  final FocusNode _affiliateCodeFN = FocusNode();
  final FocusNode _affiliateNoteFN = FocusNode();

  final TextEditingController _affiliateCode = TextEditingController();
  final TextEditingController _affiliateNote = TextEditingController();

  _textRequired(String title) {
    return Row(
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.headline6),
        const SizedBox(width: 8),
        const Flexible(
          child: Text(
            "*",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: $errorColor),
          ),
        ),
      ],
    );
  }

  _textError({required String text}) {
    if (text == $EMPTY) {
      text = AppLocalizations.of(context)!.not_be_empty;
    } else if (text == $INVALID) {
      text = AppLocalizations.of(context)!.error_create_affiliate;
    } else {
      text = "";
    }
    return Text(
      text,
      style: TextStyle(
        color: $red500,
        fontFamily: Theme.of(context).textTheme.caption!.fontFamily,
        fontWeight: Theme.of(context).textTheme.caption!.fontWeight,
        fontSize: Theme.of(context).textTheme.caption!.fontSize,
        letterSpacing: Theme.of(context).textTheme.caption!.letterSpacing,
      ),
    );
  }

  _infoItem({
    required Widget title,
    required String hintText,
    TextInputAction? textInputAction,
    TextInputType? type,
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    Function? onEditingCompleteInput,
    required Function(String) onChange,
    required String error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title,
        const SizedBox(height: 8),
        InputOutLine(
          hintTextInput: hintText,
          typeInput: type ?? TextInputType.text,
          actionInput: textInputAction ?? TextInputAction.next,
          textColor: Theme.of(context).textTheme.headline6!.color,
          backgroundColor: Theme.of(context).backgroundColor,
          colorBorderInput: $hoverColor,
          colorBorderFocusInput: $primaryColor,
          borderRadius: 12,
          textEditingController: textEditingController,
          focusInput: focusNode,
          onEditingCompleteInput: onEditingCompleteInput,
          onChange: (value) {
            onChange(value);
          },
        ),
        _textError(text: error),
      ],
    );
  }

  _showCreateAffiliateForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.note_create_affiliate,
          style: TextStyle(
            color: $primaryColor,
            fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
            fontWeight: Theme.of(context).textTheme.headline6!.fontWeight,
            fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
            height: Theme.of(context).textTheme.bodyText2!.height,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Obx(() {
          return _infoItem(
            textEditingController: _affiliateCode,
            textInputAction: TextInputAction.next,
            focusNode: _affiliateCodeFN,
            onEditingCompleteInput: () {
              FocusScope.of(context).requestFocus(_affiliateNoteFN);
            },
            hintText: AppLocalizations.of(context)!.fill_in_affiliate_code,
            title: _textRequired(AppLocalizations.of(context)!.affiliate_code),
            onChange: (value) {
              _affiliateController.handleChangeAffiliateCode(value);
            },
            error: _affiliateController.errorAffiliateCode.value,
          );
        }),
        const SizedBox(
          height: 8,
        ),
        _infoItem(
          focusNode: _affiliateNoteFN,
          textEditingController: _affiliateNote,
          textInputAction: TextInputAction.done,
          hintText: AppLocalizations.of(context)!.fill_in_note,
          title: Text(AppLocalizations.of(context)!.note, style: Theme.of(context).textTheme.headline6),
          onChange: (value) {},
          error: "",
        ),
        const SizedBox(
          height: 8,
        ),
        ButtonFullColor(
          widthBtn: double.infinity,
          paddingBtn: const EdgeInsets.symmetric(vertical: 16),
          textBtn: AppLocalizations.of(context)!.add,
          onPressCallBack: () {
            _affiliateController.addNewAffiliate(_affiliateCode.text, _affiliateNote.text).then((value) {
              if (value) {
                _affiliateNote.text = "";
                _affiliateCode.text = "";
              }
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 100,
          child: TextButton(
            onPressed: () {
              setState(() {
                togglePage = ToggleAffiliatePage.listAffiliate;
              });
            },
            style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
            child: Row(
              children: <Widget>[
                const Icon(Icons.navigate_before_rounded),
                Text(AppLocalizations.of(context)!.back),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  /// Show List ----------------------------------------

  _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.my_affiliate,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        ButtonFullColorWithIconPrefix(
          textBtn: AppLocalizations.of(context)!.add,
          onPressCallBack: () {
            setState(() {
              togglePage = ToggleAffiliatePage.create;
            });
          },
          paddingBtn: const EdgeInsets.fromLTRB(12, 8, 20, 8),
          iconBtn: const Icon(
            Icons.add_outlined,
            color: $whiteColor,
          ),
        ),
      ],
    );
  }

  _showListMyAffiliate() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        /// Load more data
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          if (_affiliateController.listMyAffiliate.isNotEmpty &&
              _affiliateController.page.value < _affiliateController.maxPage.value) {
            _affiliateController.loadMoreMyAffiliate();
          }
        }
        return false;
      },
      child: RefreshIndicator(
        backgroundColor: $green100,
        onRefresh: () async {
          /// Refresh data
          await _affiliateController.fetchMyAffiliate();
        },
        child: ListView.separated(
          separatorBuilder: (_, index) => const Line1(
            widthLine: 0.5,
          ),
          addAutomaticKeepAlives: false,
          itemCount: _affiliateController.listMyAffiliate.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == _affiliateController.listMyAffiliate.length) {
              if (_affiliateController.page.value >= _affiliateController.maxPage.value ||
                  _affiliateController.listMyAffiliate.isEmpty) {
                return const NoMoreRecord();
              } else {
                return infinityLoading(context: context);
              }
            }
            return AffiliateItem(
              affiliate: _affiliateController.listMyAffiliate[index],
            );
          },
        ),
      ),
    );
  }

  _body() {
    if (togglePage == ToggleAffiliatePage.listAffiliate) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            _header(),
            const SizedBox(
              height: 8,
            ),
            Obx(() {
              if (_affiliateController.loadingStatus.value == StatusLoadAffiliate.pending) {
                return infinityLoading(context: context);
              } else if (_affiliateController.loadingStatus.value == StatusLoadAffiliate.failed) {
                return const NoMoreRecord();
              } else {
                return Expanded(
                  child: _showListMyAffiliate(),
                );
              }
            }),
          ],
        ),
      );
    } else {
      return InkWell(
        highlightColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 16,
              ),
              Text(
                AppLocalizations.of(context)!.new_affiliate,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(
                height: 8,
              ),
              _showCreateAffiliateForm(),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: simpleAppBar(context: context, title: AppLocalizations.of(context)!.affiliate, actionsAppBar: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).backgroundColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, UrlRoutes.$affiliateDetail);
            },
            child: Text(
              AppLocalizations.of(context)!.details,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
      ]),
      body: _body(),
    );
  }
}
