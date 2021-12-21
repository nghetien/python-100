import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../pages/pages.dart';

class RegisterPage extends StatefulWidget {
  final String? affiliateCode;

  const RegisterPage({
    Key? key,
    this.affiliateCode,
  }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  _body() {
    return InkWell(
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.register,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            RegisterForm(
              affiliateCode: widget.affiliateCode,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: _body(),
      ),
    );
  }
}
