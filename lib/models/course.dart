class Course {
  final int id;
  final String name;
  final int? idTeacher;
  final String? teacherName;
  final String? teacherAvatar;
  final String shortDescription;
  final String? language;
  final String? coverImage;
  final String? thumbnail;
  final double price;
  final double originPrice;
  final int? discountPercent;
  final List<dynamic>? tags;
  final String status;
  final String visibility;
  final String? approvalStatus;
  final bool? isEnrolled;
  final String slug;
  final bool isFree;
  final String descFormat;
  final String badge;
  final double? progress;
  final bool? isPaid;
  final String? subject;
  final int? suggestedDuration;
  final int? videoDuration;
  final int? numVideos;
  final int? numLectures;
  final int? numQuizzes;
  final double? passPercentage;
  final String? certificateTemplate;
  final int? numStudentsEnrolled;
  final int? numStudentsPassed;
  final int? totalUCoin;
  final int? publishTime;
  final int? publishedAt;
  final String? userStatus;
  final String? paymentGuide;
  final int? privateUCoinFactor;
  final List<dynamic>? categories;

  const Course({
    required this.id,
    required this.name,
    this.idTeacher,
    this.teacherName,
    this.teacherAvatar,
    required this.shortDescription,
    this.language,
    this.coverImage,
    this.thumbnail,
    required this.price,
    required this.originPrice,
    this.discountPercent,
    required this.tags,
    required this.status,
    required this.visibility,
    this.approvalStatus,
    this.isEnrolled,
    required this.slug,
    required this.isFree,
    required this.descFormat,
    required this.badge,
    this.progress,
    this.isPaid,
    this.subject,
    this.suggestedDuration,
    this.videoDuration,
    this.numVideos,
    this.numLectures,
    this.numQuizzes,
    this.passPercentage,
    this.certificateTemplate,
    this.numStudentsEnrolled,
    this.numStudentsPassed,
    this.totalUCoin,
    this.publishTime,
    this.publishedAt,
    this.userStatus,
    this.paymentGuide,
    this.privateUCoinFactor,
    this.categories,
  });

  bool get isEmpty{
    if(id == 0){
      return true;
    }
    return false;
  }

  static Course emptyCourse(){
    return const Course(
      id: 0,
      name: "",
      shortDescription: "",
      price: 0,
      originPrice: 0,
      status: "",
      visibility: "",
      slug: "",
      isFree: false,
      isPaid: true,
      descFormat: "",
      badge: "",
      tags: [],
    );
  }

  static List<Course> readDataResponse(List<dynamic> dataAPI) {
     List<Course> listItem = dataAPI.map((item){
      return Course(
        id: item["id"],
        name: item["name"],
        idTeacher: item["teacher_id"],
        teacherName: item["teacher_name"],
        teacherAvatar: item["teacher_avatar"],
        shortDescription: item["short_description"],
        language: item["language"],
        coverImage: item["cover_image"],
        thumbnail: item["thumbnail"],
        price: item["price"],
        originPrice: item["origin_price"],
        discountPercent: item["discount_percent"],
        tags: item["tags"],
        status: item["status"],
        visibility: item["visibility"],
        approvalStatus: item["approval_status"],
        isEnrolled: item["is_enrolled"],
        slug: item["slug"],
        isFree: item["is_free"],
        descFormat: item["desc_format"],
        badge: item["badge"],
        progress: item["progress"],
        isPaid: item["is_paid"],
        subject: item["subject"],
      );
    }).toList();
    return listItem;
  }

  static Course createACourseFromJson(Map<String, dynamic> data){
    return Course(
      id: data["id"],
      name: data["name"],
      idTeacher: data["teacher_id"],
      teacherName: data["teacher_name"],
      teacherAvatar: data["teacher_avatar"],
      shortDescription: data["short_description"],
      language: data["language"],
      coverImage: data["cover_image"],
      thumbnail: data["thumbnail"],
      price: data["price"],
      originPrice: data["origin_price"],
      discountPercent: data["discount_percent"],
      tags: data["tags"],
      status: data["status"],
      visibility: data["visibility"],
      approvalStatus: data["approval_status"],
      isEnrolled: data["is_enrolled"],
      slug: data["slug"],
      isFree: data["is_free"],
      descFormat: data["desc_format"],
      badge: data["badge"],
      progress: data["progress"],
      isPaid: data["is_paid"],
      subject: data["subject"],
      suggestedDuration: data["suggested_duration"],
      videoDuration: data["video_duration"],
      numVideos: data["num_videos"],
      numLectures: data["num_lectures"],
      numQuizzes: data["num_quizzes"],
      passPercentage: data["pass_percentage"],
      certificateTemplate: data["certificate_template"],
      numStudentsEnrolled: data["num_students_enrolled"],
      numStudentsPassed: data["num_students_passed"],
      totalUCoin: data["total_ucoin"],
      publishTime: data["publish_time"],
      publishedAt: data["published_at"],
      userStatus: data["user_status"],
      paymentGuide: data["payment_guide"],
      privateUCoinFactor: data["private_ucoin_factor"],
      categories: data["categories"],
    );
  }
}
