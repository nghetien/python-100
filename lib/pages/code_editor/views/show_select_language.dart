import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/constants.dart';
import '../../../../widgets/widgets.dart';

class ShowSelectLanguage extends StatefulWidget {
  final List<Map<String, dynamic>> listLanguage;
  final String currentLanguageId;

  const ShowSelectLanguage({
    Key? key,
    required this.listLanguage,
    required this.currentLanguageId,
  }) : super(key: key);

  @override
  _ShowSelectLanguageState createState() => _ShowSelectLanguageState();
}

class _ShowSelectLanguageState extends State<ShowSelectLanguage> {
  late List<Map<String, dynamic>> listSearchLanguage;

  void searchLanguage(String value) {
    try {
      if (value == "") {
        setState(() {
          listSearchLanguage = widget.listLanguage;
        });
      } else {
        List<Map<String, dynamic>> listItem = [];
        for (var item in widget.listLanguage) {
          if (item["name"].toLowerCase().contains((RegExp(value.toLowerCase(), caseSensitive: false)))) {
            listItem.add(item);
          }
        }
        listSearchLanguage = listItem;
      }
    } catch (e) {
      listSearchLanguage = [];
    }
  }

  @override
  void initState() {
    listSearchLanguage = widget.listLanguage;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _checkBox({required bool value, required String nameLanguage, required Function(bool) clickCheckBox}) {
    if (nameLanguage.contains(RegExp(r'scratch', caseSensitive: false))) {
      return CheckboxListTile(
        activeColor: Theme.of(context).textTheme.bodyText2!.color,
        checkColor: Theme.of(context).textTheme.bodyText2!.color,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        value: true,
        onChanged: (value) {},
        title: Text(
          nameLanguage,
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
            fontWeight: Theme.of(context).textTheme.headline6!.fontWeight,
            fontSize: Theme.of(context).textTheme.headline6!.fontSize,
            letterSpacing: Theme.of(context).textTheme.headline6!.letterSpacing,
            height: Theme.of(context).textTheme.headline6!.height,
            color: Theme.of(context).textTheme.bodyText2!.color,
          ),
        ),
      );
    }
    return CheckboxListTile(
      activeColor: $primaryColor,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: value,
      onChanged: (value) {
        clickCheckBox(value ?? false);
      },
      title: Text(
        nameLanguage,
        style: TextStyle(
          fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
          fontWeight: Theme.of(context).textTheme.headline6!.fontWeight,
          fontSize: Theme.of(context).textTheme.headline6!.fontSize,
          letterSpacing: Theme.of(context).textTheme.headline6!.letterSpacing,
          height: Theme.of(context).textTheme.headline6!.height,
          color: value ? $primaryColor : Theme.of(context).textTheme.bodyText2!.color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 16,
          ),
          Text(
            AppLocalizations.of(context)!.select_language,
            style: Theme.of(context).textTheme.headline3,
          ),
          const SizedBox(
            height: 16,
          ),
          Obx(
            () {
              if (widget.listLanguage.isEmpty) {
                return infinityLoading(context: context);
              } else {
                return Column(
                  children: <Widget>[
                    InputOutLine(
                      textEditingController: TextEditingController(),
                      hintTextInput: AppLocalizations.of(context)!.search,
                      actionInput: TextInputAction.search,
                      typeInput: TextInputType.text,
                      paddingInput: const EdgeInsets.symmetric(vertical: 16),
                      colorBorderFocusInput: $primaryColor,
                      colorBorderInput: $backgroundGreyColor,
                      prefixIconInput: const Icon(
                        Icons.search,
                        color: $primaryColor,
                      ),
                      backgroundColor: Theme.of(context).backgroundColor,
                      listBoxShadow: const [
                        BoxShadow(
                          color: $shadow8,
                          spreadRadius: -16,
                          blurRadius: 50,
                          offset: Offset(0, 24),
                        ),
                      ],
                      onSubmit: (value) {
                        searchLanguage(value);
                      },
                    ),
                    SizedBox(
                      height: 290,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: listSearchLanguage.length,
                        itemBuilder: (context, index) {
                          return _checkBox(
                            value: widget.currentLanguageId == listSearchLanguage[index]["id"].toString(),
                            nameLanguage: listSearchLanguage[index]["name"],
                            clickCheckBox: (value) {
                              if (value == true) {
                                Navigator.pop(
                                  context,
                                  listSearchLanguage[index]["id"].toString(),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
