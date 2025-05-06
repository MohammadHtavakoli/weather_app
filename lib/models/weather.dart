import 'package:intl/intl.dart';

class Weather {
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final String cityName;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  Weather({
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.cityName,
    required this.hourly,
    required this.daily,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
    final forecastList = json['list'] as List<dynamic>;
    final firstForecast = forecastList[0];

    // Group forecasts by day for daily forecast
    final dailyForecasts = <String, List<dynamic>>{};
    for (var forecast in forecastList) {
      final date = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
      final dayKey = DateFormat('yyyy-MM-dd').format(date);
      if (!dailyForecasts.containsKey(dayKey)) {
        dailyForecasts[dayKey] = [];
      }
      dailyForecasts[dayKey]!.add(forecast);
    }

    final daily = dailyForecasts.entries.map((entry) {
      final forecasts = entry.value;
      final maxTemp = forecasts
          .map((f) => (f['main']['temp'] as num).toDouble())
          .reduce((a, b) => a > b ? a : b);
      final minTemp = forecasts
          .map((f) => (f['main']['temp'] as num).toDouble())
          .reduce((a, b) => a < b ? a : b);
      final mainForecast = forecasts[0]; // Use first forecast of the day
      return DailyForecast(
        date: DateTime.parse(entry.key),
        maxTemp: maxTemp,
        minTemp: minTemp,
        icon: mainForecast['weather'][0]['icon'],
      );
    }).toList();

    return Weather(
      temperature: (firstForecast['main']['temp'] as num).toDouble(),
      description: firstForecast['weather'][0]['description'],
      icon: firstForecast['weather'][0]['icon'],
      humidity: firstForecast['main']['humidity'],
      windSpeed: (firstForecast['wind']['speed'] as num).toDouble(),
      cityName: cityName,
      hourly: forecastList
          .take(24) // Limit to 24 hours (8 entries at 3-hour intervals)
          .map((f) => HourlyForecast.fromJson(f))
          .toList(),
      daily: daily.take(5).toList(), // Limit to 5 days
    );
  }
}

class HourlyForecast {
  final DateTime time;
  final double temperature;
  final String icon;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.icon,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String icon;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.icon,
  });
}