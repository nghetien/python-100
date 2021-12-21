import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../constants/constants.dart';

class ReturnUrlPage extends StatefulWidget {
  final String urlWebView;

  const ReturnUrlPage({Key? key, required this.urlWebView}) : super(key: key);

  @override
  _ReturnUrlPageState createState() => _ReturnUrlPageState();
}

class _ReturnUrlPageState extends State<ReturnUrlPage> {
  StreamController streamController = StreamController<String>();

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, "");
          return true;
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.urlWebView,
            navigationDelegate: (action) {
              if (!action.url.contains(RegExp(r'sandbox', caseSensitive: false)) &&
                  action.url.contains(RegExp(getReference!, caseSensitive: false))) {
                Navigator.pop(context, action.url);
              }
              return NavigationDecision.navigate;
            },
          ),
        ),
      ),
    );
  }
}
