class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String category;
  final double price;
  final int quantity;
  final String? imageUrl;
  final String shopId;
  final String shopName;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.category,
    required this.price,
    required this.quantity,
    this.imageUrl,
    required this.shopId,
    required this.shopName,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? id,
    String? productId,
    String? productName,
    String? category,
    double? price,
    int? quantity,
    String? imageUrl,
    String? shopId,
    String? shopName,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'category': category,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
      'shop_id': shopId,
      'shop_name': shopName,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'],
      category: json['category'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      imageUrl: json['image_url'],
      shopId: json['shop_id'],
      shopName: json['shop_name'],
    );
  }
}
