import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

CodeController customCodeEditor({
  required String? sourceCode,
  Function(String)? onChangeEditor,
  dynamic languageMode,
  Map<String, TextStyle>? theme,
}) {
  return CodeController(
    text: sourceCode,
    onChange: onChangeEditor,
    language: languageMode,
    theme: theme,
    patternMap: {
      r'".*"': const TextStyle(color: Colors.yellow),
      r'[a-zA-Z0-9]+\(.*\)': const TextStyle(color: Colors.green),
    },
    stringMap: {
      // "void": const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      // "print": const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
    },
  );
}
