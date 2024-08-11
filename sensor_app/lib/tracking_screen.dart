import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'route_history_screen.dart';

class TrackingScreen extends StatefulWidget {
  @override
  _TrackingSensorScreenState createState() => _TrackingSensorScreenState();
}

class _TrackingSensorScreenState extends State<TrackingScreen> {
  late GoogleMapController _mapController;
  Position? _currentPosition;
  bool _isTracking = false;
  List<LatLng> _route = [];

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
    });
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
                          backgroundColor: Colors.green, // Ajusta el color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _isTracking ? _stopTracking : null,
                        child: Text('Parar seguimiento'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Ajusta el color
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
                    markers: {
                      Marker(
                        markerId: MarkerId('currentLocation'),
                        position: LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude),
                      ),
                    },
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
