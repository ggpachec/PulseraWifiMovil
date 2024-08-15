import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> savePatient(int id, String username, String email, String first_name, String last_name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', id);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('first_name', first_name);
    await prefs.setString('last_name', last_name);
  }

  static Future<Map<String, dynamic>> getPatient() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt('id'),
      'username': prefs.getString('username'),
      'email':prefs.getString('email'),
      'first_name': prefs.getString('first_name'),
      'last_name':prefs.getString('last_name'),     
    };
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  static Future<bool> isLoggedIn() async {
  final token = await getToken();
  return token != null;
}
}
