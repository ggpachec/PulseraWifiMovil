import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class TrackingScreen extends StatefulWidget {
  @override
  _TrackingSensorScreenState createState() => _TrackingSensorScreenState();
}

class _TrackingSensorScreenState extends State<TrackingScreen> {
  late GoogleMapController _mapController;
  Position? _currentPosition;
  bool _isTracking = false;
  List<LatLng> _route = [];
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  void _getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;

      // Añadimos marcadores de lugares clave
      _addKeyLocations();

      // Añadimos los cercos a los lugares clave
      _addGeofences();
    });
  }

  void _addKeyLocations() {
    // Lugares clave
    LatLng homeLocation = LatLng(-2.147856, -79.964593); // Ejemplo: hogar
    LatLng centerLocation = LatLng(-2.189402, -79.889067); // Ejemplo: centro

    // Marcadores
    _markers.add(Marker(
      markerId: MarkerId('homeLocation'),
      position: homeLocation,
      infoWindow: InfoWindow(title: 'Hogar'),
    ));

    _markers.add(Marker(
      markerId: MarkerId('centerLocation'),
      position: centerLocation,
      infoWindow: InfoWindow(title: 'Centro de la Ciudad'),
    ));

    // Ruta inicial (ESPOCH -> Centro)
    _route.add(LatLng(-2.146640, -79.967113)); // ESPOCH
    _route.add(centerLocation); // Centro
  }

  void _addGeofences() {
    // Cercos alrededor de los lugares clave
    _circles.add(Circle(
      circleId: CircleId('homeGeofence'),
      center: LatLng(-2.147856, -79.964593),
      radius: 100, // 100 metros de radio
      fillColor: Colors.orange.withOpacity(0.3),
      strokeColor: Colors.orange,
      strokeWidth: 2,
    ));

    _circles.add(Circle(
      circleId: CircleId('centerGeofence'),
      center: LatLng(-2.189402, -79.889067),
      radius: 100, // 100 metros de radio
      fillColor: Colors.orange.withOpacity(0.3),
      strokeColor: Colors.orange,
      strokeWidth: 2,
    ));

    // Cerco alrededor de la ruta general
    _circles.add(Circle(
      circleId: CircleId('routeGeofence'),
      center: LatLng(-2.1683, -79.9267), // Centro aproximado entre los puntos
      radius: 2000, // 2 km de radio
      fillColor: Colors.blue.withOpacity(0.2),
      strokeColor: Colors.blue,
      strokeWidth: 1,
    ));
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _route.clear();
    });

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
        _route.add(LatLng(position.latitude, position.longitude));
      });

      _mapController.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude)));
    });
  }

  void _stopTracking() {
    setState(() {
      _isTracking = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
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
            onPressed: () {},
          ),
        ],
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _isTracking ? null : _startTracking,
                        child: Text('Comenzar seguimiento'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _isTracking ? _stopTracking : null,
                        child: Text('Parar seguimiento'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      zoom: 15,
                    ),
                    markers: _markers,
                    circles: _circles,
                    polylines: {
                      Polyline(
                        polylineId: PolylineId('route'),
                        points: _route,
                        color: Colors.blue,
                        width: 5,
                      ),
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/routeHistory');
                    },
                    child: Text('Ver historial de rutas'),
                  ),
                ),
              ],
            ),
    );
  }
}
