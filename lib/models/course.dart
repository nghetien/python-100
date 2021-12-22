class Course {
  final String? approvalMsg;
  final String? approvalStatus;
  final String? avgRating;
  final String badge;
  final String? badgeIcon;
  final List<dynamic>? categories;
  final String? certificateTemplate;
  final String? coverImage;
  final String descFormat;
  final String description;
  final int? discountPercent;
  final int id;
  final bool? isEnrolled;
  final bool isFree;
  final bool? isPaid;
  final String? language;
  final String name;
  final int? numLectures;
  final int? numQuizzes;
  final int? numStudentsEnrolled;
  final int? numStudentsPassed;
  final int? numVideos;
  final double originPrice;
  final double? passPercentage;
  final String? paymentGuide;
  final double price;
  final int? privateUCoinFactor;
  final double? progress;
  final int? publishTime;
  final int? publishedAt;
  final String shortDescription;
  final String? shortDescriptionFacebook;
  final String? shortDescriptionTwitter;
  final String slug;
  final String status;
  final String? subject;
  final int? suggestedDuration;
  final List<dynamic>? tags;
  final String? teacherAvatar;
  final int? teacherId;
  final String? teacherName;
  final String? thumbnail;
  final String? thumbnailFacebook;
  final String? thumbnailTwitter;
  final int? totalUCoin;
  final String? userStatus;
  final int? videoDuration;
  final String visibility;

  const Course({
    this.approvalMsg,
    this.approvalStatus,
    this.avgRating,
    required this.badge,
    this.badgeIcon,
    this.categories,
    this.certificateTemplate,
    this.coverImage,
    required this.descFormat,
    required this.description,
    this.discountPercent,
    required this.id,
    this.isEnrolled,
    required this.isFree,
    this.isPaid,
    this.language,
    required this.name,
    this.numLectures,
    this.numQuizzes,
    this.numStudentsEnrolled,
    this.numStudentsPassed,
    this.numVideos,
    required this.originPrice,
    this.passPercentage,
    this.paymentGuide,
    required this.price,
    this.privateUCoinFactor,
    this.progress,
    this.publishTime,
    this.publishedAt,
    required this.shortDescription,
    this.shortDescriptionFacebook,
    this.shortDescriptionTwitter,
    required this.slug,
    required this.status,
    this.subject,
    this.suggestedDuration,
    this.tags,
    this.teacherAvatar,
    this.teacherId,
    this.teacherName,
    this.thumbnail,
    this.thumbnailFacebook,
    this.thumbnailTwitter,
    this.totalUCoin,
    this.userStatus,
    this.videoDuration,
    required this.visibility,
  });

  bool get isEmpty {
    if (id == 0) {
      return true;
    }
    return false;
  }

  static get empty {
    return const Course(
      badge: "",
      descFormat: "",
      description: "",
      id: -1,
      isFree: false,
      name: "",
      originPrice: 0,
      price: 0,
      shortDescription: "",
      slug: "",
      status: "",
      visibility: "",
    );
  }

  static List<Course> readDataResponse(List<dynamic> dataAPI) {
    List<Course> listItem = dataAPI.map((item) {
      return Course.createACourseFromJson(item as Map<String, dynamic>);
    }).toList();
    return listItem;
  }

  static Course createACourseFromJson(Map<String, dynamic> data) {
    return Course(
      approvalMsg: data["approval_msg"],
      approvalStatus: data["approval_status"],
      avgRating: data["avg_rating"],
      badge: data["badge"],
      badgeIcon: data["badge_icon"],
      categories: data["categories"],
      certificateTemplate: data["certificate_template"],
      coverImage: data["cover_image"],
      descFormat: data["desc_format"],
      description: data["description"],
      discountPercent: data["discount_percent"],
      id: data["id"],
      isEnrolled: data["is_enrolled"],
      isFree: data["is_free"],
      isPaid: data["is_paid"],
      language: data["language"],
      name: data["name"],
      numLectures: data["num_lectures"],
      numQuizzes: data["num_quizzes"],
      numStudentsEnrolled: data["num_students_enrolled"],
      numStudentsPassed: data["num_students_passed"],
      numVideos: data["num_videos"],
      originPrice: data["origin_price"],
      passPercentage: data["pass_percentage"],
      paymentGuide: data["payment_guide"],
      price: data["price"],
      privateUCoinFactor: data["private_ucoin_factor"],
      progress: data["progress"],
      publishTime: data["publish_time"],
      publishedAt: data["published_at"],
      shortDescription: data["short_description"],
      shortDescriptionFacebook: data["short_description_facebook"],
      shortDescriptionTwitter: data["short_description_twitter"],
      slug: data["slug"],
      status: data["status"],
      subject: data["subject"],
      suggestedDuration: data["suggested_duration"],
      tags: data["tags"],
      teacherAvatar: data["teacher_avatar"],
      teacherId: data["teacher_id"],
      teacherName: data["teacher_name"],
      thumbnail: data["thumbnail"],
      thumbnailFacebook: data["thumbnail_facebook"],
      thumbnailTwitter: data["thumbnail_twitter"],
      totalUCoin: data["total_ucoin"],
      userStatus: data["user_status"],
      videoDuration: data["video_duration"],
      visibility: data["visibility"],
    );
  }
}
