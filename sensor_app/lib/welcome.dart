import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/PANTALLA.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 2),
                Image.asset('lib/assets/images/LOGO.png', fit: BoxFit.cover), // Tamaño aumentado
                SizedBox(height: 20),
                Text(
                  'DoctorApp',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Open Sans',
                    color: Colors.white,
                  ),
                ),
                Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text('Iniciar Sesión',
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Open Sans',
                              color: Color(0xFF3F6BF4)),
                          ),
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/createAccount');
                        },
                        child: Text('Crear una cuenta',
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Open Sans',
                              color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          side: BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Spacer(flex: 2),
              ],
          ),
          ),
        ],
      ),
    );
  }
}
