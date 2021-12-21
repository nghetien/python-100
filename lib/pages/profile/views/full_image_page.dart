import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../constants/constants.dart';

class NetworkFullImagePage extends StatelessWidget {
  final String? urlAvatar;

  const NetworkFullImagePage({
    Key? key,
    this.urlAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData(colorScheme: const ColorScheme.dark()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                alignment: Alignment.center,
                width: size.width,
                height: size.height,
                child: urlAvatar != null && urlAvatar!.isNotEmpty
                    ? PhotoView(
                        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                        customSize: Size(size.width, size.height),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered,
                        initialScale: PhotoViewComputedScale.contained,
                        basePosition: Alignment.center,
                        imageProvider: CachedNetworkImageProvider(urlAvatar ?? $networkImageDefaultUser),
                        errorBuilder: (context, object, stackTrace) {
                          return PhotoView(
                            backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                            customSize: Size(size.width, size.height),
                            minScale: PhotoViewComputedScale.contained,
                            maxScale: PhotoViewComputedScale.covered,
                            initialScale: PhotoViewComputedScale.contained,
                            basePosition: Alignment.center,
                            imageProvider: const AssetImage($assetsImageDefaultUser),
                          );
                        },
                      )
                    : PhotoView(
                        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                        customSize: Size(size.width, size.height),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered,
                        initialScale: PhotoViewComputedScale.contained,
                        basePosition: Alignment.center,
                        imageProvider: const AssetImage($assetsImageDefaultUser),
                        errorBuilder: (context, object, stackTrace) {
                          return PhotoView(
                            backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                            customSize: Size(size.width, size.height),
                            minScale: PhotoViewComputedScale.contained,
                            maxScale: PhotoViewComputedScale.covered,
                            initialScale: PhotoViewComputedScale.contained,
                            basePosition: Alignment.center,
                            imageProvider: const AssetImage($assetsImageDefaultUser),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileFullImagePage extends StatelessWidget {
  final File fileImage;

  const FileFullImagePage({
    Key? key,
    required this.fileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData(
        colorScheme: const ColorScheme.dark(),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            alignment: Alignment.center,
            width: size.width,
            height: size.height,
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(color: Colors.transparent),
              customSize: Size(size.width, size.height),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered,
              initialScale: PhotoViewComputedScale.contained,
              basePosition: Alignment.center,
              imageProvider: FileImage(fileImage),
              errorBuilder: (context, object, stackTrace) {
                return PhotoView(
                  backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                  customSize: Size(size.width, size.height),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered,
                  initialScale: PhotoViewComputedScale.contained,
                  basePosition: Alignment.center,
                  imageProvider: const AssetImage($assetsImageDefaultUser),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
