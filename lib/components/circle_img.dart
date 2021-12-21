import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/image_url.dart';

class CircleImg extends StatelessWidget {
  final String? urlImg;
  final double? widthImg;
  final double? heightImg;
  final double? radiusImg;
  final Color? backgroundColor;
  final Function? onClickImg;

  const CircleImg({
    Key? key,
    this.urlImg,
    this.widthImg,
    this.heightImg,
    this.radiusImg,
    this.backgroundColor,
    this.onClickImg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget item;
    if (urlImg != null && urlImg!.isNotEmpty) {
      item = CircleAvatar(
        backgroundColor: backgroundColor ?? $primaryColor,
        radius: radiusImg ?? 18,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: urlImg ?? $networkImageDefaultUser,
            fit: BoxFit.cover,
            width: widthImg ?? 32,
            height: heightImg ?? 32,
            errorWidget: (context, url, error) {
              return Image.asset($assetsImageDefaultUser);
            },
          ),
        ),
      );
    } else {
      item = CircleAvatar(
        backgroundColor: backgroundColor ?? $primaryColor,
        radius: radiusImg ?? 18,
        child: ClipOval(
          child: Image.asset(
            $assetsImageDefaultUser,
            width: widthImg ?? 32,
            height: heightImg ?? 32,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return InkWell(
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        if (onClickImg != null) {
          onClickImg!();
        }
      },
      child: item,
    );
  }
}

class AvatarCircleImage extends StatelessWidget {
  final String typeImage;
  final String? urlImg;
  final File? fileImage;
  final double? widthImg;
  final double? heightImg;
  final double? radiusImg;
  final Color? backgroundColor;
  final Function? onClickImg;

  const AvatarCircleImage({
    Key? key,
    required this.typeImage,
    this.urlImg,
    this.fileImage,
    this.widthImg,
    this.heightImg,
    this.radiusImg,
    this.backgroundColor,
    this.onClickImg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget item;
    if (typeImage == $file) {
      item = CircleAvatar(
        backgroundColor: backgroundColor ?? $primaryColor,
        radius: radiusImg ?? 18,
        backgroundImage: FileImage(fileImage!),
      );
    } else if(typeImage == $network && urlImg != null && urlImg!.isNotEmpty) {
      item = CircleAvatar(
        backgroundColor: backgroundColor ?? $primaryColor,
        radius: radiusImg ?? 18,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: urlImg ?? $networkImageDefaultUser,
            fit: BoxFit.cover,
            width: widthImg ?? 32,
            height: heightImg ?? 32,
            errorWidget: (context, url, error) {
              return Image.asset($assetsImageDefaultUser);
            },
          ),
        ),
      );
    } else {
      item = CircleAvatar(
        backgroundColor: backgroundColor ?? $primaryColor,
        radius: radiusImg ?? 18,
        child: ClipOval(
          child: Image.asset(
            $assetsImageDefaultUser,
            width: widthImg ?? 32,
            height: heightImg ?? 32,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return InkWell(
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        if (onClickImg != null) {
          onClickImg!();
        }
      },
      child: item,
    );
  }
}

class CircleAvatarWithOutClick extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double? radius;

  const CircleAvatarWithOutClick({
    Key? key,
    this.imageUrl,
    this.width,
    this.height,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).backgroundColor,
        radius: radius ?? 18,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            width: width ?? 32,
            height: height ?? 32,
            errorWidget: (context, url, error) {
              return Image.asset($assetsImageDefaultUser);
            },
          ),
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Theme.of(context).backgroundColor,
        radius: radius ?? 18,
        child: ClipOval(
          child: Image.asset(
            $assetsImageDefaultUser,
            height: height ?? 32,
            width: width ?? 32,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
