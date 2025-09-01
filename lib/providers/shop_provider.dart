import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/shop.dart';
import '../models/product.dart';
import '../services/shop_service.dart';
import '../services/location_service.dart';

class ShopProvider extends ChangeNotifier {
  final ShopService _shopService = ShopService();
  final LocationService _locationService = LocationService();
  
  List<Shop> _shops = [];
  List<Product> _products = [];
  Shop? _currentShop;
  bool _isLoading = false;
  String? _error;
  Position? _userLocation;
  bool _locationPermissionGranted = false;

  List<Shop> get shops => _shops;
  List<Product> get products => _products;
  Shop? get currentShop => _currentShop;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Position? get userLocation => _userLocation;
  bool get locationPermissionGranted => _locationPermissionGranted;
  bool get hasUserLocation => _userLocation != null;

  Future<void> loadShopsByPincode(String pincode) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('DEBUG ShopProvider: Loading shops for pincode: $pincode');
      _shops = await _shopService.getShopsByPincode(pincode);
      print('DEBUG ShopProvider: Loaded ${_shops.length} shops');
    } catch (e) {
      print('DEBUG ShopProvider: Error loading shops: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadShopByOwnerId(String ownerId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentShop = await _shopService.getShopByOwnerId(ownerId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createShop(Shop shop) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentShop = await _shopService.createShop(shop);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateShop(Shop shop) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentShop = await _shopService.updateShop(shop);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProducts(String shopId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _shopService.getProductsByShop(shopId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final newProduct = await _shopService.addProduct(product);
      _products.add(newProduct);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedProduct = await _shopService.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updatedProduct;
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

  Future<bool> deleteProduct(String productId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _shopService.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
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

  void clearShops() {
    _shops.clear();
    notifyListeners();
  }

  Future<void> searchShopsByProduct(String productName, String pincode) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('DEBUG ShopProvider: Searching shops with product: $productName in pincode: $pincode');
      _shops = await _shopService.searchShopsByProduct(productName, pincode);
      print('DEBUG ShopProvider: Found ${_shops.length} shops with product: $productName');
    } catch (e) {
      print('DEBUG ShopProvider: Error searching shops by product: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Request location permission and get current location
  Future<bool> requestLocationAndLoad() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Request location permission
      _locationPermissionGranted = await _locationService.requestLocationPermission();
      
      if (!_locationPermissionGranted) {
        _error = 'Location permission denied. Please enable location access to find nearby shops.';
        return false;
      }

      // Get current location
      _userLocation = await _locationService.getCurrentLocation();
      
      if (_userLocation != null) {
        // Load nearby shops
        await loadShopsByLocation();
        return true;
      } else {
        _error = 'Unable to get your current location. Please try again.';
        return false;
      }
    } catch (e) {
      print('DEBUG ShopProvider: Error requesting location: $e');
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load shops near user's current location
  Future<void> loadShopsByLocation({double radiusKm = 10.0}) async {
    if (_userLocation == null) {
      _error = 'Location not available. Please enable location access first.';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('DEBUG ShopProvider: Loading shops near location: ${_userLocation!.latitude}, ${_userLocation!.longitude}');
      _shops = await _shopService.getShopsByLocation(
        latitude: _userLocation!.latitude,
        longitude: _userLocation!.longitude,
        radiusKm: radiusKm,
      );
      print('DEBUG ShopProvider: Loaded ${_shops.length} nearby shops');
    } catch (e) {
      print('DEBUG ShopProvider: Error loading shops by location: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search shops by product near user's location
  Future<void> searchShopsByProductAndLocation(String productName, {double radiusKm = 10.0}) async {
    if (_userLocation == null) {
      _error = 'Location not available. Please enable location access first.';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('DEBUG ShopProvider: Searching shops with product: $productName near location');
      _shops = await _shopService.searchShopsByProductAndLocation(
        productName: productName,
        latitude: _userLocation!.latitude,
        longitude: _userLocation!.longitude,
        radiusKm: radiusKm,
      );
      print('DEBUG ShopProvider: Found ${_shops.length} shops with product: $productName nearby');
    } catch (e) {
      print('DEBUG ShopProvider: Error searching shops by product and location: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get distance from user to a specific shop
  double getDistanceToShop(Shop shop) {
    if (_userLocation == null || !shop.hasLocation) {
      return double.infinity;
    }

    return _shopService.getDistanceToShop(
      shop: shop,
      userLatitude: _userLocation!.latitude,
      userLongitude: _userLocation!.longitude,
    );
  }

  /// Format distance for display
  String formatDistance(double distanceKm) {
    return _locationService.formatDistance(distanceKm);
  }

  /// Check if location permission is granted
  Future<void> checkLocationPermission() async {
    _locationPermissionGranted = await _locationService.hasLocationPermission();
    notifyListeners();
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await _locationService.openLocationSettings();
  }

  /// Clear user location data
  void clearLocation() {
    _userLocation = null;
    _locationPermissionGranted = false;
    notifyListeners();
  }
}
