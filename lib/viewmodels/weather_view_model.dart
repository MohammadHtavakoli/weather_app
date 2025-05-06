import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';

class WeatherViewModel extends ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final location = await _locationService.getCurrentLocation();
      _weather = await _weatherService.getWeatherByLocation(
        location['lat'],
        location['lon'],
        location['city'],
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final coords = await _weatherService.getCityCoordinates(city);
      _weather = await _weatherService.getWeatherByLocation(
        coords['lat'],
        coords['lon'],
        coords['name'],
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByCityId(int cityId, String cityName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weather = await _weatherService.getWeatherByCityId(cityId, cityName);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}