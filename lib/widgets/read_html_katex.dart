import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as mark_down;
import 'package:flutter_tex/flutter_tex.dart';
import 'dart:convert';
import 'package:delta_markdown/delta_markdown.dart';
import 'package:flutter_quill/models/quill_delta.dart';

String quillDeltaToHtml(Delta delta) {
  final String convertedValue = jsonEncode(delta.toJson());
  final String markdown = deltaToMarkdown(convertedValue);
  final String html = mark_down.markdownToHtml(markdown);

  return html;
}

String markDownToDelta(String markdown){
  return markdownToDelta(markdown);
}

renderHtml({required String htmlString, required BuildContext context}) {
  return Html(
    data: htmlString,
    shrinkWrap: true,
    style: {
      '*': Style(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).textTheme.headline6!.color,
        fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: const FontSize(18),
      ),
    },
  );
}

answerKatexToHtml({required String katex, required VoidCallback onSelect}) {
  String myKatex = katex.replaceAll(r"{", r"\{");
  myKatex = myKatex.replaceAll(r"}", r"\}");
  return TeXView(
    renderingEngine: const TeXViewRenderingEngine.mathjax(),
    child: TeXViewInkWell(
      onTap: (value) {
        onSelect();
      },
      rippleEffect: false,
      child: TeXViewDocument(
        mark_down.markdownToHtml(myKatex),
        style: TeXViewStyle(
          fontStyle: TeXViewFontStyle(
            fontSize: 20,
            fontWeight: TeXViewFontWeight.w400,
            fontFamily: "Lexend",
          ),
          // backgroundColor: value ? $green100 : $backgroundGreyColor,
        ),
      ),
      id: '',
    ),
  );
}

showMathJaxHtml(String katex, {TeXViewFontWeight? weight, int? fontSize, String? fontFamily}) {
  String inWeight = "300";
  if(weight != null){
    inWeight = weight.toString().split(".")[1].substring(1, 4);
  }
  String myKatex = katex.replaceAll(r"{ ", r"\{ ");
  myKatex = myKatex.replaceAll(r"} ", r"\} ");
  return TeXView(
    renderingEngine: const TeXViewRenderingEngine.mathjax(),
    child: TeXViewDocument(
      mark_down.markdownToHtml(katex),
      style: TeXViewStyle.fromCSS(
          "font-size: ${fontSize}px; font-family: $fontFamily;font-weight: $inWeight; line-height: 1.5;word-spacing: 2; color: #1d253b;"
      ),
    ),
  );
}