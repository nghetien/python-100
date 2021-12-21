import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../components/components.dart';
import '../../constants/constants.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../states/states.dart';
import '../../layouts/layouts.dart';
import '../../widgets/widgets.dart';
import '../../services/services.dart';
import '../pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoadCourse = false;
  late final Course initCourse;

  _loadCourse() async {
    String getDomain = FlavorConfig.instance.variables["course_id"];
    DataResponse res = await getInfoCourseResponse(getDomain);
    if (res.status) {
      initCourse = Course.createACourseFromJson(res.data['data']);
      setState(() {
        isLoadCourse = true;
      });
    } else {
      showSnackBar(context, message: AppLocalizations.of(context)!.load_data_fail, backgroundColor: $errorColor);
    }
  }

  @override
  void initState() {
    _loadCourse();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _body() {
    if (isLoadCourse) {
      return CourseDetailsPage(
        currentCourse: initCourse,
      );
    } else {
      return splashLoadingPage(context);
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   final User currentUser = context.watch<AuthState>().getUserModel;
  //   return Scaffold(
  //     backgroundColor: $whiteColor,
  //     appBar: AppBar(
  //       centerTitle: false,
  //       title: GestureDetector(
  //         onTap: () {},
  //         child: const Image(
  //           image: AssetImage($assetsImageLogoUSchool),
  //           height: 40,
  //         ),
  //       ),
  //       elevation: 0,
  //       bottom: PreferredSize(
  //         child: Container(
  //           color: Theme.of(context).shadowColor,
  //           height: 1.0,
  //         ),
  //         preferredSize: const Size.fromHeight(1),
  //       ),
  //       actions: [
  //         Row(
  //           children: <Widget>[
  //             ShowUCoinWithBorder(
  //               totalUCoin: currentUser.totalUcoin,
  //             ),
  //             const SizedBox(
  //               width: 8,
  //             ),
  //             CircleImg(
  //               urlImg: currentUser.avatar,
  //               onClickImg: () {
  //                 Navigator.pushNamed(context, UrlRoutes.$profile);
  //               },
  //             ),
  //             const SizedBox(
  //               width: 18,
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //     body: _body(),
  //   );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: $whiteColor,
      endDrawerEnableOpenDragGesture: true,
      endDrawer: const Menu(),
      appBar: customAppBar(context),
      body: _body(),
    );
  }
}
