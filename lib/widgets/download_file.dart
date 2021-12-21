import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/constants.dart';
import 'widgets.dart';

class DownloadFile extends StatefulWidget {
  final String urlFile;

  const DownloadFile({
    Key? key,
    required this.urlFile,
  }) : super(key: key);

  @override
  _DownloadFileState createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {

  Future<File?> _download(String url) async {
    final String fileName = url.split('/').last;
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File("${appStorage.path}/$fileName");
    try{
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    }catch (e) {
      return null;
    }
  }

  Future<void> _openFile(String url) async {
    final file = await _download(url);
    if(file == null) return;
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonFullColorWithIcon(
      textBtn: "Download file",
      onPressCallBack: () {
        _openFile(widget.urlFile, );
      },
      iconBtn: Icons.download,
      widthBtn: double.infinity,
      colorBtn: $yellow400,
    );
  }
}
