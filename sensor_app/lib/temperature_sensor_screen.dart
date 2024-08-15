import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sensor_app/alertas.dart';
import 'package:sensor_app/auth_service.dart';
import 'package:sensor_app/config_screen.dart';
import 'package:sensor_app/configuracion.dart';
import 'package:sensor_app/sensors.dart';
import 'api_service.dart';

class TemperatureSensorScreen extends StatefulWidget {
  @override
  _TemperatureSensorScreenState createState() =>
      _TemperatureSensorScreenState();
}

class _TemperatureSensorScreenState extends State<TemperatureSensorScreen> {
  // Add a counter
  int _recordCounter = 0;
  final int _recordThreshold =
      25; // Change to the number of records you want to skip

  final ApiService apiService = ApiService(); // Instance of ApiService
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  List<BluetoothDevice> _devicesList = [];
  BluetoothConnection? _connection;
  TextEditingController _textController = TextEditingController();
  List<String> _dataList = [];
  bool _isDiscovering = false;
  String _buffer = '';

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SensorsScreen(),
    LimitsConfigScreen(),
    AlertsScreen(),
    GeneralSettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to the selected page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  void initState() {
    super.initState();
    _bluetooth.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });

      if (state == BluetoothState.STATE_OFF) {
        _showBluetoothDialog();
      }
    });

    _bluetooth.onStateChanged().listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
      if (state == BluetoothState.STATE_ON) {
        _startDiscovery();
      } else if (state == BluetoothState.STATE_OFF) {
        _showBluetoothDialog();
      }
    });

    if (_bluetoothState == BluetoothState.STATE_ON) {
      _startDiscovery();
    }
  }

  void _showBluetoothDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bluetooth is not turned on'),
          content: Text('Please turn on Bluetooth to continue.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _bluetooth.requestEnable();
              },
              child: Text('Turn on Bluetooth'),
            ),
          ],
        );
      },
    );
  }

  void _startDiscovery() {
    setState(() {
      _isDiscovering = true;
      _devicesList.clear();
    });

    _bluetooth.startDiscovery().listen((r) {
      setState(() {
        final device = r.device;
        if (!_devicesList.any((d) => d.address == device.address)) {
          _devicesList.add(device);
        }
      });
    }).onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      print('Connected to the device ${device.name}');

      _connection!.input?.listen((Uint8List data) {
        final receivedData = String.fromCharCodes(data);
        print('Data received: $receivedData');
        setState(() {
          _buffer += receivedData;
          int index;
          while ((index = _buffer.indexOf('\n')) != -1) {
            String line = _buffer.substring(0, index).trim();
            _buffer = _buffer.substring(index + 1);
            if (line.isNotEmpty) {
              _dataList.add(line);
              _sendDataToApi(
                  double.parse(line.split('=')[1])); // Send data to API
            }
          }
        });
      });
    } catch (e) {
      print('Error connecting: $e');
    }
  }

  Future<void> _sendDataToApi(double data) async {
    final id = await AuthService.getPatient();
    Map<String, dynamic> newData = {
      "fecha": DateTime.now().toIso8601String().split('T').first,
      "hora": DateTime.now().toIso8601String().split('T').last.split('.').first,
      "medicion": data,
      "servicio": 5, // Temperature
      "paciente": id['id']
    };

    try {
      // Increment the counter
      _recordCounter++;

      // Save only when the counter reaches the threshold
      if (_recordCounter >= _recordThreshold) {
        await apiService.createData('detalleServicio', newData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data sent successfully')),
        );

        // Reset the counter
        _recordCounter = 0;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending data: $e')),
      );
    }
  }

  Future<void> _closeConnection() async {
    await _connection?.close();
    _connection?.dispose();
    setState(() {
      _textController.text = "";
      _dataList = [];
      _buffer = '';
    });
  }

  void _showDeviceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Devices found...'),
              content: Container(
                width: double.minPositive,
                child: LimitedBox(
                  maxHeight: 200,
                  child: _isDiscovering
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _devicesList.length,
                          itemBuilder: (context, index) {
                            BluetoothDevice device = _devicesList[index];
                            return ListTile(
                              title: Text(device.name ?? 'Unknown device'),
                              subtitle: Text(device.address.toString()),
                              onTap: () {
                                _connectToDevice(device);
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
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Temperature Sensor',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Open Sans',
          ),
        ),
        backgroundColor: Color(0xFF3F6BF4),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _startDiscovery,
                  child: Text('Update Status'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF0000),
                    textStyle: TextStyle(
                      fontFamily: 'Open Sans',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _closeConnection,
                  child: Text('Close Connection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF0000),
                    textStyle: TextStyle(
                      fontFamily: 'Open Sans',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showDeviceDialog,
              child: Text('Connect Device'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3F6BF4),
                textStyle: TextStyle(
                  fontFamily: 'Open Sans',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0xFF1E90FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Bluetooth Status: ${_bluetoothState == BluetoothState.STATE_ON ? "Connected" : "Disconnected"}',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Open Sans',
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: _dataList.map((data) {
                      return ListTile(
                        leading:
                            Icon(Icons.brightness_1, color: Color(0xFF1E90FF)),
                        title: Text(
                          data,
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                          ),
                        ),
                        trailing: Text(
                          "${DateTime.now().hour}:${DateTime.now().minute} h",
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3F6BF4), Color(0xFF1E90FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/12.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/20.png')),
              label: 'Limits',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/14.png')),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/15.png')),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connection?.dispose(); // Ensure the connection is closed properly
    super.dispose();
  }
}
