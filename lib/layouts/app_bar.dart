import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../states/states.dart';

AppBar customAppBar(BuildContext context) {
  return AppBar(
    centerTitle: false,
    title: GestureDetector(
      onTap: () {
        final AppRedirect redirect = context.read<AppRedirect>();
        if (redirect.pageIndex != UrlRoutes.$home) {
          redirect.setPageIndex = UrlRoutes.$home;
        }
      },
      child: const Image(
        image: AssetImage($assetsImageLogoUSchool),
        height: 40,
      ),
    ),
    elevation: 0,
    bottom: PreferredSize(
      child: Container(
        color: Theme.of(context).shadowColor,
        height: 1.0,
      ),
      preferredSize: const Size.fromHeight(1),
    ),
  );
}

AppBar simpleAppBar({
  required BuildContext context,
  required String title,
  List<Widget>? actionsAppBar,
  Widget? leadingAppBar,
  bool automaticallyImplyLeading = true,
}) {
  return AppBar(
    automaticallyImplyLeading: automaticallyImplyLeading,
    centerTitle: true,
    leading: leadingAppBar,
    title: Text(
      title,
      style: Theme.of(context).textTheme.headline3,
    ),
    actions: actionsAppBar,
    elevation: 0,
    bottom: PreferredSize(
      child: Container(
        color: Theme.of(context).shadowColor,
        height: 1.0,
      ),
      preferredSize: const Size.fromHeight(1),
    ),
  );
}

AppBar widgetTitleAppBar({
  required BuildContext context,
  required Widget titleWidget,
  List<Widget>? actionsAppBar,
  Widget? leadingAppBar,
  bool automaticallyImplyLeading = true,
}) {
  return AppBar(
    automaticallyImplyLeading: automaticallyImplyLeading,
    centerTitle: true,
    leading: leadingAppBar,
    title: titleWidget,
    actions: actionsAppBar,
    elevation: 0,
    bottom: PreferredSize(
      child: Container(
        color: Theme.of(context).shadowColor,
        height: 1.0,
      ),
      preferredSize: const Size.fromHeight(1),
    ),
  );
}
