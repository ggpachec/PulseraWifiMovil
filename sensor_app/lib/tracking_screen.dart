import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingScreen extends StatefulWidget {
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late GoogleMapController mapController;
  List<LatLng> points = []; // Lista de puntos para trazar la ruta
  Set<Polyline> polylines =
      {}; // Conjunto de polilíneas para mostrar en el mapa

  void startTracking() {
    // Simulación de inicio de seguimiento
    // En un uso real, aquí se conectaría al sensor GPS y se registrarían los datos
  }

  void stopTracking() {
    // Simulación de parada de seguimiento
    // En un uso real, aquí se detendría la conexión al sensor GPS y el registro de datos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguimiento'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            polylines: polylines,
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0), // Posición inicial del mapa
              zoom: 15.0, // Zoom inicial del mapa
            ),
          ),
          Positioned(
            top: 70,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seguimiento en tiempo real',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: startTracking,
                  child: Text('Comenzar seguimiento'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: stopTracking,
                  child: Text('Parar seguimiento'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
