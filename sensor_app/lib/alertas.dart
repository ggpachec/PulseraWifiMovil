import 'package:flutter/material.dart';
import 'package:sensor_app/configuracion.dart';
import 'package:sensor_app/sensors.dart';

class AlertsScreen extends StatefulWidget {
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedFilter = 'Emergencias Extremas';
  final List<Map<String, String>> _alerts = [
    {
      'type': 'Emergencias Extremas',
      'description': 'Bluetooth para continuar',
      'color': '0xffFFCDD2'
    },
    {
      'type': 'Emergencia Moderada',
      'description': 'Temperatura corporal baja',
      'color': '0xffC8E6C9'
    },
    {
      'type': 'Recordatorios',
      'description': 'Saturación de oxígeno alta: 98%',
      'color': '0xffFFECB3'
    },
    {
      'type': 'Emergencias Extremas',
      'description': 'Bluetooth para continuar',
      'color': '0xffFFCDD2'
    },
    {
      'type': 'Emergencia Moderada',
      'description': 'Temperatura corporal baja',
      'color': '0xffC8E6C9'
    },
    {
      'type': 'Recordatorios',
      'description': 'Saturación de oxígeno alta: 98%',
      'color': '0xffFFECB3'
    },
  ];

  List<Map<String, String>> get _filteredAlerts {
    return _alerts.where((alert) => alert['type'] == _selectedFilter).toList();
  }

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SensorsScreen(),
    CalendarScreen(),
    AlertsScreen(),
    GeneralSettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navegar a la página seleccionada
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text(
          'Alerta y Notificaciones',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'BUSCAR',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.filter_list, color: Colors.grey),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterButton('Emergencias Extremas'),
                _buildFilterButton('Emergencia Moderada'),
                _buildFilterButton('Recordatorios'),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredAlerts.length,
                itemBuilder: (context, index) {
                  final alert = _filteredAlerts[index];
                  return Card(
                    color: Color(int.parse(alert['color']!)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Icon(
                        alert['type'] == 'Emergencias Extremas'
                            ? Icons.warning
                            : alert['type'] == 'Emergencia Moderada'
                                ? Icons.info_outline
                                : Icons.notifications,
                        color: Colors.black,
                      ),
                      title: Text(alert['type']!,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(alert['description']!),
                      trailing: Icon(Icons.delete, color: Colors.black),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3F6BF4), Color(0xFF1E90FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/12.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/13.png')),
              label: 'Calendario',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/14.png')),
              label: 'Notificaciones',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/15.png')),
              label: 'Perfil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  Widget _buildFilterButton(String title) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = title;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _selectedFilter == title ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: _selectedFilter == title ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// Define las pantallas a las que quieres navegar

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Calendar Screen')),
    );
  }
}

