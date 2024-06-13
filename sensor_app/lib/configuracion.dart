import 'package:flutter/material.dart';

class GeneralSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración General'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildSettingsOption(
            context,
            'Perfil',
            Icons.person,
            _buildProfileSection(),
          ),
          _buildSettingsOption(
            context,
            'Notificaciones',
            Icons.notifications,
            _buildNotificationsSection(),
          ),
          _buildSettingsOption(
            context,
            'Privacidad',
            Icons.lock,
            _buildPrivacySection(),
          ),
          _buildSettingsOption(
            context,
            'Idioma',
            Icons.language,
            _buildLanguageSection(),
          ),
          _buildSettingsOption(
            context,
            'Acerca de',
            Icons.info,
            _buildAboutSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context,
    String title,
    IconData icon,
    Widget content,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.teal, size: 30),
        title: Text(title, style: TextStyle(fontSize: 18, color: Colors.teal)),
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
