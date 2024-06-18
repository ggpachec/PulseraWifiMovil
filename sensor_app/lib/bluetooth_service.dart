import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  final List<BluetoothDevice> _devicesList = [];
  BluetoothConnection? _connection;
  final TextEditingController _textController = TextEditingController();

  BluetoothState get bluetoothState => _bluetoothState;
  List<BluetoothDevice> get devicesList => _devicesList;
  TextEditingController get textController => _textController;

  Future<void> init() async {
    _getBluetoothState();
    _startDiscovery();
  }

  Future<void> _getBluetoothState() async {
    _bluetoothState = await _bluetooth.state;
  }

  void _startDiscovery() {
    _bluetooth.startDiscovery().listen((r) {
      if (!_devicesList.contains(r.device)) {
        _devicesList.add(r.device);
      }
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
}
