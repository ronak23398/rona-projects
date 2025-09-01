import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static const double _defaultRadiusKm = 10.0;

  /// Get current location with permission handling
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable location services.');
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied. Please enable them in settings.');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('LocationService Error: $e');
      rethrow;
    }
  }

  /// Calculate distance between two points in kilometers
  double calculateDistance(
    double lat1, 
    double lon1, 
    double lat2, 
    double lon2
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000; // Convert to km
  }

  /// Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || 
           permission == LocationPermission.whileInUse;
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      return permission == LocationPermission.always || 
             permission == LocationPermission.whileInUse;
    } catch (e) {
      print('LocationService Permission Error: $e');
      return false;
    }
  }

  /// Open app settings for location permission
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Open app settings for app permissions
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Filter shops by distance from user location
  List<T> filterByDistance<T>({
    required List<T> items,
    required double userLat,
    required double userLon,
    required double Function(T) getItemLat,
    required double Function(T) getItemLon,
    double maxDistanceKm = _defaultRadiusKm,
  }) {
    return items.where((item) {
      double distance = calculateDistance(
        userLat,
        userLon,
        getItemLat(item),
        getItemLon(item),
      );
      return distance <= maxDistanceKm;
    }).toList();
  }

  /// Sort shops by distance from user location
  List<T> sortByDistance<T>({
    required List<T> items,
    required double userLat,
    required double userLon,
    required double Function(T) getItemLat,
    required double Function(T) getItemLon,
  }) {
    items.sort((a, b) {
      double distanceA = calculateDistance(
        userLat,
        userLon,
        getItemLat(a),
        getItemLon(a),
      );
      double distanceB = calculateDistance(
        userLat,
        userLon,
        getItemLat(b),
        getItemLon(b),
      );
      return distanceA.compareTo(distanceB);
    });
    return items;
  }

  /// Format distance for display
  String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()}m';
    } else {
      return '${distanceKm.toStringAsFixed(1)}km';
    }
  }
}
