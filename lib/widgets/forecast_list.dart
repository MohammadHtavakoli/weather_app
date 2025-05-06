import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather.dart';

class ForecastList extends StatelessWidget {
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  const ForecastList({super.key, required this.hourly, required this.daily});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '3-Hour Forecast',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourly.length,
            itemBuilder: (context, index) {
              final forecast = hourly[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(DateFormat('h a').format(forecast.time)),
                    Image.network(
                      'http://openweathermap.org/img/wn/${forecast.icon}.png',
                      width: 50,
                    ),
                    Text('${forecast.temperature.toStringAsFixed(1)}°C'),
                  ],
                ),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Daily Forecast',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daily.length,
          itemBuilder: (context, index) {
            final forecast = daily[index];
            return ListTile(
              leading: Image.network(
                'http://openweathermap.org/img/wn/${forecast.icon}.png',
                width: 50,
              ),
              title: Text(DateFormat('EEEE').format(forecast.date)),
              subtitle: Text(
                'Max: ${forecast.maxTemp.toStringAsFixed(1)}°C, Min: ${forecast.minTemp.toStringAsFixed(1)}°C',
              ),
            );
          },
        ),
      ],
    );
  }
}