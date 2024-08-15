import 'package:flutter/material.dart';
import 'package:sensor_app/alertas.dart';
import 'package:sensor_app/config_screen.dart';
import 'package:sensor_app/configuracion.dart';

class SensorsScreen extends StatefulWidget {
  @override
  _SensorsScreenState createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SensorsScreen(),
    LimitsConfigScreen(),
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Image.asset('lib/assets/images/21.png', height: 120),
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
                SizedBox(height: 30),
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
                  'Seguimiento',
                  'lib/assets/images/19.png',
                  '/tracking',
                  color: Colors.blue,
                ),
              ],
            ),
          ),
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
              icon: ImageIcon(AssetImage('lib/assets/images/20.png')),
              label: 'Limites',
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

  Widget _buildSensorButton(
    BuildContext context,
    String title,
    String iconPath,
    String route, {
    Color color = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child :ElevatedButton.icon(
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
        )
      ),
    );
  }
}
