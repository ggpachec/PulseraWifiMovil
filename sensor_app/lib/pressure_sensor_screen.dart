import 'package:flutter/material.dart';

class PressureSensorScreen extends StatelessWidget {
  String sensorData = '';

  void connectToSensor() {
    // Simulación de conexión al sensor de presión
    sensorData = 'Datos del sensor de presión';
  }

  void clearData() {
    sensorData = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor de Presión'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text(
              'Sensor de Presión',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: connectToSensor,
            child: Text('Conectar'),
          ),
          ElevatedButton(
            onPressed: clearData,
            child: Text('Limpiar'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(sensorData),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
