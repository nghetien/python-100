import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/image_url.dart';

class InfoTeacher extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double? width;
  final double? height;
  final double? radius;

  const InfoTeacher({
    Key? key,
    this.imageUrl,
    this.name,
    this.width,
    this.height,
    this.radius,
  }) : super(key: key);

  Widget _avatar(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _avatar(context),
        const SizedBox(
          width: 12,
        ),
        Text(
          name ?? "uSchool Team",
          style: Theme.of(context).textTheme.headline6,
        )
      ],
    );
  }
}
