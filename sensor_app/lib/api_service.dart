import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'https://monitoreodoc.pythonanywhere.com/api/';

  Future<List> fetchData() async {
    final response = await http.get(
      Uri.parse('${baseUrl}detalleServicio/'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createData(Map<String, dynamic> newData) async {
    final response = await http.post(
      Uri.parse('${baseUrl}detalleServicio/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create data');
    }
  }
}
