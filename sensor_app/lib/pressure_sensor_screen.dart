import 'package:flutter/material.dart';
import 'alertas.dart';

class PressureSensorScreen extends StatefulWidget {
  @override
  _PressureSensorScreenState createState() => _PressureSensorScreenState();
}

class _PressureSensorScreenState extends State<PressureSensorScreen> {
  List<Map<String, String>> _data = [];

  @override
  void initState() {
    super.initState();
    _simulateData();
  }

  void _simulateData() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _data.add({'value': '120/80 mmHg', 'time': '14:03 h'});
      });
      _simulateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor de Presión'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/alerts');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Actualizar Estado'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Cerrar Conexión'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Estado Bluetooth: State_ON',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.brightness_1, color: Colors.teal),
                      title: Text(_data[index]['value']!),
                      trailing: Text(_data[index]['time']!),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
