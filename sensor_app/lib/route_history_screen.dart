import 'package:flutter/material.dart';

class RouteHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Rutas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Desde',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Hasta',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  _buildRouteCard(
                      'Plaza Central', '2024-08-01', '10:00 AM', true),
                  _buildRouteCard('Calle 5', '2024-08-01', '10:30 AM', false),
                  _buildRouteCard(
                      'Centro Comercial', '2024-08-01', '11:00 AM', true),
                  _buildRouteCard(
                      'Parque Norte', '2024-08-01', '11:30 AM', false),
                  _buildRouteCard(
                      'Av. Principal', '2024-08-01', '12:00 PM', true),
                  _buildRouteCard('Plaza Sur', '2024-08-01', '12:30 PM', false),
                  _buildRouteCard(
                      'Estación Central', '2024-08-01', '1:00 PM', true),
                  _buildRouteCard(
                      'Mercado Central', '2024-08-01', '1:30 PM', false),
                  _buildRouteCard('Calle 12', '2024-08-01', '2:00 PM', true),
                  _buildRouteCard(
                      'Parque Oeste', '2024-08-01', '2:30 PM', false),
                  _buildRouteCard(
                      'Av. Secundaria', '2024-08-01', '3:00 PM', true),
                  _buildRouteCard('Plaza Este', '2024-08-01', '3:30 PM', false),
                  _buildRouteCard(
                      'Terminal Norte', '2024-08-01', '4:00 PM', true),
                  _buildRouteCard('Calle 22', '2024-08-01', '4:30 PM', false),
                  _buildRouteCard(
                      'Parque Central', '2024-08-01', '5:00 PM', true),
                  _buildRouteCard(
                      'Centro Histórico', '2024-08-01', '5:30 PM', false),
                  _buildRouteCard(
                      'Estadio Municipal', '2024-08-01', '6:00 PM', true),
                  _buildRouteCard('Calle 30', '2024-08-01', '6:30 PM', false),
                  _buildRouteCard(
                      'Parque Industrial', '2024-08-01', '7:00 PM', true),
                  _buildRouteCard(
                      'Zona Franca', '2024-08-01', '7:30 PM', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard(
      String location, String date, String time, bool alarm) {
    return Card(
      child: ListTile(
        leading: Icon(
          alarm ? Icons.warning : Icons.location_on,
          color: alarm ? Colors.red : Colors.blue,
        ),
        title: Text(location),
        subtitle: Text('$date - $time'),
        trailing: Icon(
            alarm ? Icons.notification_important : Icons.check_circle,
            color: alarm ? Colors.red : Colors.green),
      ),
    );
  }
}
