import 'package:flutter/material.dart';
import 'package:sensor_app/alertas.dart';
import 'package:sensor_app/configuracion.dart';

class SensorsScreen extends StatefulWidget {
  @override
  _SensorsScreenState createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SensorsScreen(), // Define tus pantallas aquí
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Image.asset('lib/assets/images/21.png', height: 180),
              SizedBox(height: 10),
              Text(
                'Sensores',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Open Sans',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              _buildSensorButton(
                context,
                'Sensor de Temperatura',
                'lib/assets/images/16.png',
                '/temperature',
              ),
              _buildSensorButton(
                context,
                'Sensor de Presión',
                'lib/assets/images/17.png',
                '/pressure',
              ),
              _buildSensorButton(
                context,
                'Sensor de Saturación',
                'lib/assets/images/18.png',
                '/saturation',
              ),
              _buildSensorButton(
                context,
                'Sensor de Seguimiento',
                'lib/assets/images/19.png',
                '/tracking',
              ),
              _buildSensorButton(
                context,
                'Configuración de Límites',
                'lib/assets/images/20.png',
                '/config',
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
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
        selectedItemColor: Color(0xFF3F6BF4),
        unselectedItemColor: Color(0XFF000000),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSensorButton(
    BuildContext context,
    String title,
    String iconPath,
    String route, {
    Color color = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: ElevatedButton.icon(
        icon: ImageIcon(AssetImage(iconPath), size: 32, color: Colors.white),
        label: Text(title, style: TextStyle(fontSize: 18, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}

// Define las pantallas a las que quieres navegar
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Home Screen')),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Calendar Screen')),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Notifications Screen')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Profile Screen')),
    );
  }
}
