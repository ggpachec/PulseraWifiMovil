import 'package:flutter/material.dart';

class TemperatureSensorScreen extends StatelessWidget {
  String sensorData = '';

  void connectToSensor() {
    // Aquí puedes agregar la lógica para conectar al sensor
    // Por ejemplo, obtener datos simulados
    sensorData = 'Datos del sensor de temperatura';
  }

  void clearData() {
    sensorData = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor de Temperatura'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text(
              'Sensor de Temperatura',
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
