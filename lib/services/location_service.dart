import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      // First, check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return {
          'success': false,
          'error': 'Location services are disabled. Please enable location services in your phone settings.',
          'permissionDenied': false,
        };
      }

      // Check permission status
      LocationPermission permission = await Geolocator.checkPermission();

      // If permission is denied, request it
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return {
            'success': false,
            'error': 'Location permission denied. Please allow location access in app settings.',
            'permissionDenied': true,
          };
        }
      }

      // If permission is permanently denied
      if (permission == LocationPermission.deniedForever) {
        return {
          'success': false,
          'error': 'Location permission permanently denied. Please enable location in app settings.',
          'permissionDenied': true,
        };
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return {
        'success': true,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'permissionDenied': false,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to get location: $e',
        'permissionDenied': false,
      };
    }
  }
}