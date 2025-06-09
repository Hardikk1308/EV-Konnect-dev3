// // lib/pages/route_planner.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:http/http.dart' as http;

// const String googleApiKey = 'AIzaSyBSUmzgvcFvNiUDusmdBPdOIk7kKREDrFA';

// class RoutePlanner extends StatefulWidget {
//   const RoutePlanner({super.key});

//   @override
//   _RoutePlannerState createState() => _RoutePlannerState();
// }

// class _RoutePlannerState extends State<RoutePlanner> {
//   GoogleMapController? mapController;
//   LatLng? currentLocation;
//   LatLng? origin, destination;
//   bool locationLoaded = false;
//   bool showNote = true;

//   Set<Polyline> _polylines = {};
//   Set<Marker> _markers = {};
//   Location location = Location();

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     final permission = await location.requestPermission();
//     if (permission != PermissionStatus.granted) return;

//     final locData = await location.getLocation();
//     currentLocation = LatLng(locData.latitude!, locData.longitude!);

//     _markers.add(
//       Marker(
//         markerId: MarkerId('current'),
//         position: currentLocation!,
//         infoWindow: InfoWindow(title: 'You are here'),
//         onTap: () {
//           setState(() {
//             showNote = false;
//           });
//         },
//       ),
//     );

//     setState(() {
//       locationLoaded = true;
//     });
//   }

//   Future<void> _getRoutePolyline(LatLng origin, LatLng destination) async {
//     final url =
//         'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleApiKey';

//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['routes'].isEmpty) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('No route found')));
//         return;
//       }

//       final polylinePoints = data['routes'][0]['overview_polyline']['points'];
//       final List<LatLng> polylineCoordinates = _decodePolyline(polylinePoints);

//       setState(() {
//         _polylines.clear();
//         _polylines.add(
//           Polyline(
//             polylineId: PolylineId('route'),
//             points: polylineCoordinates,
//             color: Colors.blue,
//             width: 5,
//           ),
//         );
//       });
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to fetch route')));
//     }
//   }

//   List<LatLng> _decodePolyline(String encoded) {
//     List<LatLng> polyline = [];
//     int index = 0, len = encoded.length;
//     int lat = 0, lng = 0;

//     while (index < len) {
//       int b, shift = 0, result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//       lat += dlat;

//       shift = 0;
//       result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//       lng += dlng;

//       polyline.add(LatLng(lat / 1E5, lng / 1E5));
//     }

//     return polyline;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             locationLoaded
//                 ? GoogleMap(
//                     onMapCreated: (c) => mapController = c,
//                     initialCameraPosition: CameraPosition(
//                       target: currentLocation!,
//                       zoom: 14,
//                     ),
//                     myLocationEnabled: true,
//                     markers: _markers,
//                     polylines: _polylines,
//                   )
//                 : Center(child: CircularProgressIndicator()),
//             if (showNote)
//               Positioned(
//                 bottom: 20,
//                 left: 20,
//                 right: 20,
//                 child: Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 4,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     'Click on the red dot or your current location to plan the route.',
//                     style: TextStyle(fontSize: 16, color: Colors.black),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }