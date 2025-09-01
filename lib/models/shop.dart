class Shop {
  final String id;
  final String ownerId;
  final String name;
  final String address;
  final String pincode;
  final int? radiusKm;
  final bool openStatus;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;

  Shop({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    required this.pincode,
    this.radiusKm,
    required this.openStatus,
    required this.createdAt,
    this.latitude,
    this.longitude,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      ownerId: json['owner_id'],
      name: json['name'],
      address: json['address'],
      pincode: json['pincode'],
      radiusKm: json['radius_km'],
      openStatus: json['open_status'],
      createdAt: DateTime.parse(json['created_at']),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'address': address,
      'pincode': pincode,
      'radius_km': radiusKm,
      'open_status': openStatus,
      'created_at': createdAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Shop copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? address,
    String? pincode,
    int? radiusKm,
    bool? openStatus,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
  }) {
    return Shop(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      address: address ?? this.address,
      pincode: pincode ?? this.pincode,
      radiusKm: radiusKm ?? this.radiusKm,
      openStatus: openStatus ?? this.openStatus,
      createdAt: createdAt ?? this.createdAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  /// Check if shop has valid location coordinates
  bool get hasLocation => latitude != null && longitude != null;
}
