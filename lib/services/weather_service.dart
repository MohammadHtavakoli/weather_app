import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const String _apiKey = '302457ffe4f65dba90817dcd3037d46a'; // Provided API key
  static const String _baseUrl = 'http://api.openweathermap.org/data/2.5/forecast';
  static const String _geoUrl = 'http://api.openweathermap.org/geo/1.0/direct';

  Future<Weather> getWeatherByLocation(double lat, double lon, String cityName) async {
    final url = Uri.parse('$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');
    print('Weather API Request URL: $url');
    final response = await http.get(url);
    print('Weather API Response Status: ${response.statusCode}');
    print('Weather API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body), cityName);
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Weather> getWeatherByCityId(int cityId, String cityName) async {
    final url = Uri.parse('$_baseUrl?id=$cityId&appid=$_apiKey&units=metric');
    print('Weather API Request URL: $url');
    final response = await http.get(url);
    print('Weather API Response Status: ${response.statusCode}');
    print('Weather API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body), cityName);
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getCityCoordinates(String city) async {
    final url = Uri.parse('$_geoUrl?q=$city&limit=1&appid=$_apiKey');
    print('Geocoding API Request URL: $url');
    final response = await http.get(url);
    print('Geocoding API Response Status: ${response.statusCode}');
    print('Geocoding API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return {
          'lat': data[0]['lat'],
          'lon': data[0]['lon'],
          'name': data[0]['name'],
        };
      }
      throw Exception('City not found');
    } else {
      throw Exception('Failed to fetch city coordinates: ${response.statusCode} - ${response.body}');
    }
  }
}