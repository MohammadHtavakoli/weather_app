import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static const String _apiKey = '302457ffe4f65dba90817dcd3037d46a'; // Provided API key
  static const String _geoUrl = 'http://api.openweathermap.org/geo/1.0/reverse';

  Future<Map<String, dynamic>> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Reverse geocoding to get city name
    final response = await http.get(
      Uri.parse('$_geoUrl?lat=${position.latitude}&lon=${position.longitude}&limit=1&appid=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return {
          'lat': position.latitude,
          'lon': position.longitude,
          'city': data[0]['name'],
        };
      }
    }
    throw Exception('Failed to fetch city name');
  }
}