import 'package:http/http.dart' as http;
import 'package:sensor_app/auth_service.dart';
import 'dart:convert';


class ApiService {
  final String baseUrl = 'https://monitoreodoc.pythonanywhere.com/api/';

  Future<List<Map<String, dynamic>>> fetchAlerts() async {
    final id = await AuthService.getPatient();

    final response = await http.get(
      Uri.parse('$baseUrl/alertas/'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<Map<String, dynamic>> alerts = jsonResponse.map((data) {
        return {
          'id': data['id'],
          'nombre': data['nombre'],
          'mensaje': data['mensaje'],
          'fechaCreacion': data['fechaCreacion'],
          'activa': data['activa'],
          'idPaciente': id,
          'tipoAlerta': data['tipoAlerta'],
        };
      }).toList();
      return alerts;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createData(String endpoint, Map<String, dynamic> newData) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create data');
    }
  }

  Future<void> updateData(String endpoint, int id, Map<String, dynamic> updatedData) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedData),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update data');
    }
  }

  Future<void> deleteData(String endpoint, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint/$id/'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete data');
    }
  }
  
  
  Future<Map<String, dynamic>> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['rol'] == 3) {
        return {'rol': data['rol'],
                'auth_token': data['auth_token']};
      } else {
        throw Exception('Rol no permitido');
      }
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }


  Future<void> registerUser(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register/'), // Cambia a la URL de registro si existe.
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al registrar usuario');
    }
  }
}
