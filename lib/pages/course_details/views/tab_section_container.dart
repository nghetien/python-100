import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';

class BottomAppBarItem {
  final String title;
  final IconData icon;

  const BottomAppBarItem({
    required this.title,
    required this.icon,
  });
}

class TabContainer extends StatefulWidget {
  final Widget info;
  final Widget description;
  final Widget curriculum;
  final Widget comment;

  const TabContainer({
    Key? key,
    required this.info,
    required this.description,
    required this.curriculum,
    required this.comment,
  }) : super(key: key);

  @override
  _TabContainerState createState() => _TabContainerState();
}

class _TabContainerState extends State<TabContainer> {
  int _currentIndex = 0;
  late final List<Widget> _screens;
  late final List<BottomAppBarItem> _listBottomBarItem;

  _setListBottomBar() {
    _listBottomBarItem = [
      BottomAppBarItem(
        // title: AppLocalizations.of(context)!.course_information,
        title: "Thông tin",
        icon: CustomIcons.book_open,
      ),
      BottomAppBarItem(
        // title: AppLocalizations.of(context)!.description,
        title: "Mô tả",
        icon: CustomIcons.list_alt,
      ),
      BottomAppBarItem(
        // title: AppLocalizations.of(context)!.curriculum,
        title: "Mục lục",
        icon: CustomIcons.server,
      ),
      BottomAppBarItem(
        // title: AppLocalizations.of(context)!.comment,
        title: "Bình luận",
        icon: CustomIcons.comment_alt,
      ),
    ];
  }

  @override
  void initState() {
    _screens = [
      widget.info,
      widget.description,
      widget.curriculum,
      widget.comment,
    ];
    _setListBottomBar();
    super.initState();
  }

  Widget _bottomBarItem({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final status = index == _currentIndex;
    return Expanded(
      child: TweenAnimationBuilder<double>(
        tween: Tween(
          begin: 0,
          end: status ? 1 : 0,
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        builder: (BuildContext context, double value, Widget? child) {
          return InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: status ? $primaryColor : $neutrals350,
                ),
                Align(
                  heightFactor: value,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
                      fontFamily: Theme.of(context).textTheme.headline3!.fontFamily,
                      color: status ? $primaryColor : Colors.transparent,
                    ),
                  ),
                )
              ],
            ),
            onTap: () {
              setState(() {
                _currentIndex = index;
              });
            },
          );
        },
      ),
    );
  }

  Widget bottomBar() {
    List<Widget> listItem = [];
    for (int index = 0; index < _listBottomBarItem.length; index++) {
      listItem.add(_bottomBarItem(
        index: index,
        title: _listBottomBarItem[index].title,
        icon: _listBottomBarItem[index].icon,
      ));
    }
    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(width: 0.6, color: $hoverColor)),
        color: Theme.of(context).backgroundColor,
      ),
      height: 55,
      child: Row(
        children: listItem,
      ),
    );
  }

  Widget _showScreen() {
    return IndexedStack(
      children: _screens,
      index: _currentIndex,
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Expanded(
          child: _showScreen(),
        ),
        bottomBar(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: _body(),
    );
  }
}
