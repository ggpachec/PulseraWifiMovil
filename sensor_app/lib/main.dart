import 'package:flutter/material.dart';
import 'config_screen.dart';
import 'temperature_sensor_screen.dart';
import 'pressure_sensor_screen.dart';
import 'saturation_sensor_screen.dart';
import 'tracking_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color purpleBlue = Color.fromARGB(255, 71, 59, 235);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor App',
      theme: ThemeData(
        primaryColor: purpleBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
      routes: {
        '/temperature_sensor': (context) => TemperatureSensorScreen(),
        '/pressure_sensor': (context) => PressureSensorScreen(),
        '/saturation_sensor': (context) => SaturationSensorScreen(),
        '/tracking': (context) => TrackingScreen(),
        '/config': (context) => ConfigScreen(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/temperature_sensor');
                  },
                  child: Text('Sensor de Temperatura'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/pressure_sensor');
                  },
                  child: Text('Sensor de Presión'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/saturation_sensor');
                  },
                  child: Text('Sensor de Saturación'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/tracking');
                  },
                  child: Text('Seguimiento'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/config');
                  },
                  child: Text('Configuración de Límites'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
