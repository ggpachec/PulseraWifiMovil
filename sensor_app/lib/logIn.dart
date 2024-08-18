import 'package:flutter/material.dart';
import 'api_service.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService apiService = ApiService();  // Instancia de ApiService
  
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su nombre de usuario';
    }
    if (value.length < 5) {
      return 'El nombre de usuario debe tener al menos 5 caracteres';
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

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Realizar el inicio de sesión usando ApiService
        final response = await apiService.loginUser(
          _usernameController.text,
          _passwordController.text,
        );

        // Verificar el rol en la respuesta
        if (response['rol'] == 3) {
          // Guardar el token en AuthService
          await AuthService.saveToken(response['auth_token']);
          await AuthService.savePatient(response['id'],response['username'],response['email'],response['first_name'],response['last_name']);
          

          // Mostrar un mensaje de éxito y redirigir a la pantalla de sensores
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Inicio de sesión exitoso')),
          // );
          Navigator.pushReplacementNamed(context, '/sensors');
        } else {
          // Mostrar mensaje de error si el rol no es 3
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario no autorizado')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $e')),
        );
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Image.asset('lib/assets/images/LOGO22.png', height: 180),
                SizedBox(height: 10),
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Open Sans',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans',
                      color: Color(0xFF3F6BF4),
                    ),
                  ),
                ),
                SizedBox(height: 7),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('lib/assets/images/01.png',
                          width: 30, height: 30),
                    ),
                    labelText: 'Nombre de Usuario',
                    border: UnderlineInputBorder(),
                  ),
                  validator: _validateUsername,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('lib/assets/images/02.png',
                          width: 30, height: 30),
                    ),
                    labelText: 'Correo Electrónico',
                    border: UnderlineInputBorder(),
                  ),
                  validator: _validateEmail,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('lib/assets/images/03.png',
                          width: 30, height: 30),
                    ),
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    border: UnderlineInputBorder(),
                  ),
                  validator: _validatePassword,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    child:
                        Text('Iniciar sesión', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3F6BF4),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgotPassword');
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                          color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/createAccount');
                  },
                  child: Text(
                    '¿No tienes una cuenta?',
                    style: TextStyle(
                        color: Color(0xFF3F6BF4),
                        fontSize: 18,
                        fontStyle: FontStyle.italic),
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
