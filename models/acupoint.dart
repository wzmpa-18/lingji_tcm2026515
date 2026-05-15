class Acupoint {
  final String id;
  final String name;
  final String nameEn;
  final String meridian;
  final String location;
  final String indication;
  final String technique;
  final String? imageUrl;
  final String? model3dPath;

  Acupoint({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.meridian,
    required this.location,
    required this.indication,
    required this.technique,
    this.imageUrl,
    this.model3dPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'meridian': meridian,
      'location': location,
      'indication': indication,
      'technique': technique,
      'image_url': imageUrl,
      'model_3d_path': model3dPath,
    };
  }

  factory Acupoint.fromMap(Map<String, dynamic> map) {
    return Acupoint(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      nameEn: map['name_en'] ?? '',
      meridian: map['meridian'] ?? '',
      location: map['location'] ?? '',
      indication: map['indication'] ?? '',
      technique: map['technique'] ?? '',
      imageUrl: map['image_url'],
      model3dPath: map['model_3d_path'],
    );
  }
}
