import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class LoadNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;

  const LoadNetworkImage({
    Key? key,
    this.imageUrl,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage($assetsImageDefaultBanner),
          ),
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl ?? $networkImageDefaultBanner,
        height: height,
        width: width,
        errorWidget: (context, url, error) {
          return Image.asset($assetsImageDefaultBanner);
        },
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      );
    }
  }
}
