import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su nombre de usuario';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su correo electrónico';
    }
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Por favor ingrese un correo electrónico válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su contraseña';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value) ||
        !RegExp(r'[0-9]').hasMatch(value)) {
      return 'La contraseña debe contener letras y números';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      // Procesar el registro
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, size: 100, color: Colors.teal),
                SizedBox(height: 20),
                Text(
                  'Crear Cuenta',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Nombre de usuario',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  validator: _validateUsername,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  validator: _validateEmail,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  validator: _validatePassword,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Repetir Contraseña',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  validator: _validateConfirmPassword,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Registrar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
