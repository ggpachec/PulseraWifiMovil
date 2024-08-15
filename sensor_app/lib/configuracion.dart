import 'package:flutter/material.dart';
import 'package:sensor_app/alertas.dart';
import 'package:sensor_app/auth_service.dart';
import 'package:sensor_app/config_screen.dart';
import 'package:sensor_app/sensors.dart';

class GeneralSettingsScreen extends StatefulWidget {
  @override
  _GeneralSettingsScreenState createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _username = '';
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SensorsScreen(), // Define tus pantallas aquí
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
  void initState() {
    super.initState();
    _fetchPatientData();
  }

  Future<void> _fetchPatientData() async {
    final patientData = await AuthService.getPatient();
    
    // Suponiendo que `patientData` es un mapa con las claves 'first_name', 'last_name', y 'email'
    setState(() {
      _firstName = patientData['first_name'] ?? '';
      _lastName = patientData['last_name'] ?? '';
      _email = patientData['email'] ?? '';
      _username = patientData['username'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Color de fondo blanco
      appBar: AppBar(
        backgroundColor: Colors.white, // Fondo blanco
        elevation: 0, // Sin sombra
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black), // Icono de menú en negro
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                Image.asset('lib/assets/images/LOGO2.png', height: 180),
                SizedBox(height: 10),
                Text(
                  'Configuración General',
                  style: TextStyle(
                    fontSize:24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Open Sans',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildSettingsOption(
                  context,
                  'Perfil',
                  'lib/assets/images/06.png',
                  _buildProfileSection(),
                ),
                _buildSettingsOption(
                  context,
                  'Notificaciones',
                  'lib/assets/images/07.png',
                  _buildNotificationsSection(),
                ),
                _buildSettingsOption(
                  context,
                  'Privacidad',
                  'lib/assets/images/08.png',
                  _buildPrivacySection(),
                ),
                _buildSettingsOption(
                  context,
                  'Idioma',
                  'lib/assets/images/09.png',
                  _buildLanguageSection(),
                ),
                _buildSettingsOption(
                  context,
                  'Acerca de',
                  'lib/assets/images/10.png',
                  _buildAboutSection(),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildSettingsOption(
    BuildContext context,
    String title,
    String iconPath,
    Widget content,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        leading: ImageIcon(AssetImage(iconPath), color: Colors.black, size: 25),
        title: Text(title, style: TextStyle(fontSize: 20, color: Colors.black)),
        children: [content],
      ),
    );
  }


  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre: $_firstName $_lastName', style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text('Username: $_username', style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text('Email: $_email', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text('Notificaciones por correo',
                style: TextStyle(fontSize: 16)),
            value: true,
            onChanged: (bool value) {},
          ),
          SwitchListTile(
            title: Text('Notificaciones push', style: TextStyle(fontSize: 16)),
            value: false,
            onChanged: (bool value) {},
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contraseña: ********', style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Acción para cambiar contraseña
            },
            child: Text('Cambiar Contraseña'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Idioma actual: Español', style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          DropdownButton<String>(
            items: <String>['Español', 'Inglés'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Versión: 1.0.0', style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text('Desarrollado por: Equipo Pulseras Wifi',
              style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
