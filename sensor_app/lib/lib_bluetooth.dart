import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothLib {
  late BluetoothDevice currentDev;
  late BluetoothService selectedService;

  late BluetoothCharacteristic serialRead;
  late BluetoothCharacteristic serialWrite;
  late String serialReadData;

  late BluetoothCharacteristic nettelRead;
  late BluetoothCharacteristic nettelWrite;
  late String nettelReadData;

  late String currentDev_Serial;
  late bool currentDev_Solar_lightsOn = false;
  late bool currentDev_Solar_alarmOn = false;

  bool isConnected_bySerialDevice(String serial) {
    bool isConn = false;
    print("isConnected_bySerialDevice:${currentDev.remoteId.str}");

    if (currentDev.remoteId.str != '-1') {
      isConn =
          (currentDev.platformName == serial || currentDev.advName == serial);
    }

    print("isConnected_bySerialDevice - isConn: $isConn");
    return isConn;
  }

  bool isConnected_currentDevice() {
    return currentDev.remoteId.str != '-1' && currentDev.isConnected;
  }

  Future<void> init() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    if (Platform.isAndroid) {
      WidgetsFlutterBinding.ensureInitialized();
      [
        Permission.location,
        Permission.storage,
        Permission.bluetooth,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.bluetoothAdvertise,
      ].request().then((status) {
        print(status);
      });
    }

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    await FlutterBluePlus.adapterState
        .map((s) {
          print(s);
          return s;
        })
        .where((s) => s == BluetoothAdapterState.on)
        .first;
  }

  Future<bool> init2() async {
    bool isInitialized = false;

    if (!await FlutterBluePlus.isSupported) {
      print("Bluetooth not supported by this device");
      return isInitialized;
    }

    if (Platform.isAndroid) {
      WidgetsFlutterBinding.ensureInitialized();
      final permissions = [
        Permission.location,
        Permission.storage,
        Permission.bluetooth,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.bluetoothAdvertise,
      ];

      final statuses = await permissions.request();

      statuses.forEach((permission, status) {
        if (!status.isGranted) {
          print('Permission $permission not granted');
          // Realizar acciones apropiadas si el permiso no está concedido
        }
      });
    }

    if (Platform.isAndroid) {
      try {
        await FlutterBluePlus.turnOn();
      } catch (e) {
        print('Error turning on Bluetooth: $e');
        // Manejar el error al encender el Bluetooth
        return isInitialized;
      }
    }

    await for (final state in FlutterBluePlus.adapterState) {
      print('Bluetooth adapter state: $state');
      if (state == BluetoothAdapterState.on) {
        isInitialized =
            true; // La inicialización se ha completado correctamente
        break; // Salir del bucle al alcanzar el estado deseado
      }
    }

    return isInitialized;
  }

  Future<BluetoothDevice?> findPairedDevice(String devSerial) async {
    // Obtener una lista de dispositivos vinculados
    List<BluetoothDevice> bondedDevices =
        await FlutterBluePlus.connectedDevices;

    // Buscar el dispositivo deseado en la lista de dispositivos vinculados
    for (BluetoothDevice device in bondedDevices) {
      print(device);
      if (device.advName == devSerial || device.platformName == devSerial) {
        return device; // Devolver el dispositivo si se encuentra
      }
    }

    return null; // Devolver null si no se encuentra el dispositivo vinculado
  }

  Future<bool> startSCAN(devSerial) async {
    var encontrado = false;
    var subscription;

    // Crear un Completer para resolver la futura promesa
    Completer<bool> completer = Completer<bool>();

    subscription = FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        //print(r.advertisementData);
        print(r.device);

        // Comprueba si manufacturerData contiene la clave 0x0C6A esto en decimal es 3178.
        //Asi llega {3178: [16, 56, 4]}
        if (r.advertisementData.manufacturerData.containsKey(3178)) {
          print(
              '${r.device.platformName} found! - ${r.device.remoteId} rssi: ${r.rssi}');
          if (r.device.platformName == devSerial ||
              r.device.advName == devSerial) {
            print('${devSerial} founded!!!');
            currentDev = r.device;
            currentDev_Serial = devSerial;
            encontrado = true;

            // Detener la búsqueda después de encontrar el dispositivo
            subscription.cancel();
            completer.complete(encontrado);
            break;
          }
        }
      }
      print('TERMINO FOR SCAN started');
    });

    print('SCAN started');
    FlutterBluePlus.startScan();

    // Establecer un temporizador para devolver false después de 7 segundos si no se ha encontrado el dispositivo
    Future.delayed(Duration(seconds: 7), () {
      if (!encontrado) {
        // No se encontró un dispositivo después de 7 segundos, devolver false
        subscription.cancel(); // Detener la búsqueda
        completer.complete(false);
      }
    });

    // Devolver la futura promesa
    print('RETURN DE START SCAN');
    return completer.future;
  }

  Future<bool> reconnect() async {
    if (currentDev == null || !currentDev.isConnected) {
      if (await init2()) {
        bool founded = await startSCAN(currentDev_Serial);
        await stopSCAN();
        if (founded) {
          if (await connectDev()) {
            //await configureDev();
            return true;
          }
        }
      }
    }

    return false;
  }

  Future<void> stopSCAN() async {
    print('SCAN stopped');
    await FlutterBluePlus.stopScan();
  }

  Future<void> writeSerial_modoTecnico(s) async {
    await nettelRead.setNotifyValue(false);
    await serialRead.setNotifyValue(true);

    await serialWrite.write(utf8.encode(s));
  }

  Future<void> writeSerial_modoNettel(s) async {
    await serialRead.setNotifyValue(false);
    await nettelRead.setNotifyValue(true);

    //print("currentDev.mtuNow " + currentDev.mtuNow.toString());

    await nettelWrite.write(utf8.encode(s));
  }

  Future<void> listCaracteristicas() async {
    print('listCaracteristicas');

    // Reads all characteristics
    var characteristics = selectedService.characteristics;
    print(selectedService);

    for (BluetoothCharacteristic c in characteristics) {
      print(c);

      if (c.uuid.toString() == '6e400002-b5a3-f393-e0a9-e50e24dcca9e') {
        //write
        serialWrite = c;
      }

      if (c.uuid.toString() == '6e400003-b5a3-f393-e0a9-e50e24dcca9e') {
        //read
        await c.setNotifyValue(true);
        //List<int> value = await c.read();
        //print(value);

        serialRead = c;
      }
    }
  }

  Future<void> listServicios() async {
    print('listServicios');

    List<BluetoothService> services = await currentDev.discoverServices();
    services.forEach((service) {
      print("${service.uuid}  ->>  ${service.remoteId}");
      if (service.uuid.toString() == '6e400001-b5a3-f393-e0a9-e50e24dcca9e') {
        selectedService = service;
      }
    });
  }

  Future<bool> connectDev() async {
    Completer<bool> completer = Completer<bool>();

    try {
      if (currentDev != null) {
        print("Conectando a ${currentDev.remoteId}");
        await currentDev.connect();

        if (currentDev.isConnected) {
          await currentDev.createBond();
        }
        completer.complete(true);
      } else {
        completer.complete(false);
      }
    } catch (e) {
      print(e.toString());
      completer.complete(false); // Si ocurre un error, devolver false
    }

    return completer.future;
  }

  Future<Map<String, dynamic>> readJSON_NettelMode(s) async {
    Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    print("RTN{1} - writeSerial_modoNettel: $s");
    await writeSerial_modoNettel(s);

    var subscription;
    subscription = nettelRead.lastValueStream.listen((value) {
      String result = utf8.decode(value);
      String rtn = result.trim();
      print(
          "----------------------------------->>>>>>>>>>>>>>>RTN{1} - readJSON_NettelMode: $rtn");

      // Intenta analizar el JSON para obtener el valor del IMEI
      try {
        completer.complete(jsonDecode(rtn));
      } catch (e) {
        completer.complete({});
      }

      // Cancela la suscripción una vez que se completa el Future
      subscription.cancel();
    });

    // Si no se obtiene el valor, se completa el Future con un valor predeterminado (en este caso, una cadena vacía)
    completer.future.then((value) {
      if (!completer.isCompleted) {
        completer.complete(null);
        subscription.cancel();
      }
    });

    return completer.future;
  }

  StreamController<Map<String, dynamic>> _nettelReadController =
      StreamController<Map<String, dynamic>>();
  Future<void> readJSON_NettelModeStream(String s) async {
    print("RTN{1} - readJSON_NettelModeStream: $s");
    await writeSerial_modoNettel(s);

    var subscription;
    subscription = nettelRead.lastValueStream.listen((value) {
      String result = utf8.decode(value);
      String rtn = result.trim();
      print(
          "----------------------------------->>>>>>>>>>>>>>>RTN{1} - readJSON_NettelModeStream: $rtn");

      // Intenta analizar el JSON para obtener el valor del IMEI
      try {
        _nettelReadController.add(jsonDecode(rtn));
      } catch (e) {
        _nettelReadController.add({});
      }

      // Uncomment the following line if you want to close the stream when the Future completes
      // subscription.cancel();
    });
  }
}
