import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class TemperatureSensorScreen extends StatefulWidget {
  @override
  _TemperatureSensorScreenState createState() =>
      _TemperatureSensorScreenState();
}

class _TemperatureSensorScreenState extends State<TemperatureSensorScreen> {
  String sensorData = '';
  //FlutterBlue flutterBlue = null;
  BluetoothDevice? selectedDevice;

  void connectToSensor() async {
    try {
      /*var scanSubscription = flutterBlue.scanResults.listen((results) {
        for (ScanResult r in results) {
          if (r.device.name == 'NombreDeTuDispositivo') {
            selectedDevice = r.device;
            break;
          }
        }
      });

      flutterBlue.startScan();
      await Future.delayed(Duration(seconds: 4));
      await flutterBlue.stopScan();
      scanSubscription.cancel();*/

      if (selectedDevice != null) {
        await selectedDevice!.connect();
        List<BluetoothService> services =
            await selectedDevice!.discoverServices();
        for (BluetoothService service in services) {
          if (service.uuid.toString() ==
              '0000180f-0000-1000-8000-00805f9b34fb') {
            List<BluetoothCharacteristic> characteristics =
                service.characteristics;
            for (BluetoothCharacteristic characteristic in characteristics) {
              if (characteristic.uuid.toString() ==
                  '00002a6e-0000-1000-8000-00805f9b34fb') {
                await characteristic.setNotifyValue(true);
                characteristic.value.listen((value) {
                  setState(() {
                    sensorData = value.toString();
                  });
                });
              }
            }
          }
        }
      } else {
        setState(() {
          sensorData = 'Dispositivo no encontrado';
        });
      }
    } catch (e) {
      setState(() {
        sensorData = 'Error: $e';
      });
    }
  }

  void clearData() {
    setState(() {
      sensorData = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor de Temperatura'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text(
              'Sensor de Temperatura',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: connectToSensor,
            child: Text('Conectar'),
          ),
          ElevatedButton(
            onPressed: clearData,
            child: Text('Limpiar'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(sensorData),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
