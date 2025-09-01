import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Order> createOrderFromObject(Order order) async {
    try {
      // Create order in database
      final orderResponse = await _supabase
          .from('orders')
          .insert({
            'customer_id': order.customerId,
            'shop_id': order.shopId,
            'total_amount': order.totalAmount,
            'delivery_charge': order.deliveryCharge,
            'final_amount': order.finalAmount,
            'status': order.status,
            'payment_method': order.paymentMethod,
            'delivery_address': order.deliveryAddress,
            'customer_phone': order.customerPhone,
            'order_notes': order.orderNotes,
            'order_date': order.orderDate.toIso8601String(),
            'estimated_delivery_time': order.estimatedDeliveryTime?.toIso8601String(),
          })
          .select()
          .single();

      final orderId = orderResponse['id'];

      // Insert order items
      if (order.items.isNotEmpty) {
        final orderItemsData = order.items.map((item) => {
          'order_id': orderId,
          'product_id': item.productId,
          'product_name': item.productName,
          'quantity': item.quantity,
          'price': item.price,
          'total_price': item.totalPrice,
        }).toList();

        await _supabase.from('order_items').insert(orderItemsData);
      }

      // Return the created order with the database-generated ID
      return order.copyWith(id: orderId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> createOrder({
    required String customerId,
    required String shopId,
    required List<OrderItem> items,
    List<CustomOrder>? customOrders,
    String? customOrderDescription,
  }) async {
    try {
      // Calculate total price
      double totalPrice = items.fold(0, (sum, item) => sum + (item.price * item.quantity));
      
      // Add custom order if provided
      if (customOrderDescription != null && customOrderDescription.isNotEmpty) {
        // For custom orders, we'll add a base amount or let shopkeeper set price
        totalPrice += 0; // Shopkeeper will update this
      }

      // Calculate delivery charge
      double deliveryCharge = totalPrice < 100 ? 10 : 0;

      // Create order
      final orderResponse = await _supabase
          .from('orders')
          .insert({
            'customer_id': customerId,
            'shop_id': shopId,
            'total_price': totalPrice,
            'delivery_charge': deliveryCharge,
            'status': 'pending',
          })
          .select()
          .single();

      final orderId = orderResponse['id'];

      // Insert order items
      if (items.isNotEmpty) {
        final orderItemsData = items.map((item) => {
          'order_id': orderId,
          'product_id': item.productId,
          'quantity': item.quantity,
          'price': item.price,
        }).toList();

        await _supabase.from('order_items').insert(orderItemsData);
      }

      // Insert custom order if provided
      if (customOrderDescription != null && customOrderDescription.isNotEmpty) {
        await _supabase.from('custom_orders').insert({
          'order_id': orderId,
          'description': customOrderDescription,
        });
      }

      return Order.fromJson(orderResponse);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Order>> getOrdersByCustomer(String customerId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            *,
            order_items(*),
            custom_orders(*)
          ''')
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((order) => Order.fromJson(order))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Order>> getOrdersByShop(String shopId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            *,
            order_items(*),
            custom_orders(*),
            profiles!orders_customer_id_fkey(name, mobile, address)
          ''')
          .eq('shop_id', shopId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((order) => Order.fromJson(order))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await _supabase
          .from('orders')
          .update({'status': status})
          .eq('id', orderId)
          .select()
          .single();

      return Order.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> updateOrderPrice(String orderId, double totalPrice) async {
    try {
      // Recalculate delivery charge
      double deliveryCharge = totalPrice < 100 ? 10 : 0;
      
      final response = await _supabase
          .from('orders')
          .update({
            'total_price': totalPrice,
            'delivery_charge': deliveryCharge,
          })
          .eq('id', orderId)
          .select()
          .single();

      return Order.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Order>> getAllOrders() async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            *,
            order_items(*),
            custom_orders(*),
            profiles!orders_customer_id_fkey(name, mobile, address),
            shops(name, address)
          ''')
          .order('created_at', ascending: false);

      return (response as List)
          .map((order) => Order.fromJson(order))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Order>> watchOrdersByShop(String shopId) {
    return _supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('shop_id', shopId)
        .map((data) => data.map((order) => Order.fromJson(order)).toList());
  }

  Stream<List<Order>> watchOrdersByCustomer(String customerId) {
    return _supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('customer_id', customerId)
        .map((data) => data.map((order) => Order.fromJson(order)).toList());
  }
}
