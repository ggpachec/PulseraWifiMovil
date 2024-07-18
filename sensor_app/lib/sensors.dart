import 'package:flutter/material.dart';

class SensorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensores'),
        //backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 28),
            onPressed: () {
              Navigator.pushNamed(context, '/generalSettings');
            },
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications, size: 28),
                Positioned(
                  right: 1,
                  top: 1,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/alerts');
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSensorButton(
                context,
                'Sensor de Temperatura',
                Icons.thermostat,
                '/temperature',
              ),
              _buildSensorButton(
                context,
                'Sensor de Presión',
                Icons.favorite,
                '/pressure',
              ),
              _buildSensorButton(
                context,
                'Sensor de Saturación',
                Icons.opacity,
                '/saturation',
              ),
              _buildSensorButton(
                context,
                'Sensor de Seguimiento',
                Icons.location_on,
                '/tracking',
              ),
              _buildSensorButton(
                context,
                'Configuración de límites',
                Icons.settings,
                '/config',
                color: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorButton(
    BuildContext context,
    String title,
    IconData icon,
    String route, {
    Color color = Colors.blueGrey,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 32),
        label: Text(title, style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5, // Agregar sombra
        ),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
