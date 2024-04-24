import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingScreen extends StatefulWidget {
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late GoogleMapController mapController;
  Set<Polyline> _polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _startTracking() {
    // Simular inicio de seguimiento
    // Aquí se agregaría lógica para obtener la ubicación en tiempo real y actualizar el mapa
  }

  void _stopTracking() {
    // Simular detención de seguimiento
    // Aquí se detendría la obtención de ubicación en tiempo real
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracking Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              polylines: _polylines,
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 15.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _startTracking,
                  child: Text('Comenzar seguimiento'),
                ),
                ElevatedButton(
                  onPressed: _stopTracking,
                  child: Text('Detener seguimiento'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
