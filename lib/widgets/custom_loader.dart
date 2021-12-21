import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class CustomLoader {
  static final CustomLoader _customLoader = CustomLoader._createObject();

  CustomLoader._createObject();

  factory CustomLoader() {
    return _customLoader;
  }

  late OverlayState _overlayState;
  late OverlayEntry? _overlayEntry;

  buildLoader(BuildContext context, {Color? backgroundColor}) {
    backgroundColor ??= const Color(0xffa8a8a8).withOpacity(.5);
    var height = 150.0;
    return CustomScreenLoader(
      height: height,
      width: height,
      backgroundColor: backgroundColor,
    );
  }

  _buildLoader() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: buildLoader(context));
      },
    );
  }

  showLoader(context) {
    _overlayState = Overlay.of(context)!;
    _buildLoader();
    _overlayState.insert(_overlayEntry!);
  }

  hideLoader() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      print("Exception:: $e");
    }
  }
}

class CustomScreenLoader extends StatelessWidget {
  final Color backgroundColor;
  final double height;
  final double width;

  const CustomScreenLoader(
      {Key? key,
        this.backgroundColor = const Color(0xfff8f8f8),
        this.height = 30,
        this.width = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: $loaderColor,
      child: Container(
        color: Colors.transparent,
        height: height,
        width: height,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            const SizedBox(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>($primaryColor),
                strokeWidth: 2,
              ),
              height: 65.0,
              width: 65.0,
            ),
            Image.asset(
              $assetsImageLogo,
              height: 50,
              width: 50,
            )
          ],
        ),
      ),
    );
  }
}
