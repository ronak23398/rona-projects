import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
  
  String get shopName => 'Shop'; // We'll get this from shop data later
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  String? _selectedShopId;

  Map<String, CartItem> get items => _items;
  String? get selectedShopId => _selectedShopId;

  int get itemCount => _items.length;

  int get totalQuantity => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryCharge => totalAmount < 100 ? 10.0 : 0.0;

  double get finalAmount => totalAmount + deliveryCharge;

  bool get isEmpty => _items.isEmpty;

  void addItem(Product product) {
    // Check if adding from different shop
    if (_selectedShopId != null && _selectedShopId != product.shopId) {
      // Clear cart if switching shops
      _items.clear();
    }
    
    _selectedShopId = product.shopId;

    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity--;
      } else {
        _items.remove(productId);
      }
      
      if (_items.isEmpty) {
        _selectedShopId = null;
      }
      
      notifyListeners();
    }
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity <= 0) {
        _items.remove(productId);
      } else {
        _items[productId]!.quantity = quantity;
      }
      
      if (_items.isEmpty) {
        _selectedShopId = null;
      }
      
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _selectedShopId = null;
    notifyListeners();
  }

  List<CartItem> get cartItems => _items.values.toList();

  int getQuantity(String productId) {
    return _items.containsKey(productId) ? _items[productId]!.quantity : 0;
  }
}
