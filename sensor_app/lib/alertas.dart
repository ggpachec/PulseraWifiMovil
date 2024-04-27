import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alertas y Notificaciones'),
      ),
      body: ListView(
        children: <Widget>[
          _buildAlert('Emergencia Extrema', 'Presión arterial alta: 160 mmHg'),
          _buildAlert('Emergencia Moderada', 'Temperatura corporal baja: 34°C'),
          _buildAlert('Recordatorio', 'Saturación de oxígeno alta: 98%'),
        ],
      ),
    );
  }

  Widget _buildAlert(String tipo, String mensaje) {
    Color color;
    if (tipo == 'Emergencia Extrema') {
      color = Colors.red;
    } else if (tipo == 'Emergencia Moderada') {
      color = Colors.amber;
    } else {
      color = Colors.green;
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      color: color.withOpacity(0.3),
      child: Row(
        children: <Widget>[
          Icon(Icons.warning, color: color),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                tipo,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
              Text(
                mensaje,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
