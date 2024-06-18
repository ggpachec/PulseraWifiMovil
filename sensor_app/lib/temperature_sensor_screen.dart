import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'bluetooth_service.dart';

class TemperatureSensorScreen extends StatefulWidget {
  @override
  _TemperatureSensorScreenState createState() =>
      _TemperatureSensorScreenState();
}

class _TemperatureSensorScreenState extends State<TemperatureSensorScreen> {
  final BluetoothService _bluetoothService = BluetoothService();
  List<String> _dataList = [];

  @override
  void initState() {
    super.initState();
    _bluetoothService.init();
  }

  void _showDeviceDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Dispositivos encontrados...'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _bluetoothService.devicesList.length,
              itemBuilder: (context, index) {
                BluetoothDevice device = _bluetoothService.devicesList[index];
                return ListTile(
                  title: Text(device.name ?? 'Unknown device'),
                  subtitle: Text(device.address.toString()),
                  onTap: () async {
                    await _bluetoothService.connectToDevice(device);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor de Temperatura'),
        backgroundColor: Colors.teal,
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
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/generalSettings');
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
                  onPressed: _bluetoothService.init,
                  child: Text('Actualizar Estado'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
                ElevatedButton(
                  onPressed: _bluetoothService.closeConnection,
                  child: Text('Cerrar Conexión'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showDeviceDialog,
              child: Text('Conectar Dispositivo'),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Estado Bluetooth: ${_bluetoothService.bluetoothState == BluetoothState.STATE_ON ? "Conectado" : "Desconectado"}',
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
                  itemCount: _dataList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.brightness_1, color: Colors.teal),
                      title: Text(_dataList[index]),
                      trailing: Text(
                        "${DateTime.now().hour}:${DateTime.now().minute} h",
                      ),
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
