import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../states/states.dart';
import '../../../helpers/helpers.dart';
import '../pages.dart';

Widget splashLoadingPage(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  var height = 150.0;
  return Container(
    height: size.height,
    width: size.width,
    color: Theme.of(context).backgroundColor,
    child: Container(
      height: height,
      width: height,
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
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
    ),
  );
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    timer();
    super.initState();
  }

  void timer() async {
    String? getTheme = await SharedPreferenceHelper().getThemeDefault();
    if (getTheme != null) {
      context.read<ThemeProvider>().setDefaultTheme(getTheme);
    }
    String? languageCode = await SharedPreferenceHelper().getLocaleDefault();
    if (languageCode != null) {
      context.read<LocaleProvider>().setDefaultLanguage(languageCode);
    }
    String? accessToken = await SharedPreferenceHelper().getUserAccessToken();
    final state = context.read<AuthState>();
    await state.updateAuthState(accessToken);
  }

  _renderPage() {
    var state = context.watch<AuthState>();
    switch (state.authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _body(context);
      case AuthStatus.NOT_LOGGED_IN:
        return const LoginPage();
      case AuthStatus.LOGGED_IN:
        return const HomePage();
    }
  }

  Widget _body(BuildContext context) {
    return splashLoadingPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return _renderPage();
  }
}
