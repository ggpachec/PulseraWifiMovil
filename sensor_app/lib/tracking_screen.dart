import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TrackingScreen extends StatefulWidget {
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late GoogleMapController _mapController;
  final Location _location = Location();
  late LatLng _currentPosition;
  final Set<Polyline> _polylines = {};
  final List<LatLng> _routeCoords = [];
  final List<List<LatLng>> _routeHistory = [];

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _routeCoords.add(_currentPosition);
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          visible: true,
          points: _routeCoords,
          width: 4,
          color: Colors.blue,
        ));
      });
      _mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    });

    LocationData locationData = await _location.getLocation();
    setState(() {
      _currentPosition =
          LatLng(locationData.latitude!, locationData.longitude!);
      _routeCoords.add(_currentPosition);
    });
  }

  void _showRouteHistory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Historial de Rutas'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _routeHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Ruta ${index + 1}'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showRouteOnMap(_routeHistory[index]);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showRouteOnMap(List<LatLng> route) {
    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId('selected_route'),
        visible: true,
        points: route,
        width: 4,
        color: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor de Seguimiento'),
        backgroundColor: Colors.blue,
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
            icon: Icon(Icons.history),
            onPressed: _showRouteHistory,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 15,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
