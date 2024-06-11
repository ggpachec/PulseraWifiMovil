import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'alertas.dart';

class TrackingSensorScreen extends StatefulWidget {
  @override
  _TrackingSensorScreenState createState() => _TrackingSensorScreenState();
}

class _TrackingSensorScreenState extends State<TrackingSensorScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _route = [];

  final LatLng _center = const LatLng(40.416775, -3.703790);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker(LatLng position) {
    setState(() {
      final marker = Marker(
        markerId: MarkerId(position.toString()),
        position: position,
      );
      _markers.add(marker);
      _route.add(position);

      _polylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: _route,
        color: Colors.blue,
        width: 5,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor de Seguimiento'),
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
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 12.0,
                ),
                markers: _markers,
                polylines: _polylines,
                onTap: _addMarker,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
