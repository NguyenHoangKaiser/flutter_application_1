import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/additional_info_item.dart';
import 'package:flutter_application_1/hourly_forecast_item.dart';
import 'package:flutter_application_1/secrets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final cityName = 'London';
  late Future<Map<String, dynamic>> currentWeatherData;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey'));

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw Exception('Error getting weather');
      }
      return data;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    currentWeatherData = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  currentWeatherData = getCurrentWeather();
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder<dynamic>(
          future: currentWeatherData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            final data = snapshot.data!;
            final currentWeatherData = data['list'][0];
            final currentTemp = currentWeatherData['main']['temp'] - 273.15;
            final currentSky = currentWeatherData['weather'][0]['main'];
            final currentPressure = currentWeatherData['main']['pressure'];
            final currentWindSpeed = currentWeatherData['wind']['speed'];
            final currentHumidity = currentWeatherData['main']['humidity'];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 14,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  '${currentTemp.toStringAsFixed(2)}°C',
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Icon(
                                    currentSky == 'Clouds' ||
                                            currentSky == 'Rain'
                                        ? Icons.cloud
                                        : Icons.sunny,
                                    size: 64),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  currentSky,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final item = data['list'][index + 1];
                        final time = DateTime.parse(item['dt_txt']);
                        final sky = item['weather'][0]['main'];
                        return HourlyForecastItem(
                            time: DateFormat.j().format(time),
                            temperature: item['main']['temp'],
                            icon: sky == 'Clouds' || sky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  Row(
                    children: <Widget>[
                      AdditionalInfoItem(
                        title: 'Wind',
                        value: '$currentWindSpeed km/h',
                        icon: Icons.cloud,
                      ),
                      AdditionalInfoItem(
                        title: 'Humidity',
                        value: '$currentHumidity %',
                        icon: Icons.water_drop,
                      ),
                      AdditionalInfoItem(
                        title: 'Pressure',
                        value: '$currentPressure hPa',
                        icon: Icons.beach_access,
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
