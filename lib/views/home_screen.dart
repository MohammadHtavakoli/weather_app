import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../viewmodels/weather_view_model.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_list.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WeatherViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Test with Moscow city ID
      viewModel.fetchWeatherByCityId(524901, 'Moscow');
      // Alternatively, use location-based fetching
      // viewModel.fetchWeatherByLocation();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartWeather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<WeatherViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }

          final weather = viewModel.weather;
          if (weather == null) {
            return const Center(child: Text('No weather data available'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Lottie.asset(
                  _getWeatherAnimation(weather.icon),
                  height: 200,
                  width: 200,
                ),
                WeatherCard(weather: weather),
                ForecastList(hourly: weather.hourly, daily: weather.daily),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getWeatherAnimation(String icon) {
    if (icon.contains('01') || icon.contains('02')) return 'assets/lottie/sunny.json';
    if (icon.contains('03') || icon.contains('04')) return 'assets/lottie/cloudy.json';
    if (icon.contains('09') || icon.contains('10')) return 'assets/lottie/rainy.json';
    if (icon.contains('13')) return 'assets/lottie/snowy.json';
    return 'assets/lottie/cloudy.json';
  }
}