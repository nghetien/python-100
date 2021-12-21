import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class AffiliateDetailAccountItem extends StatelessWidget {
  final AffiliateDetailAccount affiliateDetailAccount;

  const AffiliateDetailAccountItem({
    Key? key,
    required this.affiliateDetailAccount,
  }) : super(key: key);

  _itemContainer({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    return Row(
      children: <Widget>[
        Text(
          "$title:",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                affiliateDetailAccount.affiliateCode,
                style: Theme.of(context).textTheme.headline4,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              ShowUCoinTextBold(
                number: affiliateDetailAccount.rewardedCoin,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          _itemContainer(
            context: context,
            title: AppLocalizations.of(context)!.user,
            value: affiliateDetailAccount.userEmail,
          ),
          const SizedBox(
            height: 8,
          ),
          _itemContainer(
            context: context,
            title: AppLocalizations.of(context)!.time,
            value: formatTimeFromTimestamp(affiliateDetailAccount.affiliatedAt),
          ),
        ],
      ),
    );
  }
}
