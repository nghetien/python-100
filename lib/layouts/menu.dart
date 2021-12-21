import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../helpers/helpers.dart';
import '../models/models.dart';
import '../states/states.dart';
import '../components/components.dart';
import '../constants/colors.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Widget _menuItem({
    required String title,
    Color? color,
    required VoidCallback onClickRedirect,
  }) {
    return Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: $hoverColor),
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color ?? Theme.of(context).backgroundColor,
          onPrimary: $hoverColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerLeft,
        ),
        onPressed: () {
          onClickRedirect();
        },
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }

  Widget _headerMenu() {
    final User currentUser = context.watch<AuthState>().getUserModel;
    return Container(
      padding: const EdgeInsets.only(right: 24, left: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: $hoverColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.clear),
          ),
          Row(
            children: <Widget>[
              ShowUCoinWithBorder(
                totalUCoin: currentUser.totalUcoin,
              ),
              const SizedBox(
                width: 8,
              ),
              CircleImg(
                urlImg: currentUser.avatar,
                onClickImg: () {
                  Navigator.pushNamed(context, UrlRoutes.$profile);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  _body() {
    final language = AppLocalizations.of(context)!;
    final AppRedirect redirect = context.watch<AppRedirect>();
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        _headerMenu(),
        _menuItem(
          title: language.home,
          color: redirect.pageIndex == UrlRoutes.$home ? $backgroundGreyColor : null,
          onClickRedirect: () {},
        ),
        _menuItem(
          title: "Các khóa học liên quan",
          color: null,
          onClickRedirect: () async {
            await LaunchApp.openApp(
              androidPackageName: 'com.uschool.mobile',
              iosUrlScheme: 'com.uschool.mobile',
              appStoreLink: 'uschoolapp.page.link',
              openStore: true
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: _body(),
      ),
    );
  }
}
