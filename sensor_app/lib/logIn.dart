import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      // Procesar el inicio de sesión
      Navigator.pushReplacementNamed(context, '/sensors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/PANTALLA.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  //Icon(Icons.favorite, size: 100, color: Colors.teal),
                  Image.assets('assets/images/LOGO2.png', height: 100),
                  SizedBox(height: 10),
                  Text(
                    '¡Bienvenido!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Open Sans'
                        color: Color(0xFF000000)),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft, 
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Open Sans', 
                          color: Color(0XFF3F6BF4))),
                  ),
                  SizedBox(height: 7),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset('assets/images/01.png'),
                      labelText: 'Nombre de Usuario',
                      border: UnderlineInputBorder(),
                    ),
                    validator: _validateUsername,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset('assets/images/02.png'),
                      labelText: 'Correo Electrónico',
                      border: UnderlineInputBorder(),
                    ),
                    validator: _validateEmail,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset('assets/images/03.png'),
                      labelText: 'Contraseña',
                      suffixIcon: Image.asset('assets/images/04.png'),
                      border: UnderlineInputBorder(),
                    ),
                    validator: _validatePassword,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 200, 
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text('Iniciar sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF4F4F5), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ), 
                  Align(
                    alignment: Alignment.centerRight, 
                    child: SizedBox(
                      width: 200, 
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgotPassword');
                        },
                        child: Text('¿Olvidaste tu contraseña?',
                            style: TextStyle(color: Color(0XFF767676)),
                        ),
                      ),
                    ),  
                  ),
                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/createAccount');
                    },
                    child: Text('¿No tienes una cuenta?',
                        style: TextStyle(color: Color(0xFFF4F4F5)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
