import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../widgets/widgets.dart';

class DynamicAppBar extends StatefulWidget {
  final ScrollController scrollController;
  final String namePage;
  final Widget child;
  final bool haveSearch;
  final Function(String) onSearch;
  final bool haveFilter;
  final Function? nextPageFilters;

  const DynamicAppBar({
    Key? key,
    required this.scrollController,
    required this.namePage,
    required this.child,
    required this.haveSearch,
    required this.onSearch,
    required this.haveFilter,
    this.nextPageFilters,
  }) : super(key: key);

  @override
  _DynamicAppBarState createState() => _DynamicAppBarState();
}

class _DynamicAppBarState extends State<DynamicAppBar> {
  _customTextButton({
    required String name,
    required IconData icon,
    required Function function,
    double? fontSizeIcon,
  }) {
    return TextButton(
      style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
      onPressed: () async {
        function();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            name,
            style: AppThemeLight.caption3,
          ),
          const SizedBox(
            width: 5,
          ),
          Icon(
            icon,
            color: $primaryColor,
            size: fontSizeIcon,
          ),
        ],
      ),
    );
  }

  _getNamePage() {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        widget.namePage,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  List<Widget> _getFixedBar() {
    List<Widget> rowItem = [];
    if (widget.haveSearch) {
      rowItem.add(
        Expanded(
          child: InputOutLine(
            textEditingController: TextEditingController(),
            hintTextInput: AppLocalizations.of(context)!.search,
            actionInput: TextInputAction.search,
            paddingInput: const EdgeInsets.symmetric(vertical: 16),
            colorBorderFocusInput: $primaryColor,
            colorBorderInput: $backgroundGreyColor,
            prefixIconInput: const Icon(Icons.search, color: $primaryColor,),
            backgroundColor: Theme.of(context).backgroundColor,
            listBoxShadow: const [
              BoxShadow(
                color: $shadow8,
                spreadRadius: -16,
                blurRadius: 50,
                offset: Offset(0, 24),
              ),
            ],
            onSubmit: (textSearch){
              widget.onSearch(textSearch);
            },
          ),
        ),
      );
    }
    if (widget.haveFilter) {
      rowItem.add(const SizedBox(width: 10));
      rowItem.add(_customTextButton(
        name: AppLocalizations.of(context)!.filters,
        icon: Icons.sort,
        function: widget.nextPageFilters ?? () {},
      ));
    }
    List<Widget> columnItem = [];
    if (rowItem.isNotEmpty) {
      columnItem.add(
        Container(
          margin: const EdgeInsets.only(left: 18, right: 18, top: 8),
          child: Row(
            children: rowItem,
          ),
        ),
      );
    }
    if (columnItem.isNotEmpty) {
      return columnItem;
    }
    return <Widget>[];
  }

  _appBarContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: widget.scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        List<Widget> listAppBar = <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getNamePage(),
                  ],
                ),
              );
            }, childCount: 1),
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: ContestTabHeader(
              _appBarContainer(
                Column(
                  children: _getFixedBar(),
                ),
              ),
              widget.haveFilter || widget.haveSearch ? 63 : 0,
            ),
          ),
        ];
        return listAppBar;
      },
      body: widget.child,
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  final Widget searchUI;
  final double? height;

  ContestTabHeader(
    this.searchUI,
    this.height,
  );

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => height ?? 65;

  @override
  double get minExtent => height ?? 65;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
