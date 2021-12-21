import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';

class BannerImg extends StatelessWidget {
  final String? imageBanner;
  final double? height;
  final double? width;
  final double? radius;
  final BoxFit? fit;

  const BannerImg({
    Key? key,
    required this.imageBanner,
    this.height,
    this.width,
    this.radius,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageBanner == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 5),
        child: Image.asset(
          $assetsImageDefaultBanner,
          height: height ?? 81,
          width: width ?? 144,
          fit: fit ?? BoxFit.fitWidth,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 5),
        child: CachedNetworkImage(
          imageUrl: imageBanner ?? $networkImageDefaultBanner,
          height: height ?? 81,
          width: width ?? 144,
          fit: BoxFit.fitWidth,
          errorWidget: (context, url, error) {
            return Image.asset($assetsImageDefaultBanner);
          },
        ),
      );
    }
  }
}