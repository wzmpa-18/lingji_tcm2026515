import 'package:uuid/uuid.dart';

class Master {
  final String id;
  final String name;
  final String avatar;
  final String title;
  final String specialization;
  final List<String> services;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final int orderCount;
  final int followerCount;
  final double priceFrom;
  final String intro;
  final List<String> certifications;
  final List<String> achievements;
  final bool isVerified;
  final bool isRecommended;
  final List<WorkingHour> workingHours;
  final List<Service> serviceList;
  final double latitude;
  final double longitude;
  final String address;

  const Master({
    required this.id,
    required this.name,
    required this.avatar,
    required this.title,
    required this.specialization,
    required this.services,
    required this.tags,
    required this.rating,
    required this.reviewCount,
    required this.orderCount,
    required this.followerCount,
    required this.priceFrom,
    required this.intro,
    required this.certifications,
    required this.achievements,
    this.isVerified = false,
    this.isRecommended = false,
    this.workingHours = const [],
    this.serviceList = const [],
    this.latitude = 0,
    this.longitude = 0,
    this.address = '',
  });
}

class WorkingHour {
  final int dayOfWeek;
  final String openTime;
  final String closeTime;
  final bool isOff;

  const WorkingHour({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    this.isOff = false,
  });
}

class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration;
  final bool isPopular;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    this.isPopular = false,
  });
}

class Review {
  final String id;
  final String masterId;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String content;
  final List<String> images;
  final DateTime createdAt;
  final String? serviceName;
  final List<String> tags;

  const Review({
    required this.id,
    required this.masterId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.content,
    this.images = const [],
    required this.createdAt,
    this.serviceName,
    this.tags = const [],
  });
}

class Appointment {
  final String id;
  final String masterId;
  final String masterName;
  final String userId;
  final String serviceId;
  final String serviceName;
  final DateTime appointmentTime;
  final int duration;
  final double price;
  final AppointmentStatus status;
  final String? note;
  final String? address;
  final DateTime createdAt;
  final DateTime? cancelledAt;
  final String? cancelReason;
  final Master? master;

  const Appointment({
    required this.id,
    required this.masterId,
    required this.masterName,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.appointmentTime,
    required this.duration,
    required this.price,
    required this.status,
    this.note,
    this.address,
    required this.createdAt,
    this.cancelledAt,
    this.cancelReason,
    this.master,
  });

  Appointment copyWith({
    String? id,
    String? masterId,
    String? masterName,
    String? userId,
    String? serviceId,
    String? serviceName,
    DateTime? appointmentTime,
    int? duration,
    double? price,
    AppointmentStatus? status,
    String? note,
    String? address,
    DateTime? createdAt,
    DateTime? cancelledAt,
    String? cancelReason,
    Master? master,
  }) {
    return Appointment(
      id: id ?? this.id,
      masterId: masterId ?? this.masterId,
      masterName: masterName ?? this.masterName,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      status: status ?? this.status,
      note: note ?? this.note,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancelReason: cancelReason ?? this.cancelReason,
      master: master ?? this.master,
    );
  }
}

enum AppointmentStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow,
}

extension AppointmentStatusExtension on AppointmentStatus {
  String get name {
    switch (this) {
      case AppointmentStatus.pending:
        return '待確認';
      case AppointmentStatus.confirmed:
        return '已確認';
      case AppointmentStatus.inProgress:
        return '服務中';
      case AppointmentStatus.completed:
        return '已完成';
      case AppointmentStatus.cancelled:
        return '已取消';
      case AppointmentStatus.noShow:
        return '未到場';
    }
  }

  String get color {
    switch (this) {
      case AppointmentStatus.pending:
        return '#FFA500';
      case AppointmentStatus.confirmed:
        return '#4CAF50';
      case AppointmentStatus.inProgress:
        return '#2196F3';
      case AppointmentStatus.completed:
        return '#9E9E9E';
      case AppointmentStatus.cancelled:
        return '#F44336';
      case AppointmentStatus.noShow:
        return '#9E9E9E';
    }
  }
}

class MasterReservationService {
  static final MasterReservationService _instance = MasterReservationService._internal();
  factory MasterReservationService() => _instance;
  MasterReservationService._internal();

  List<Master> getRecommendedMasters({
    String? category,
    String? city,
    SortBy sortBy = SortBy.rating,
  }) {
    var masters = _mockMasters;

    if (category != null) {
      masters = masters.where((m) => 
        m.services.any((s) => s.contains(category))).toList();
    }

    switch (sortBy) {
      case SortBy.rating:
        masters.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortBy.sales:
        masters.sort((a, b) => b.orderCount.compareTo(a.orderCount));
        break;
      case SortBy.price:
        masters.sort((a, b) => a.priceFrom.compareTo(b.priceFrom));
        break;
      case SortBy.distance:
        break;
    }

    return masters;
  }

  List<Master> searchMasters(String query) {
    final lowerQuery = query.toLowerCase();
    return _mockMasters.where((m) =>
      m.name.toLowerCase().contains(lowerQuery) ||
      m.specialization.toLowerCase().contains(lowerQuery) ||
      m.tags.any((t) => t.toLowerCase().contains(lowerQuery))
    .toList();
  }

  Master? getMasterById(String id) {
    try {
      return _mockMasters.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Review>> getMasterReviews(String masterId, {int page = 1}) async {
    return _mockReviews.where((r) => r.masterId == masterId).toList();
  }

  Future<Appointment> createAppointment({
    required String masterId,
    required String userId,
    required String serviceId,
    required DateTime appointmentTime,
    String? note,
    String? address,
  }) async {
    final master = getMasterById(masterId);
    if (master == null) throw Exception('師傅不存在');

    final service = master.serviceList.firstWhere(
      (s) => s.id == serviceId,
      orElse: () => master.serviceList.first,
    );

    return Appointment(
      id: const Uuid().v4(),
      masterId: masterId,
      masterName: master.name,
      userId: userId,
      serviceId: serviceId,
      serviceName: service.name,
      appointmentTime: appointmentTime,
      duration: service.duration,
      price: service.price,
      status: AppointmentStatus.pending,
      note: note,
      address: address ?? master.address,
      createdAt: DateTime.now(),
    );
  }

  Future<Appointment> cancelAppointment(Appointment appointment, String reason) async {
    return appointment.copyWith(
      status: AppointmentStatus.cancelled,
      cancelledAt: DateTime.now(),
      cancelReason: reason,
    );
  }

  Future<Appointment> confirmAppointment(Appointment appointment) async {
    return appointment.copyWith(status: AppointmentStatus.confirmed);
  }

  Future<Appointment> completeAppointment(Appointment appointment) async {
    return appointment.copyWith(status: AppointmentStatus.completed);
  }

  static const List<Master> _mockMasters = [
    Master(
      id: 'master_001',
      name: '陳明道',
      avatar: 'https://example.com/avatar1.jpg',
      title: '資深命理師',
      specialization: '八字命理、紫微斗數',
      services: ['八字合盤', '命理咨詢', '風水調整', '起名改名'],
      tags: ['八字', '紫微斗數', '風水', '起名'],
      rating: 4.9,
      reviewCount: 1280,
      orderCount: 3560,
      followerCount: 5600,
      priceFrom: 300,
      intro: '從事命理研究30餘年，師從多位名家，擅長八字、紫微斗數、風水堪輿。多年來為數萬人提供命理咨詢，積累了豐富的實踐經驗。',
      certifications: ['中級命理師資格證書', '風水師資格證書'],
      achievements: ['《命理實錄》作者', '多次受邀參加電視台命理節目'],
      isVerified: true,
      isRecommended: true,
      serviceList: [
        Service(id: 's1', name: '八字命盤分析', description: '完整分析命盤、大運、流年', price: 300, duration: 60, isPopular: true),
        Service(id: 's2', name: '八字合盤', description: '劉文元理論合盤分析', price: 500, duration: 90),
        Service(id: 's3', name: '風水調整咨詢', description: '家居/辦公室風水布局', price: 800, duration: 120),
        Service(id: 's4', name: '起名改名', description: '結合八字五行起名', price: 600, duration: 60),
      ],
      workingHours: [
        WorkingHour(dayOfWeek: 1, openTime: '09:00', closeTime: '18:00'),
        WorkingHour(dayOfWeek: 2, openTime: '09:00', closeTime: '18:00'),
        WorkingHour(dayOfWeek: 3, openTime: '09:00', closeTime: '18:00'),
        WorkingHour(dayOfWeek: 4, openTime: '09:00', closeTime: '18:00'),
        WorkingHour(dayOfWeek: 5, openTime: '09:00', closeTime: '18:00'),
        WorkingHour(dayOfWeek: 6, openTime: '10:00', closeTime: '16:00'),
        WorkingHour(dayOfWeek: 0, isOff: true),
      ],
      address: '香港中環荷李活道58號',
    ),
    Master(
      id: 'master_002',
      name: '林雅婷',
      avatar: 'https://example.com/avatar2.jpg',
      title: '中醫針灸師',
      specialization: '針灸調理、小兒推拿',
      services: ['針灸調理', '小兒推拿', '中醫咨詢', '艾灸理療'],
      tags: ['針灸', '小兒推拿', '艾灸', '中醫'],
      rating: 4.8,
      reviewCount: 890,
      orderCount: 2100,
      followerCount: 3200,
      priceFrom: 250,
      intro: '中醫針灸碩士，倪海厦再傳弟子，擅長小兒推拿和各類針灸調理。臨床經驗15年，服務超過萬名患者。',
      certifications: ['中醫針灸師資格證書', '小兒推拿師資格證書'],
      achievements: ['發表中醫論文10餘篇'],
      isVerified: true,
      isRecommended: true,
      serviceList: [
        Service(id: 's5', name: '針灸調理', description: '針對各類痛症調理', price: 250, duration: 45, isPopular: true),
        Service(id: 's6', name: '小兒推拿', description: '倪師小兒推拿手法', price: 200, duration: 30, isPopular: true),
        Service(id: 's7', name: '艾灸理療', description: '溫陽散寒艾灸', price: 280, duration: 60),
      ],
      address: '九龍旺角山東街89號',
    ),
    Master(
      id: 'master_003',
      name: '黃志遠',
      avatar: 'https://example.com/avatar3.jpg',
      title: '風水大師',
      specialization: '八宅風水、玄空飛星',
      services: ['陽宅風水', '陰宅風水', '辦公室布局', '商鋪選址'],
      tags: ['風水', '八宅', '玄空', '陽宅'],
      rating: 4.7,
      reviewCount: 650,
      orderCount: 1800,
      followerCount: 4100,
      priceFrom: 500,
      intro: '著名風水師，專研八宅、玄空、三合等多派風水，理論與實踐相結合，為眾多企業和家庭提供風水服務。',
      certifications: ['高級風水師資格證書'],
      achievements: ['央視風水欄目特邀嘉賓', '暢銷書《現代風水應用》作者'],
      isVerified: true,
      serviceList: [
        Service(id: 's8', name: '陽宅風水分析', description: '現場堪輿並提供調整方案', price: 500, duration: 120, isPopular: true),
        Service(id: 's9', name: '辦公室布局', description: '辦公環境風水優化', price: 800, duration: 90),
        Service(id: 's10', name: '商鋪選址評估', description: '店面風水評估及建議', price: 600, duration: 60),
      ],
      address: '新界沙田排頭村1號',
    ),
    Master(
      id: 'master_004',
      name: '李美慧',
      avatar: 'https://example.com/avatar4.jpg',
      title: '數字能量分析師',
      specialization: '手機號碼分析、車牌號碼',
      services: ['手機號分析', '車牌號分析', '數字能量咨詢'],
      tags: ['數字能量', '手機號', '車牌號'],
      rating: 4.6,
      reviewCount: 420,
      orderCount: 980,
      followerCount: 1500,
      priceFrom: 80,
      intro: '專精數字能量學說，結合傳統易學理論，為客戶提供手機號碼、車牌號碼等數字能量分析服務。',
      certifications: ['數字能量分析師資格證書'],
      achievements: [],
      isVerified: false,
      serviceList: [
        Service(id: 's11', name: '手機號分析', description: '完整手機號碼能量分析', price: 80, duration: 30, isPopular: true),
        Service(id: 's12', name: '車牌號分析', description: '車牌號碼能量分析', price: 80, duration: 30),
        Service(id: 's13', name: '深度分析報告', description: '含詳細建議和調整方案', price: 200, duration: 60),
      ],
      address: '線上服務',
    ),
    Master(
      id: 'master_005',
      name: '周天成',
      avatar: 'https://example.com/avatar5.jpg',
      title: '面相手相師',
      specialization: '麻衣神相、掌紋分析',
      services: ['面相分析', '手相分析', '綜合命理'],
      tags: ['面相', '手相', '麻衣神相'],
      rating: 4.8,
      reviewCount: 560,
      orderCount: 1200,
      followerCount: 2800,
      priceFrom: 200,
      intro: '研究相學多年，精通麻衣神相等傳統相學，能從面相和掌紋解讀人生運勢。',
      certifications: ['相學分析師資格證書'],
      achievements: ['《面相實錄》作者'],
      isVerified: true,
      serviceList: [
        Service(id: 's14', name: '面相分析', description: '完整面相分析報告', price: 200, duration: 45, isPopular: true),
        Service(id: 's15', name: '手相分析', description: '掌紋命理分析', price: 200, duration: 45),
        Service(id: 's16', name: '綜合命理', description: '面手相結合分析', price: 350, duration: 60),
      ],
      address: '香港島銅鑼灣記利佐治街1號',
    ),
  ];

  static const List<Review> _mockReviews = [
    Review(
      id: 'r1',
      masterId: 'master_001',
      userId: 'user1',
      userName: '張三',
      userAvatar: 'https://example.com/user1.jpg',
      rating: 5.0,
      content: '陳師傅非常專業，分析得很準確！根據他的建議調整後，運勢確實好了很多。強烈推薦！',
      createdAt: DateTime(2024, 1, 15),
      serviceName: '八字命盤分析',
      tags: ['專業', '準確', '有耐心'],
    ),
    Review(
      id: 'r2',
      masterId: 'master_001',
      userId: 'user2',
      userName: '李四',
      userAvatar: 'https://example.com/user2.jpg',
      rating: 4.5,
      content: '師傅解說詳細，對八字合盤分析很到位，給了很多有用的建議。',
      createdAt: DateTime(2024, 1, 10),
      serviceName: '八字合盤',
      tags: ['解說詳細', '有見地'],
    ),
    Review(
      id: 'r3',
      masterId: 'master_002',
      userId: 'user3',
      userName: '王五',
      userAvatar: 'https://example.com/user3.jpg',
      rating: 5.0,
      content: '林醫師的小兒推拿真的很有效！孩子發燒時做了推拿，很快就好了。感謝！',
      createdAt: DateTime(2024, 1, 12),
      serviceName: '小兒推拿',
      tags: ['效果好', '專業', '有愛心'],
    ),
  ];
}

enum SortBy {
  rating,
  sales,
  price,
  distance,
}
