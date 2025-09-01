class Order {
  final String id;
  final String customerId;
  final String shopId;
  final double totalAmount;
  final double deliveryCharge;
  final double finalAmount;
  final String status; // 'pending', 'accepted', 'out_for_delivery', 'delivered', 'cancelled'
  final String paymentMethod;
  final String deliveryAddress;
  final String customerPhone;
  final String? orderNotes;
  final DateTime orderDate;
  final DateTime? estimatedDeliveryTime;
  final DateTime createdAt;
  final List<OrderItem> items;
  final List<CustomOrder>? customOrders;

  Order({
    required this.id,
    required this.customerId,
    required this.shopId,
    required this.totalAmount,
    required this.deliveryCharge,
    required this.finalAmount,
    required this.status,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.customerPhone,
    this.orderNotes,
    required this.orderDate,
    this.estimatedDeliveryTime,
    DateTime? createdAt,
    required this.items,
    this.customOrders,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customer_id'],
      shopId: json['shop_id'],
      totalAmount: (json['total_amount'] ?? json['total_price'] ?? 0).toDouble(),
      deliveryCharge: (json['delivery_charge'] ?? 0).toDouble(),
      finalAmount: (json['final_amount'] ?? json['total_price'] ?? 0).toDouble(),
      status: json['status'],
      paymentMethod: json['payment_method'] ?? 'cash_on_delivery',
      deliveryAddress: json['delivery_address'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      orderNotes: json['order_notes'],
      orderDate: json['order_date'] != null 
          ? DateTime.parse(json['order_date'])
          : DateTime.parse(json['created_at']),
      estimatedDeliveryTime: json['estimated_delivery_time'] != null
          ? DateTime.parse(json['estimated_delivery_time'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      items: json['order_items'] != null
          ? (json['order_items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList()
          : [],
      customOrders: json['custom_orders'] != null
          ? (json['custom_orders'] as List)
              .map((order) => CustomOrder.fromJson(order))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'shop_id': shopId,
      'total_amount': totalAmount,
      'delivery_charge': deliveryCharge,
      'final_amount': finalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'delivery_address': deliveryAddress,
      'customer_phone': customerPhone,
      'order_notes': orderNotes,
      'order_date': orderDate.toIso8601String(),
      'estimated_delivery_time': estimatedDeliveryTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Order copyWith({
    String? id,
    String? customerId,
    String? shopId,
    double? totalAmount,
    double? deliveryCharge,
    double? finalAmount,
    String? status,
    String? paymentMethod,
    String? deliveryAddress,
    String? customerPhone,
    String? orderNotes,
    DateTime? orderDate,
    DateTime? estimatedDeliveryTime,
    DateTime? createdAt,
    List<OrderItem>? items,
    List<CustomOrder>? customOrders,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      shopId: shopId ?? this.shopId,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      finalAmount: finalAmount ?? this.finalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      customerPhone: customerPhone ?? this.customerPhone,
      orderNotes: orderNotes ?? this.orderNotes,
      orderDate: orderDate ?? this.orderDate,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
      customOrders: customOrders ?? this.customOrders,
    );
  }
}

class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final double totalPrice;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'total_price': totalPrice,
    };
  }
}

class CustomOrder {
  final String id;
  final String orderId;
  final String description;

  CustomOrder({
    required this.id,
    required this.orderId,
    required this.description,
  });

  factory CustomOrder.fromJson(Map<String, dynamic> json) {
    return CustomOrder(
      id: json['id'],
      orderId: json['order_id'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'description': description,
    };
  }
}
