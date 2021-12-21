import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/components.dart';
import '../../../constants/constants.dart';
import '../../../layouts/layouts.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

enum ToggleAffiliateDetailPage {
  account,
  history,
}

class AffiliateDetailPage extends StatefulWidget {
  const AffiliateDetailPage({Key? key}) : super(key: key);

  @override
  _AffiliateDetailPageState createState() => _AffiliateDetailPageState();
}

class _AffiliateDetailPageState extends State<AffiliateDetailPage> {
  late AffiliateDetailController _affiliateDetailController;

  @override
  void initState() {
    _affiliateDetailController = Get.put(AffiliateDetailController(myContext: context));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<AffiliateDetailController>();
    super.dispose();
  }

  /// toggle page
  ToggleAffiliateDetailPage togglePage = ToggleAffiliateDetailPage.account;

  _showDetailAccount() {
    return Obx(() {
      if (_affiliateDetailController.loadingStatusAccount.value == StatusLoadAffiliate.pending) {
        return infinityLoading(context: context);
      } else if (_affiliateDetailController.loadingStatusAccount.value == StatusLoadAffiliate.failed) {
        return const NoMoreRecord();
      } else {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            /// Load more data
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              if (_affiliateDetailController.listDetailAffiliateAccount.isNotEmpty &&
                  _affiliateDetailController.pageAccount.value < _affiliateDetailController.maxPageAccount.value) {
                _affiliateDetailController.loadMoreMyAffiliateAccount();
              }
            }
            return false;
          },
          child: RefreshIndicator(
            backgroundColor: $green100,
            onRefresh: () async {
              /// Refresh data
              await _affiliateDetailController.fetchAffiliateAccount();
            },
            child: ListView.separated(
              separatorBuilder: (_, index) => const Line1(
                widthLine: 0.5,
              ),
              addAutomaticKeepAlives: false,
              itemCount: _affiliateDetailController.listDetailAffiliateAccount.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == _affiliateDetailController.listDetailAffiliateAccount.length) {
                  if (_affiliateDetailController.pageAccount.value >= _affiliateDetailController.maxPageAccount.value ||
                      _affiliateDetailController.listDetailAffiliateAccount.isEmpty) {
                    return const NoMoreRecord();
                  } else {
                    return infinityLoading(context: context);
                  }
                }
                return AffiliateDetailAccountItem(
                  affiliateDetailAccount: _affiliateDetailController.listDetailAffiliateAccount[index],
                );
              },
            ),
          ),
        );
      }
    });
  }

  _body() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 16,
          ),
          Text(
            AppLocalizations.of(context)!.history_detail,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.headline3,
          ),
          //   _toggleAffiliate(),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            // child: togglePage == ToggleAffiliateDetailPage.account ? _showDetailAccount() : _showDetailHistory(),
            child: _showDetailAccount(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: simpleAppBar(
        context: context,
        title: AppLocalizations.of(context)!.affiliate,
      ),
      body: _body(),
    );
  }
}
