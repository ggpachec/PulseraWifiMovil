import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  final Set<BluetoothDevice> _devicesList = {}; // Use Set to avoid duplicates
  BluetoothConnection? _connection;
  final TextEditingController _textController = TextEditingController();

  BluetoothState get bluetoothState => _bluetoothState;
  List<BluetoothDevice> get devicesList => _devicesList.toList();
  TextEditingController get textController => _textController;

  Stream<BluetoothState> get bluetoothStateStream =>
      _bluetooth.onStateChanged();

  Future<void> init(BuildContext context) async {
    await _getBluetoothState(context);
    startDiscovery();
  }

  Future<void> _getBluetoothState(BuildContext context) async {
    _bluetoothState = await _bluetooth.state;
    if (_bluetoothState != BluetoothState.STATE_ON) {
      _showBluetoothDialog(context);
    }
  }

  void _showBluetoothDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bluetooth no está encendido'),
          content: Text('Por favor, encienda el Bluetooth para continuar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _bluetooth.requestEnable();
              },
              child: Text('Encender Bluetooth'),
            ),
          ],
        );
      },
    );
  }

  void startDiscovery() {
    _bluetooth.startDiscovery().listen((r) {
      _devicesList.add(r.device);
    }).onDone(() {
      // Optionally handle when discovery is done
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      print('Conectado al dispositivo ${device.name}');

      _connection!.input?.listen((Uint8List data) {
        final receivedData = String.fromCharCodes(data);
        print('Data recibida: $receivedData');
        _textController.text += '$receivedData\n';
      });
    } catch (e) {
      print('Error al conectar: $e');
    }
  }

  Future<void> closeConnection() async {
    await _connection?.close();
    _connection?.dispose();
    _textController.text = "";
  }

  Future<void> showDevicesDialog(
      BuildContext context, Function(BluetoothDevice) onDeviceSelected) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dispositivos encontrados...'),
          content: Container(
            width: double.minPositive,
            child: LimitedBox(
              maxHeight: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _devicesList.length,
                itemBuilder: (context, index) {
                  BluetoothDevice device = _devicesList.elementAt(index);
                  return ListTile(
                    title: Text(device.name ?? 'Unknown device'),
                    subtitle: Text(device.address.toString()),
                    onTap: () {
                      onDeviceSelected(device);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
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
}
