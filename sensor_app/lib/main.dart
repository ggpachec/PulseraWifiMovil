import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> _devicesList = [];

  BluetoothConnection? _connection;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _getBluetoothState();
    _startDiscovery();
  }

  void _getBluetoothState() {
    _bluetooth.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  void _startDiscovery() {
    _bluetooth.startDiscovery().listen((r) {
      setState(() {
        if (!_devicesList.contains(r.device)) {
          _devicesList.add(r.device);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Estado del Bluetooth: $_bluetoothState'),
            ElevatedButton(
              onPressed: _init,
              child: const Text('Actualizar Estado'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _closeConection,
              child: const Text('Cerrar Conexion'),
            ),
            SizedBox(height: 20),
            Text('Dispositivos Encontrados:'),
            Expanded(
              child: ListView.builder(
                itemCount: _devicesList.length,
                itemBuilder: (context, index) {
                  BluetoothDevice device = _devicesList[index];
                  return ListTile(
                    title: Text(device.name ?? 'Unknown device'),
                    subtitle: Text(device.address.toString()),
                    onTap: () {
                      _connectToDevice(device);
                    },
                  );
                },
              ),
            ),
            SingleChildScrollView(
              child: TextFormField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines:
                    null, // Permite que el TextArea tenga múltiples líneas
                readOnly: true, // Hace que el TextArea sea de solo lectura
                decoration: InputDecoration(
                  hintText: 'Datos recibidos',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _connectToDevice(device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      print('Conectado al dispositivo ${device.name}');

      _connection!.input?.listen((Uint8List data) {
        final receivedData = String.fromCharCodes(data);
        print('Data recibida: $receivedData');
        setState(() {
          _textController.text +=
              receivedData + '\n'; // Agrega el texto recibido al TextArea
        });
      });
    } catch (e) {
      print('Error al conectar: $e');
    }
  }

  void _closeConection() async {
    _connection?.close();
    _connection?.dispose();

    setState(() {
      _textController.text = "";
    });
  }

  @override
  void dispose() {
    _connection?.dispose(); // Asegura que la conexión se cierre correctamente
    super.dispose();
  }
}

/*import 'package:flutter/material.dart';
import '../lib_bluetooth.dart';

BluetoothLib objBlueGlobal = BluetoothLib();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  proceso();
                },
                child: Text('Bluetooth'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void proceso() async {
  bool activated = await objBlueGlobal.init2();
  if (activated) {
    String devSerial = "";
    var subscription;

    bool founded = await objBlueGlobal.startSCAN(devSerial);
    await objBlueGlobal.stopSCAN();

    if (founded) {
      print("ENCONTRADO: " + objBlueGlobal.currentDev.platformName);
      await objBlueGlobal.connectDev();
    } else {
      print("NO SE ENCONTRO DISPOSITIVO");
    }
  }
}*/
