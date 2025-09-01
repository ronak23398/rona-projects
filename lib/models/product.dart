class Product {
  final String id;
  final String shopId;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String? imageUrl;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.shopId,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.imageUrl,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      shopId: json['shop_id'],
      name: json['name'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_id': shopId,
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Product copyWith({
    String? id,
    String? shopId,
    String? name,
    String? category,
    double? price,
    int? stock,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
