class UserProfile {
  final String id;
  final String role; // 'admin', 'shopkeeper', 'customer'
  final String name;
  final String email;
  final String? mobile;
  final String? address;
  final String? pincode;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    this.mobile,
    this.address,
    this.pincode,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      role: json['role'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      address: json['address'],
      pincode: json['pincode'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'pincode': pincode,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? role,
    String? name,
    String? email,
    String? mobile,
    String? address,
    String? pincode,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      pincode: pincode ?? this.pincode,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
