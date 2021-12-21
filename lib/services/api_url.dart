/// api url
const $signInAPIUrl = "/api/users/sign-in";
const $signUpAPIUrl = "/api/users/sign-up";
const $getInfoUserAPIUrl = "/api/users/info";
const $uploadImageAPIUrl = "/api/general/upload-image";
const $updateProfileAPIUrl = "/api/users/info";
const $upsertPasswordAPIUrl = "/api/users/upsert-password";
const $problemsAPIUrl = "/api/question";
const $tagsAPIUrl = "/api/general/tags";
const $snippetAPIUrl = "/api/snippet/";
const $snippetJudgeLanguageAPIUrl = "/api/snippet/judge-language";
const $coursesAPIUrl = "/api/courses";
const $coursesEnrolledAPIUrl = "/api/courses/enrolled";
const $blogsAPIUrl = "/api/blog-posts";
const $contestAPIUrl = "/api/contests";
const $myContestAPIUrl = "/api/contests/me";
const $lessonItemAPIUrl = "/api/lesson-item/";
String $lessonItemQuizAPIUrl(String idLessonQuiz){
  return "/api/lesson-item/$idLessonQuiz/question";
}
String $courseItemAPIUrl(String idCourse){
  return "/api/curriculum/$idCourse/course-items";
}
String $enrollCourseAPIUrl(String idCourse){
  return "/api/learning/course/$idCourse/enrolled";
}
String $enrollContestAPIUrl(String idLesson){
  return "/api/learning/lesson/$idLesson/submit-quiz";
}
const $leaderboardAPIUrl = "/api/general/personal-leader-board";
String $finishLessonItemContestAPIUrl(String idLesson){
  return "/api/learning/lesson/$idLesson/finish";
}
const $dataHomeAPIUrl = "/api/home";
const $transactionCourseAPIUrl = "/api/transaction/course";
const $transactionCourseDetailAPIUrl = "/api/transaction/course/detail/";
const $transactionUCoinAPIUrl = "/api/transaction/ucoin";
const $courseIdAPIUrl = "api/courses";
const $transactionAPIUrl = "/api/transaction/course";
const $categoryAPIUrl = "/api/category";
String $submitQuizAPIUrl(String lessonId){
  return "/api/learning/lesson/$lessonId/submit-quiz";
}
const $submitQuizWithAnswerAPIUrl = "/api/learning/submit-question";
String $resultQuizAPIUrl(String submissionId){
  return "/api/learning/quiz-submission/$submissionId/result";
}
const $myAffiliateAPIUrl = "/api/affiliate-code";
const $affiliateDetailAccountAPIUrl = "/api/affiliate-code/my-affiliate-users";
const $checkStatusTransactionAPIUrl = "/api/check/payment";
const $snippetJudgeSubmission = "/api/snippet/judge-submission";
String $runTestAPIUrl(String questionId){
  return "/api/learning/code-question/judge/$questionId/submit-coding-question";
}
String $runTestResultAPIUrl(String submissionId){
  return "/api/learning/code-question/judge-result/$submissionId/submission_result";
}
String $historySubmissionAPIUrl(String questionId){
  return "/api/question/$questionId/submissions";
}
const $infoSubmissionAPIURL = "/api/question/submissions/";
const $feedbackSubmissionAPIURL = "/api/user-data/comment";
String $replyFeedbackAPIURL(String parentId){
  return "/api/user-data/comment/$parentId/replies";
}