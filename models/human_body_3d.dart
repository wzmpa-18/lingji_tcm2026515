class HumanBody3DModel {
  final String id;
  final String name;
  final BodyLayerType layerType;
  final List<BodyPart3D> parts;
  final List<Acupoint3D> acupoints;
  final List<Joint3D> joints;
  final DateTime updatedAt;

  HumanBody3DModel({
    required this.id,
    required this.name,
    required this.layerType,
    required this.parts,
    required this.acupoints,
    required this.joints,
    required this.updatedAt,
  });
}

enum BodyLayerType {
  skin,
  muscle,
  skeleton,
}

extension BodyLayerTypeExtension on BodyLayerType {
  String get displayName {
    switch (this) {
      case BodyLayerType.skin:
        return '表层皮肤';
      case BodyLayerType.muscle:
        return '肌肉组织';
      case BodyLayerType.skeleton:
        return '骨骼架构';
    }
  }

  String get icon {
    switch (this) {
      case BodyLayerType.skin:
        return '👤';
      case BodyLayerType.muscle:
        return '💪';
      case BodyLayerType.skeleton:
        return '🦴';
    }
  }
}

class BodyPart3D {
  final String id;
  final String name;
  final String nameEn;
  final BodyLayerType layerType;
  final BodyRegion region;
  final Vector3 position;
  final Vector3 rotation;
  final Vector3 scale;
  final List<String> relatedMuscles;
  final List<String> relatedBones;
  final List<String> relatedMeridians;
  final String description;
  final String anatomyDetail;
  final double opacity;
  final bool isVisible;

  BodyPart3D({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.layerType,
    required this.region,
    required this.position,
    required this.rotation,
    required this.scale,
    this.relatedMuscles = const [],
    this.relatedBones = const [],
    this.relatedMeridians = const [],
    required this.description,
    required this.anatomyDetail,
    this.opacity = 1.0,
    this.isVisible = true,
  });
}

enum BodyRegion {
  head,
  neck,
  shoulder,
  chest,
  abdomen,
  back,
  arm,
  forearm,
  hand,
  thigh,
  calf,
  foot,
}

extension BodyRegionExtension on BodyRegion {
  String get displayName {
    switch (this) {
      case BodyRegion.head:
        return '头部';
      case BodyRegion.neck:
        return '颈部';
      case BodyRegion.shoulder:
        return '肩部';
      case BodyRegion.chest:
        return '胸部';
      case BodyRegion.abdomen:
        return '腹部';
      case BodyRegion.back:
        return '背部';
      case BodyRegion.arm:
        return '上臂';
      case BodyRegion.forearm:
        return '前臂';
      case BodyRegion.hand:
        return '手部';
      case BodyRegion.thigh:
        return '大腿';
      case BodyRegion.calf:
        return '小腿';
      case BodyRegion.foot:
        return '足部';
    }
  }
}

class Vector3 {
  final double x;
  final double y;
  final double z;

  const Vector3(this.x, this.y, this.z);

  static const zero = Vector3(0, 0, 0);
  static const one = Vector3(1, 1, 1);
}

class Acupoint3D {
  final String id;
  final String name;
  final String nameEn;
  final String code;
  final String meridian;
  final String category;
  final Vector3 position;
  final BodyRegion region;
  final String description;
  final String主治;
  final String配伍应用;
  final AcupointTechnique technique;
  final List<AcupointTaboo> taboos;
  final List<String> relatedPoints;
  final String clinicalSignificance;
  final String imageUrl;

  Acupoint3D({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.code,
    required this.meridian,
    required this.category,
    required this.position,
    required this.region,
    required this.description,
    required this主治,
    required this配伍应用,
    required this.technique,
    this.taboos = const [],
    this.relatedPoints = const [],
    required this.clinicalSignificance,
    required this.imageUrl,
  });
}

class AcupointTechnique {
  final double needleAngle;
  final NeedleAngleType angleType;
  final double depth;
  final NeedleDirection direction;
  final String manipulation;
  final List<String> images;
  final String techniqueDetail;

  AcupointTechnique({
    required this.needleAngle,
    required this.angleType,
    required this.depth,
    required this.direction,
    required this.manipulation,
    this.images = const [],
    required this.techniqueDetail,
  });
}

enum NeedleAngleType {
  perpendicular,
  oblique,
  horizontal,
}

extension NeedleAngleTypeExtension on NeedleAngleType {
  String get displayName {
    switch (this) {
      case NeedleAngleType.perpendicular:
        return '直刺';
      case NeedleAngleType.oblique:
        return '斜刺';
      case NeedleAngleType.horizontal:
        return '平刺';
    }
  }

  String get description {
    switch (this) {
      case NeedleAngleType.perpendicular:
        return '针身与皮肤呈90度角垂直刺入';
      case NeedleAngleType.oblique:
        return '针身与皮肤呈45度角斜刺';
      case NeedleAngleType.horizontal:
        return '针身与皮肤呈15-25度角沿皮刺入';
    }
  }
}

enum NeedleDirection {
  upward,
  downward,
  forward,
  backward,
  left,
  right,
}

extension NeedleDirectionExtension on NeedleDirection {
  String get displayName {
    switch (this) {
      case NeedleDirection.upward:
        return '向上';
      case NeedleDirection.downward:
        return '向下';
      case NeedleDirection.forward:
        return '向前';
      case NeedleDirection.backward:
        return '向后';
      case NeedleDirection.left:
        return '向左';
      case NeedleDirection.right:
        return '向右';
    }
  }
}

class AcupointTaboo {
  final String type;
  final String description;
  final String severity;

  AcupointTaboo({
    required this.type,
    required this.description,
    required this.severity,
  });
}

class Joint3D {
  final String id;
  final String name;
  final String nameEn;
  final BodyRegion region;
  final Vector3 position;
  final JointType type;
  final List<JointMovement> movements;
  final List<String> relatedMuscles;
  final List<String> relatedBones;
  final String description;
  final List<String> animationImages;

  Joint3D({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.region,
    required this.position,
    required this.type,
    required this.movements,
    required this.relatedMuscles,
    required this.relatedBones,
    required this.description,
    this.animationImages = const [],
  });
}

enum JointType {
  hinge,
  ballSocket,
  pivot,
  saddle,
  plane,
  condyloid,
}

extension JointTypeExtension on JointType {
  String get displayName {
    switch (this) {
      case JointType.hinge:
        return '屈戌关节';
      case JointType.ballSocket:
        return '球窝关节';
      case JointType.pivot:
        return '车轴关节';
      case JointType.saddle:
        return '鞍状关节';
      case JointType.plane:
        return '平面关节';
      case JointType.condyloid:
        return '椭圆关节';
    }
  }

  String get description {
    switch (this) {
      case JointType.hinge:
        return '只能进行屈伸运动，如肘关节';
      case JointType.ballSocket:
        return '可进行多方向运动，如肩关节';
      case JointType.pivot:
        return '可进行旋转运动，如桡尺近端关节';
      case JointType.saddle:
        return '可进行屈伸和收展运动，如拇指腕掌关节';
      case JointType.plane:
        return '可进行轻微滑动，如腕骨间关节';
      case JointType.condyloid:
        return '可进行屈伸和收展运动，如桡腕关节';
    }
  }
}

class JointMovement {
  final String id;
  final MovementType type;
  final String name;
  final double minAngle;
  final double maxAngle;
  final double currentAngle;
  final List<String> musclesInvolved;
  final List<String> bonesInvolved;
  final bool canAnimate;

  JointMovement({
    required this.id,
    required this.type,
    required this.name,
    required this.minAngle,
    required this.maxAngle,
    this.currentAngle = 0,
    required this.musclesInvolved,
    required this.bonesInvolved,
    this.canAnimate = true,
  });
}

enum MovementType {
  flexion,
  extension,
  abduction,
  adduction,
  rotation,
  circumduction,
}

extension MovementTypeExtension on MovementType {
  String get displayName {
    switch (this) {
      case MovementType.flexion:
        return '屈曲';
      case MovementType.extension:
        return '伸展';
      case MovementType.abduction:
        return '外展';
      case MovementType.adduction:
        return '内收';
      case MovementType.rotation:
        return '旋转';
      case MovementType.circumduction:
        return '环转';
    }
  }
}

class AcupointCategory3D {
  static const String jingluo = '经络穴位';
  static const String jingxue = '经外奇穴';
  static const String tianjiaoxue = '天应穴';
  static const Stringale = '阿是穴';
}
