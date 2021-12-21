import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoMoreRecord extends StatelessWidget {
  const NoMoreRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.no_more_record,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }
}
