import 'package:uuid/uuid.dart';

enum CourseCategory {
  tcm,
  acupuncture,
  pediatric,
  fortune,
  fengshui,
  numberEnergy,
  faceReading,
  nameAnalysis,
  bazi,
  other,
}

enum CourseStatus {
  draft,
  pending,
  approved,
  rejected,
  offline,
}

enum CommissionTier {
  tier1,
  tier2,
  tier3,
  tier4,
  tier5,
}

extension CommissionTierExtension on CommissionTier {
  double get rate {
    switch (this) {
      case CommissionTier.tier1:
        return 0.50;
      case CommissionTier.tier2:
        return 0.40;
      case CommissionTier.tier3:
        return 0.30;
      case CommissionTier.tier4:
        return 0.20;
      case CommissionTier.tier5:
        return 0.10;
    }
  }

  int get minRating {
    switch (this) {
      case CommissionTier.tier1:
        return 0;
      case CommissionTier.tier2:
        return 4.5;
      case CommissionTier.tier3:
        return 4.7;
      case CommissionTier.tier4:
        return 4.8;
      case CommissionTier.tier5:
        return 4.9;
    }
  }

  int get minCourses {
    switch (this) {
      case CommissionTier.tier1:
        return 0;
      case CommissionTier.tier2:
        return 5;
      case CommissionTier.tier3:
        return 10;
      case CommissionTier.tier4:
        return 20;
      case CommissionTier.tier5:
        return 50;
    }
  }
}

class Instructor {
  final String id;
  final String userId;
  final String name;
  final String avatar;
  final String title;
  final String specialization;
  final String intro;
  final List<String> certifications;
  final List<String> credentials;
  final double rating;
  final int totalStudents;
  final int totalCourses;
  final double balance;
  final bool isVerified;
  final bool isActive;
  final double commissionRate;
  final CommissionTier commissionTier;
  final DateTime createdAt;
  final List<String> tags;

  const Instructor({
    required this.id,
    required this.userId,
    required this.name,
    required this.avatar,
    required this.title,
    required this.specialization,
    required this.intro,
    this.certifications = const [],
    this.credentials = const [],
    this.rating = 0,
    this.totalStudents = 0,
    this.totalCourses = 0,
    this.balance = 0,
    this.isVerified = false,
    this.isActive = false,
    this.commissionRate = 0.50,
    this.commissionTier = CommissionTier.tier1,
    required this.createdAt,
    this.tags = const [],
  });

  Instructor copyWith({
    String? id,
    String? userId,
    String? name,
    String? avatar,
    String? title,
    String? specialization,
    String? intro,
    List<String>? certifications,
    List<String>? credentials,
    double? rating,
    int? totalStudents,
    int? totalCourses,
    double? balance,
    bool? isVerified,
    bool? isActive,
    double? commissionRate,
    CommissionTier? commissionTier,
    DateTime? createdAt,
    List<String>? tags,
  }) {
    return Instructor(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      title: title ?? this.title,
      specialization: specialization ?? this.specialization,
      intro: intro ?? this.intro,
      certifications: certifications ?? this.certifications,
      credentials: credentials ?? this.credentials,
      rating: rating ?? this.rating,
      totalStudents: totalStudents ?? this.totalStudents,
      totalCourses: totalCourses ?? this.totalCourses,
      balance: balance ?? this.balance,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      commissionRate: commissionRate ?? this.commissionRate,
      commissionTier: commissionTier ?? this.commissionTier,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }
}

class Course {
  final String id;
  final String instructorId;
  final String title;
  final String subtitle;
  final String description;
  final CourseCategory category;
  final double price;
  final double originalPrice;
  final String? thumbnail;
  final List<String> images;
  final List<String> videoUrls;
  final int durationMinutes;
  final int lessonsCount;
  final int studentsCount;
  final double rating;
  final int reviewsCount;
  final CourseStatus status;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? publishedAt;
  final bool isFeatured;
  final bool isPopular;
  final List<CourseLesson> lessons;
  final String? introVideoUrl;

  const Course({
    required this.id,
    required this.instructorId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.price,
    this.originalPrice = 0,
    this.thumbnail,
    this.images = const [],
    this.videoUrls = const [],
    this.durationMinutes = 0,
    this.lessonsCount = 0,
    this.studentsCount = 0,
    this.rating = 0,
    this.reviewsCount = 0,
    this.status = CourseStatus.draft,
    this.tags = const [],
    required this.createdAt,
    this.publishedAt,
    this.isFeatured = false,
    this.isPopular = false,
    this.lessons = const [],
    this.introVideoUrl,
  });
}

class CourseLesson {
  final String id;
  final String title;
  final String description;
  final int order;
  final int durationMinutes;
  final String? videoUrl;
  final String? audioUrl;
  final String? content;
  final List<String> attachments;

  const CourseLesson({
    required this.id,
    required this.title,
    this.description = '',
    required this.order,
    this.durationMinutes = 0,
    this.videoUrl,
    this.audioUrl,
    this.content,
    this.attachments = const [],
  });
}

class CourseOrder {
  final String id;
  final String userId;
  final String courseId;
  final String instructorId;
  final double price;
  final double platformFee;
  final double instructorEarning;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final DateTime? paidAt;

  const CourseOrder({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.instructorId,
    required this.price,
    required this.platformFee,
    required this.instructorEarning,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.paidAt,
  });
}

enum OrderStatus {
  pending,
  paid,
  refunded,
  cancelled,
}

enum PaymentMethod {
  wechat,
  alipay,
  usdt,
  usdc,
  btc,
  eth,
}

class CourseReview {
  final String id;
  final String orderId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String courseId;
  final String instructorId;
  final double rating;
  final String content;
  final List<String> images;
  final List<String> tags;
  final DateTime createdAt;

  const CourseReview({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.courseId,
    required this.instructorId,
    required this.rating,
    required this.content,
    this.images = const [],
    this.tags = const [],
    required this.createdAt,
  });
}

class LearningTask {
  final String id;
  final String userId;
  final String type;
  final String title;
  final int points;
  final bool isCompleted;
  final DateTime? completedAt;

  const LearningTask({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.points,
    this.isCompleted = false,
    this.completedAt,
  });
}

class InstructorCourseService {
  static final InstructorCourseService _instance = InstructorCourseService._internal();
  factory InstructorCourseService() => _instance;
  InstructorCourseService._internal();

  List<Instructor> _instructors = [];
  List<Course> _courses = [];
  List<CourseOrder> _orders = [];
  List<CourseReview> _reviews = [];

  Future<Instructor> applyAsInstructor({
    required String userId,
    required String name,
    required String avatar,
    required String title,
    required String specialization,
    required String intro,
    required List<String> certifications,
    required List<String> credentials,
  }) async {
    final instructor = Instructor(
      id: const Uuid().v4(),
      userId: userId,
      name: name,
      avatar: avatar,
      title: title,
      specialization: specialization,
      intro: intro,
      certifications: certifications,
      credentials: credentials,
      createdAt: DateTime.now(),
    );

    _instructors.add(instructor);
    return instructor;
  }

  Future<Course> createCourse({
    required String instructorId,
    required String title,
    required String subtitle,
    required String description,
    required CourseCategory category,
    required double price,
    String? thumbnail,
    List<String> tags = const [],
  }) async {
    final course = Course(
      id: const Uuid().v4(),
      instructorId: instructorId,
      title: title,
      subtitle: subtitle,
      description: description,
      category: category,
      price: price,
      thumbnail: thumbnail,
      tags: tags,
      createdAt: DateTime.now(),
    );

    _courses.add(course);
    return course;
  }

  Future<Course> publishCourse(String courseId) async {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index >= 0) {
      _courses[index] = Course(
        _courses[index].id,
        _courses[index].instructorId,
        _courses[index].title,
        _courses[index].subtitle,
        _courses[index].description,
        _courses[index].category,
        _courses[index].price,
        _courses[index].originalPrice,
        _courses[index].thumbnail,
        _courses[index].images,
        _courses[index].videoUrls,
        _courses[index].durationMinutes,
        _courses[index].lessonsCount,
        _courses[index].studentsCount,
        _courses[index].rating,
        _courses[index].reviewsCount,
        CourseStatus.approved,
        _courses[index].tags,
        _courses[index].createdAt,
        DateTime.now(),
        _courses[index].isFeatured,
        _courses[index].isPopular,
        _courses[index].lessons,
        _courses[index].introVideoUrl,
      );
      return _courses[index];
    }
    throw Exception('Course not found');
  }

  Future<CourseOrder> purchaseCourse({
    required String userId,
    required String courseId,
    required PaymentMethod paymentMethod,
  }) async {
    final course = _courses.firstWhere((c) => c.id == courseId);
    final instructor = _instructors.firstWhere((i) => i.id == course.instructorId);

    final platformFee = course.price * instructor.commissionRate;
    final instructorEarning = course.price - platformFee;

    final order = CourseOrder(
      id: const Uuid().v4(),
      userId: userId,
      courseId: courseId,
      instructorId: course.instructorId,
      price: course.price,
      platformFee: platformFee,
      instructorEarning: instructorEarning,
      status: OrderStatus.paid,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
      paidAt: DateTime.now(),
    );

    _orders.add(order);

    final courseIndex = _courses.indexWhere((c) => c.id == courseId);
    if (courseIndex >= 0) {
      _courses[courseIndex] = Course(
        _courses[courseIndex].id,
        _courses[courseIndex].instructorId,
        _courses[courseIndex].title,
        _courses[courseIndex].subtitle,
        _courses[courseIndex].description,
        _courses[courseIndex].category,
        _courses[courseIndex].price,
        _courses[courseIndex].originalPrice,
        _courses[courseIndex].thumbnail,
        _courses[courseIndex].images,
        _courses[courseIndex].videoUrls,
        _courses[courseIndex].durationMinutes,
        _courses[courseIndex].lessonsCount,
        _courses[courseIndex].studentsCount + 1,
        _courses[courseIndex].rating,
        _courses[courseIndex].reviewsCount,
        _courses[courseIndex].status,
        _courses[courseIndex].tags,
        _courses[courseIndex].createdAt,
        _courses[courseIndex].publishedAt,
        _courses[courseIndex].isFeatured,
        _courses[courseIndex].isPopular,
        _courses[courseIndex].lessons,
        _courses[courseIndex].introVideoUrl,
      );
    }

    return order;
  }

  Future<CourseReview> submitReview({
    required String orderId,
    required String userId,
    required String userName,
    required String userAvatar,
    required String courseId,
    required String instructorId,
    required double rating,
    required String content,
    List<String> tags = const [],
  }) async {
    final review = CourseReview(
      id: const Uuid().v4(),
      orderId: orderId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      courseId: courseId,
      instructorId: instructorId,
      rating: rating,
      content: content,
      tags: tags,
      createdAt: DateTime.now(),
    );

    _reviews.add(review);

    await _updateInstructorCommissionTier(instructorId);

    return review;
  }

  Future<void> _updateInstructorCommissionTier(String instructorId) async {
    final instructor = _instructors.firstWhere((i) => i.id == instructorId);
    final instructorReviews = _reviews.where((r) => r.instructorId == instructorId).toList();
    
    double avgRating = 0;
    if (instructorReviews.isNotEmpty) {
      avgRating = instructorReviews.map((r) => r.rating).reduce((a, b) => a + b) / instructorReviews.length;
    }

    CommissionTier newTier = CommissionTier.tier1;
    for (final tier in CommissionTier.values.reversed) {
      if (avgRating >= tier.minRating && instructor.totalCourses >= tier.minCourses) {
        newTier = tier;
        break;
      }
    }

    final index = _instructors.indexWhere((i) => i.id == instructorId);
    if (index >= 0) {
      _instructors[index] = instructor.copyWith(
        commissionTier: newTier,
        commissionRate: newTier.rate,
        rating: avgRating,
      );
    }
  }

  List<Course> getRecommendedCourses({int limit = 10}) {
    final published = _courses.where((c) => c.status == CourseStatus.approved).toList();
    published.sort((a, b) {
      if (a.isFeatured && !b.isFeatured) return -1;
      if (!a.isFeatured && b.isFeatured) return 1;
      return b.rating.compareTo(a.rating);
    });
    return published.take(limit).toList();
  }

  List<Course> getCoursesByCategory(CourseCategory category, {int limit = 20}) {
    return _courses
        .where((c) => c.category == category && c.status == CourseStatus.approved)
        .take(limit)
        .toList();
  }

  List<Course> searchCourses(String query) {
    final lowerQuery = query.toLowerCase();
    return _courses
        .where((c) =>
            c.status == CourseStatus.approved &&
            (c.title.toLowerCase().contains(lowerQuery) ||
                c.description.toLowerCase().contains(lowerQuery) ||
                c.tags.any((t) => t.toLowerCase().contains(lowerQuery))))
        .toList();
  }

  Instructor? getInstructor(String instructorId) {
    try {
      return _instructors.firstWhere((i) => i.id == instructorId);
    } catch (_) {
      return null;
    }
  }

  List<Course> getInstructorCourses(String instructorId) {
    return _courses.where((c) => c.instructorId == instructorId).toList();
  }

  List<CourseReview> getCourseReviews(String courseId) {
    return _reviews.where((r) => r.courseId == courseId).toList();
  }

  List<LearningTask> getLearningTasks(String userId) {
    return [
      LearningTask(
        id: '1',
        userId: userId,
        type: 'watch',
        title: '觀看教程視頻',
        points: 10,
      ),
      LearningTask(
        id: '2',
        userId: userId,
        type: 'study',
        title: '完成學習筆記',
        points: 20,
      ),
      LearningTask(
        id: '3',
        userId: userId,
        type: 'review',
        title: '發表課程評價',
        points: 30,
      ),
      LearningTask(
        id: '4',
        userId: userId,
        type: 'share',
        title: '分享課程',
        points: 15,
      ),
    ];
  }

  static const List<String> courseCategoryNames = [
    '中醫養生',
    '針灸推拿',
    '兒科調理',
    '命理預測',
    '風水堪輿',
    '數字能量',
    '面相手相',
    '測字起名',
    '八字命理',
    '其他',
  ];
}
