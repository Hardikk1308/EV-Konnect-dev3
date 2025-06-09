import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart' hide Colors;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kawach/constant/color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:kawach/models/autocomplate_prediction.dart';
import 'package:kawach/pages/Navigation/location_search_screen.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(22.061604, 83.346817);
  bool _isMapInitialized = false;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  final databaseReference = FirebaseDatabase.instance.ref();
  StreamSubscription<DatabaseEvent>? _locationSubscription;
  StreamSubscription<DatabaseEvent>? _batterySubscription;
  final String _googleApiKey = 'AIzaSyBzvxjbb2D9BQ9ThyknOXeRoKSyI-PWC3E';

  double socValue = 0.0;
  double estimatedRange = 0.0;
  double _geofenceRadius = 25000; // default 25 km
  LatLng? _iotPosition;

  bool _isInsideGeofence = false;
  bool _hasShownGeofenceAlert = false;

  @override
  void initState() {
    super.initState();
    _listenToFirebaseLocationUpdates();
    _listenToBatteryStats();
  }

  void _listenToFirebaseLocationUpdates() {
    _locationSubscription = databaseReference
        .child('sensor')
        .orderByKey()
        .limitToLast(1)
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value;

        if (data is Map) {
          final latestEntry = data.values.first;

          if (latestEntry is Map) {
            final lat = double.tryParse(latestEntry['latitude'].toString());
            final lng = double.tryParse(latestEntry['longitude'].toString());

            if (lat != null && lng != null) {
              final LatLng iotPosition = LatLng(lat, lng);
              _iotPosition = iotPosition;

              setState(() {
                _initialPosition = iotPosition;
                _markers.clear();
                _markers.add(
                  Marker(
                    markerId: const MarkerId("iotDevice"),
                    position: iotPosition,
                    infoWindow: const InfoWindow(
                      title: "Konnect Device",
                      snippet: "Real-time location from Firebase",
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure,
                    ),
                  ),
                );
                _drawGeofence(iotPosition);
              });

              if (_isMapInitialized) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(iotPosition),
                );
              }
            }
          }
        }
      }
    });
  }

  void _listenToBatteryStats() {
    _batterySubscription = databaseReference
        .child('sensor')
        .orderByKey()
        .limitToLast(1)
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value;

        if (data is Map) {
          final latestEntry = data.values.first;

          if (latestEntry is Map) {
            setState(() {
              socValue = double.tryParse(latestEntry['soc'].toString()) ?? 0.0;
              estimatedRange = (socValue / 100.0) * 80.0;
            });
          }
        }
      }
    });
  }

  void _drawGeofence(LatLng center) {
    _circles.clear();
    _circles.add(
      Circle(
        circleId: const CircleId("geofence"),
        center: center,
        radius: _geofenceRadius,
        fillColor: Colors.red.withOpacity(0.2),
        strokeColor: Colors.red,
        strokeWidth: 2,
      ),
    );
    _checkIfInsideGeofence(center);
  }

  void _checkIfInsideGeofence(LatLng geofenceCenter) async {
    try {
      Position position = await _determinePosition();
      LatLng userPosition = LatLng(position.latitude, position.longitude);

      double distanceInMeters = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        geofenceCenter.latitude,
        geofenceCenter.longitude,
      );

      bool isInside = distanceInMeters <= _geofenceRadius;

      setState(() {
        _isInsideGeofence = isInside;
      });

      if (!isInside && !_hasShownGeofenceAlert) {
        _hasShownGeofenceAlert = true;
        _showGeofenceAlert();
      } else if (isInside) {
        _hasShownGeofenceAlert = false;
      }

    } catch (e) {
      print("Error checking geofence: $e");
    }
  }

  void _showGeofenceAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Outside Geofence"),
        content: const Text("You have exited the allowed area."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _openRadiusInputDialog() async {
    TextEditingController radiusController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Set Geofence Radius"),
          content: TextField(
            controller: radiusController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter radius in km"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                double? inputRadius =
                    double.tryParse(radiusController.text.trim());
                if (inputRadius != null && inputRadius > 0) {
                  setState(() {
                    _geofenceRadius = inputRadius * 1000;
                    if (_iotPosition != null) {
                      _drawGeofence(_iotPosition!);
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Set"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await _determinePosition();
      LatLng current = LatLng(position.latitude, position.longitude);
      setState(() {
        _initialPosition = current;
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId("currentLocation"),
            position: current,
            infoWindow: const InfoWindow(
              title: "You are here",
              snippet: "Current location from device",
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
      });
      if (_isMapInitialized) {
        _mapController?.animateCamera(CameraUpdate.newLatLng(current));
      }
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _isMapInitialized = true;
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(_initialPosition));
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _batterySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 16,
            ),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            markers: _markers,
            circles: _circles,
          ),
          Positioned(
            left: 16,
            bottom: 110,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'deviceLocation',
                  onPressed: _getUserLocation,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.gps_fixed),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'iotLocation',
                  onPressed: _listenToFirebaseLocationUpdates,
                  backgroundColor: Colors.primary,
                  child: const Icon(
                    Icons.electric_scooter,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'setRadius',
                  onPressed: _openRadiusInputDialog,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.adjust),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
