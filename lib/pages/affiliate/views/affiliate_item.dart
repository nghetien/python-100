import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class AffiliateItem extends StatelessWidget {
  final Affiliate affiliate;

  const AffiliateItem({
    Key? key,
    required this.affiliate,
  }) : super(key: key);

  _itemContainer({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Text(
            "$title:",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyText1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        affiliate.code,
                        style: Theme.of(context).textTheme.headline4,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    TextButton(
                      style:
                      TextButton.styleFrom(primary: Theme.of(context).backgroundColor, padding: const EdgeInsets.all(0)),
                      onPressed: () async {
                        final String affiliateUrl = "${$domainWeb}/sign-up?ref=${affiliate.code}";
                        await FlutterClipboard.copy(affiliateUrl);
                        showSimpleSnackBar(
                          context: context,
                          value: AppLocalizations.of(context)!.copy_link_affiliate,
                          backgroundColor: $primaryColor,
                        );
                      },
                      child: const Icon(
                        Icons.copy_outlined,
                        color: $primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style:
                TextButton.styleFrom(primary: Theme.of(context).backgroundColor, padding: const EdgeInsets.all(0)),
                onPressed: () async {
                  final String affiliateUrl = "${$domainWeb}/sign-up?ref=${affiliate.code}";
                  Share.share(affiliateUrl);
                },
                child: const Icon(
                  Icons.share_rounded,
                  color: $primaryColor,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _itemContainer(context: context, title: AppLocalizations.of(context)!.number_user, value: affiliate.numCustomer),
              _itemContainer(context: context, title: AppLocalizations.of(context)!.number_transaction, value: affiliate.numTxn.toString()),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: <Widget>[
              Text(
                "${AppLocalizations.of(context)!.note}:",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Text(
                  affiliate.note ?? "",
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
