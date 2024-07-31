import 'package:flutter/material.dart';

class GeneralSettingsScreen extends StatelessWidget {
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
                Image.asset(
                  'lib/assets/images/LOGO2.png', // Ruta del logo
                  height: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'Configuración General',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/calendar.png')),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/notifications.png')),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/profile.png')),
            label: 'Perfil',
          ),
        ],
        selectedItemColor: Color(0xFF3F6BF4),
        unselectedItemColor: Color(0XFFF5F5F6),
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
        leading: ImageIcon(AssetImage(iconPath), color: Colors.black, size: 30),
        title: Text(title, style: TextStyle(fontSize: 18, color: Colors.black)),
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
          Text('Nombre: Genesis Pacheco', style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text('Email: genesis.pacheco@gmail.com',
              style: TextStyle(fontSize: 16)),
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
          Text('Desarrollado por: Paula Peralta',
              style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
