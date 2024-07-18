import 'package:flutter/material.dart';

class AlertsScreen extends StatefulWidget {
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedFilter = 'Todos';
  final List<Map<String, String>> _alerts = [
    {
      'type': 'Emergencia Extrema',
      'description': 'Presión arterial alta: 160 mmHg',
      'color': '0xffFFCDD2'
    },
    {
      'type': 'Emergencia Moderada',
      'description': 'Temperatura corporal baja:',
      'color': '0xffC8E6C9'
    },
    {
      'type': 'Recordatorio',
      'description': 'Saturación de oxígeno alta: 98%',
      'color': '0xffFFECB3'
    },
    {
      'type': 'Emergencia Extrema',
      'description': 'Presión arterial alta: 160 mmHg',
      'color': '0xffFFCDD2'
    },
    {
      'type': 'Emergencia Moderada',
      'description': 'Temperatura corporal baja:',
      'color': '0xffC8E6C9'
    },
    {
      'type': 'Recordatorio',
      'description': 'Saturación de oxígeno alta: 98%',
      'color': '0xffFFECB3'
    },
  ];

  List<Map<String, String>> get _filteredAlerts {
    if (_selectedFilter == 'Todos') {
      return _alerts;
    }
    return _alerts.where((alert) => alert['type'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.notifications),
        title: Text('Alertas y Notificaciones'),
        //backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
              },
              items: <String>[
                'Todos',
                'Emergencia Extrema',
                'Emergencia Moderada',
                'Recordatorio'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredAlerts.length,
                itemBuilder: (context, index) {
                  final alert = _filteredAlerts[index];
                  return Card(
                    color: Color(int.parse(alert['color']!)),
                    child: ListTile(
                      leading: Icon(
                        alert['type'] == 'Emergencia Extrema'
                            ? Icons.warning
                            : alert['type'] == 'Emergencia Moderada'
                                ? Icons.error_outline
                                : Icons.notifications,
                        color: Colors.black,
                      ),
                      title: Text(alert['type']!),
                      subtitle: Text(alert['description']!),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.teal),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
