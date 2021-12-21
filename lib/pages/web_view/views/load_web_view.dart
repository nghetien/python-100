import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../layouts/layouts.dart';

class LoadWebView extends StatefulWidget {
  final String url;

  const LoadWebView({Key? key, required this.url}) : super(key: key);

  @override
  _LoadWebViewState createState() => _LoadWebViewState();
}

class _LoadWebViewState extends State<LoadWebView> {
  late WebViewController _controller;

  _body() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: widget.url,
      onWebViewCreated: (controller) async {
        _controller = controller;
      },
      onPageFinished: (url){
        _controller.evaluateJavascript(
            "document.getElementsByTagName('header')[0].style.display='none'"
        );
        _controller.evaluateJavascript(
            "document.getElementsByClassName('facebook-chat')[0].style.display='none'"
        );
        _controller.evaluateJavascript(
            "document.getElementById('responsive-layout-header').style.display='none'"
        );
        _controller.evaluateJavascript(
            "document.getElementsByClassName('u-school-footer')[0].style.display='none'"
        );
        _controller.evaluateJavascript(
            "document.getElementsByClassName('courses-content main-container')[0].style.display='none'"
        );
        _controller.evaluateJavascript(
            "document.getElementsByClassName('head-content-left')[0].style.display='none'"
        );
        _controller.evaluateJavascript(
            "document.getElementsByClassName('courses-content main-container mobile')[0].style.display='none'"
        );
        _controller.evaluateJavascript(
            "document.getElementsByClassName('header-content-left-wrap')[0].style.display='none'"
        );
        _controller.evaluateJavascript(
            "document.getElementsByClassName('header-content-left-wrap')[1].style.display='none'"
        );
        _controller.evaluateJavascript(
            "document.getElementsByClassName('join-button')[0].style.display='none'"
        );
        _controller.evaluateJavascript(
            "document.getElementsByClassName('head-content-right')[0].style.display='none'"
        );
        _controller.evaluateJavascript(
            "document.getElementsByClassName('u-courses main-container')[0].style.display='none'"
        );
        _controller.evaluateJavascript(
            "document.getElementsByClassName('u-footer')[0].style.display='none'"
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: simpleAppBar(
        context: context,
        title: "",
        actionsAppBar: [
          IconButton(
            onPressed: () {
              Share.share(widget.url);
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: _body(),
    );
  }
}
