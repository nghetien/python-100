import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/constants.dart';


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

class _TabContainerState extends State<TabContainer> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size(65, 65),
        child: Container(
          height: 65,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: $hoverColor, width: 1.5)),
            color: $backgroundGreyColor
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: $primaryColor,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(color: $primaryColor, width: 1.5),
              insets: EdgeInsets.only(bottom: 64),
            ),
            labelColor: $primaryColor,
            labelStyle: Theme.of(context).textTheme.headline6,
            labelPadding: const EdgeInsets.symmetric(horizontal: 18),
            unselectedLabelColor: $neutrals400,
            tabs: [
              Tab(
                text: AppLocalizations.of(context)!.course_information,
                icon: const Icon(Icons.wysiwyg_outlined),
                iconMargin: const EdgeInsets.all(0),
              ),
              Tab(
                text: AppLocalizations.of(context)!.description,
                icon: const Icon(Icons.description),
                iconMargin: const EdgeInsets.all(0),
              ),
              Tab(
                text: AppLocalizations.of(context)!.curriculum,
                icon: const Icon(Icons.format_list_numbered_outlined),
                iconMargin: const EdgeInsets.all(0),
              ),
              Tab(
                text: AppLocalizations.of(context)!.comment,
                icon: const Icon(Icons.comment),
                iconMargin: const EdgeInsets.all(0),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          widget.info,
          widget.description,
          widget.curriculum,
          widget.comment,
        ],
      ),
    );
  }
}
