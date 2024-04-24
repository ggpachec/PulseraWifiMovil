import 'package:flutter/material.dart';

class SaturationSensorScreen extends StatelessWidget {
  String sensorData = '';

  void connectToSensor() {
    // Simulación de conexión al sensor de saturación
    sensorData = 'Datos del sensor de saturación';
  }

  void clearData() {
    sensorData = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor de Saturación'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text(
              'Sensor de Saturación',
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
