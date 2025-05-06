import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/weather_view_model.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const SmartWeatherApp());
}

class SmartWeatherApp extends StatelessWidget {
  const SmartWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherViewModel(),
      child: MaterialApp(
        title: 'SmartWeather',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}