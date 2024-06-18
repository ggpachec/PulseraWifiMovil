import 'package:flutter/material.dart';
import 'logIn.dart';
import 'createAccount.dart';
import 'forgotPassword.dart';
import 'sensors.dart';
import 'temperature_sensor_screen.dart';
import 'pressure_sensor_screen.dart';
import 'saturation_sensor_screen.dart';
import 'tracking_screen.dart';
import 'alertas.dart';
import 'config_screen.dart';
import 'configuracion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/createAccount': (context) => CreateAccountScreen(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
        '/sensors': (context) => SensorsScreen(),
        '/temperature': (context) => TemperatureSensorScreen(),
        '/pressure': (context) => PressureSensorScreen(),
        '/saturation': (context) => SaturationSensorScreen(),
        '/tracking': (context) => TrackingScreen(),
        '/alerts': (context) => AlertsScreen(),
        '/config': (context) => LimitsConfigScreen(),
        '/generalSettings': (context) => GeneralSettingsScreen(),
      },
    );
  }
}
