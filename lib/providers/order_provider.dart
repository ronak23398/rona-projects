import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> createOrder(Order order) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final createdOrder = await _orderService.createOrderFromObject(order);
      
      _orders.insert(0, createdOrder);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createOrderLegacy({
    required String customerId,
    required String shopId,
    required List<OrderItem> items,
    String? customOrderDescription,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final order = await _orderService.createOrder(
        customerId: customerId,
        shopId: shopId,
        items: items,
        customOrderDescription: customOrderDescription,
      );
      
      _orders.insert(0, order);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCustomerOrders(String customerId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _orders = await _orderService.getOrdersByCustomer(customerId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadShopOrders(String shopId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _orders = await _orderService.getOrdersByShop(shopId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllOrders() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _orders = await _orderService.getAllOrders();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedOrder = await _orderService.updateOrderStatus(orderId, status);
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateOrderPrice(String orderId, double totalPrice) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedOrder = await _orderService.updateOrderPrice(orderId, totalPrice);
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }
}
