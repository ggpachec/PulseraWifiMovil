import 'package:flutter/material.dart';

class AlertsScreen extends StatefulWidget {
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int _selectedIndex = 2; // Index for the Alerts screen in the navigation bar
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the selected page
    // Navigator.push(context, MaterialPageRoute(builder: (context) => _pages[index]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Alerta y Notificaciones',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.blue),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'BUSCAR',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterButton('Emergencias Extremas'),
                _buildFilterButton('Emergencia Moderada'),
                _buildFilterButton('Recordatorios'),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredAlerts.length,
                itemBuilder: (context, index) {
                  final alert = _filteredAlerts[index];
                  return Card(
                    color: Color(int.parse(alert['color']!)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(
                        alert['type'] == 'Emergencias Extremas'
                            ? Icons.warning
                            : alert['type'] == 'Emergencia Moderada'
                                ? Icons.info
                                : Icons.notifications,
                        color: Colors.black,
                      ),
                      title: Text(
                        alert['type']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(alert['description']!),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Handle delete action
                        },
                      ),
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
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: BottomNavigationBar(
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
          unselectedItemColor: Color(0xFF000000),
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
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
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: _selectedFilter == title ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: _selectedFilter == title ? Colors.white : Colors.black,
                fontWeight: _selectedFilter == title
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
