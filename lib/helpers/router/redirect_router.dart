import 'package:flutter/material.dart';
import '../../pages/pages.dart';

import '../helpers.dart';

class UrlRoutes {
  static const $splash = '/';

  /// -------------------------------------------------------
  static const $settings = 'SETTINGS';
  static const $profile = '/personal-information';
  static const $editProfile = "EDIT_PROFILE";
  static const $fullImage = 'FULL_IMAGE';
  static const $fullImageFile = 'FULL_IMAGE_FILE';
  static const $upsertPassword = "UPSERT_PASSWORD";

  /// -------------------------------------------------------
  static const $login = '/sign-in';
  static const $register = '/sign-up';

  /// -------------------------------------------------------
  static const $onlineIDE = 'ONLINE_IDE';
  static const $createSnippet = "CREATE_SNIPPET";
  static const $onlineIdSnippet = "ONLINE_ID_SNIPPET";

  /// -------------------------------------------------------
  static const $leaderboard = "LEADER_BOARD";

  /// -------------------------------------------------------
  static const $home = 'HOME';

  /// -------------------------------------------------------
  static const $filters = "FILTERS";

  /// -------------------------------------------------------
  static const $course = '/course';
  static const $courseDetails = "COURSE_DETAILS";
  static const $lessonDetails = "LESSON_DETAILS";
  static const $payment = "PAYMENT";
  static const $coursesEnrolled = "COURSES_ENROLLED";

  /// -------------------------------------------------------
  static const $blog = '/blog';

  /// -------------------------------------------------------
  static const $problems = 'PROBLEMS';

  /// -------------------------------------------------------
  static const $contests = 'CONTESTS';
  static const $bufferJoinContest = 'BUFFER_JOIN_CONTEST';

  /// -------------------------------------------------------
  static const $transactionHistory = 'TRANSACTION_HISTORY';

  /// -------------------------------------------------------
  static const $loadWebView = 'LOAD_WEB_VIEW';

  /// -------------------------------------------------------
  static const $returnUrlWebView = 'RETURN_URL_WEB_VIEW';

  /// -------------------------------------------------------
  static const $affiliate = "AFFILIATE";
  static const $affiliateDetail = "AFFILIATE_DETAIL";

  /// -------------------------------------------------------
  static const $codeEditor = "CODE_EDITOR";
  static const $replyComment = "REPLY_COMMENT";
  static const $feedback = "FEED_BACK";
  static const $submissionDetail = "SUBMISSION_DETAIL";

  /// -------------------------------------------------------
  static const $codeSnippet = "CODE_SNIPPET";
  static const $createNewCodeSnippet = "CREATE_NEW_CODE_SNIPPET";
  static const $sourceCodeSnippet = "SOURCE_CODE_SNIPPET";
}

class Routes {
  static dynamic route() {
    return {
      UrlRoutes.$splash: (BuildContext context) => const SplashPage(),
    };
  }

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case UrlRoutes.$register:
        final args = settings.arguments as RegisterPage;
        return SlideBottomRoute(
          builder: (BuildContext context) => RegisterPage(
            affiliateCode: args.affiliateCode,
          ),
          settings: settings,
        );
      case UrlRoutes.$profile:
        return SlideLeftRoute(
          builder: (BuildContext context) => const ProfilePage(),
          settings: settings,
        );
      case UrlRoutes.$fullImage:
        final args = settings.arguments as NetworkFullImagePage;
        return SlideBottomRoute(
          builder: (BuildContext context) => NetworkFullImagePage(
            urlAvatar: args.urlAvatar,
          ),
          settings: settings,
        );
      case UrlRoutes.$fullImageFile:
        final args = settings.arguments as FileFullImagePage;
        return SlideBottomRoute(
          builder: (BuildContext context) => FileFullImagePage(
            fileImage: args.fileImage,
          ),
          settings: settings,
        );
      case UrlRoutes.$courseDetails:
        final args = settings.arguments as CourseDetailsPage;
        return SlideLeftRoute(
          builder: (BuildContext context) => CourseDetailsPage(
            currentCourse: args.currentCourse,
          ),
          settings: settings,
        );
      case UrlRoutes.$loadWebView:
        final args = settings.arguments as LoadWebView;
        return SlideLeftRoute(
          builder: (BuildContext context) => LoadWebView(
            url: args.url,
          ),
          settings: settings,
        );
      case UrlRoutes.$editProfile:
        return SlideLeftRoute(
          builder: (BuildContext context) => const EditProfilePage(),
          settings: settings,
        );
      case UrlRoutes.$upsertPassword:
        return SlideLeftRoute(
          builder: (BuildContext context) => const UpsertPasswordPage(),
          settings: settings,
        );
      case UrlRoutes.$lessonDetails:
        final args = settings.arguments as LessonDetailsPage;
        return SlideBottomRoute(
          builder: (BuildContext context) => LessonDetailsPage(
            listCourseItem: args.listCourseItem,
            currentCourse: args.currentCourse,
            idLessonStart: args.idLessonStart,
          ),
          settings: settings,
        );
      case UrlRoutes.$payment:
        final args = settings.arguments as PaymentPage;
        return SlideBottomRoute(
          builder: (BuildContext context) => PaymentPage(
            currentCourse: args.currentCourse,
          ),
          settings: settings,
        );
      case UrlRoutes.$returnUrlWebView:
        final args = settings.arguments as ReturnUrlPage;
        return SlideBottomRoute(
          builder: (BuildContext context) => ReturnUrlPage(
            urlWebView: args.urlWebView,
          ),
          settings: settings,
        );
      case UrlRoutes.$affiliate:
        return SlideLeftRoute(
          builder: (BuildContext context) => const AffiliatePage(),
          settings: settings,
        );
      case UrlRoutes.$affiliateDetail:
        return SlideLeftRoute(
          builder: (BuildContext context) => const AffiliateDetailPage(),
          settings: settings,
        );
      case UrlRoutes.$codeEditor:
        final args = settings.arguments as CodeEditorPage;
        return SlideBottomRoute(
          builder: (context) => CodeEditorPage(
            statementQuestion: args.statementQuestion,
            quizId: args.quizId,
            questionData: args.questionData,
            courseID: args.courseID,
          ),
          settings: settings,
        );
      case UrlRoutes.$feedback:
        final args = settings.arguments as FeedbackCodeEditor;
        return SlideBottomRoute(
          builder: (context) => FeedbackCodeEditor(
            haveAppBar: args.haveAppBar,
            courseId: args.courseId,
            lessonId: args.lessonId,
            questionId: args.questionId,
            tag: args.tag,
          ),
          settings: settings,
        );
      case UrlRoutes.$replyComment:
        final args = settings.arguments as ReplyCommentPage;
        return SlideLeftRoute(
          builder: (context) => ReplyCommentPage(
            currentComment: args.currentComment,
            tag: args.tag,
          ),
          settings: settings,
        );
      case UrlRoutes.$submissionDetail:
        final args = settings.arguments as SubmissionDetailPage;
        return SlideBottomRoute(
          builder: (context) => SubmissionDetailPage(
            languageId: args.languageId,
            languageName: args.languageName,
            themeMode: args.themeMode,
            questionData: args.questionData,
            quizId: args.quizId,
            sourceCode: args.sourceCode,
            listLanguage: args.listLanguage,
            listTestCase: args.listTestCase,
            mapIdWithNameLanguage: args.mapIdWithNameLanguage,
          ),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
