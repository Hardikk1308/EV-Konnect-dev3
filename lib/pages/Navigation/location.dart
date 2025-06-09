// // lib/pages/Navigation/location.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class SearchLocationScreen extends StatefulWidget {
//   final String apiKey;
//   const SearchLocationScreen({super.key, required this.apiKey});

//   @override
//   State<SearchLocationScreen> createState() => _SearchLocationScreenState();
// }

// class _SearchLocationScreenState extends State<SearchLocationScreen> {
//   TextEditingController _searchController = TextEditingController();
//   List<dynamic> _predictions = [];

//   void _fetchPredictions(String input) async {
//     if (input.isEmpty) return;

//     final response = await http.get(
//       Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${widget.apiKey}',
//       ),
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         _predictions = data['predictions'];
//       });
//     }
//   }

//   Future<LatLng?> _getLatLngFromPlaceId(String placeId) async {
//     final response = await http.get(
//       Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${widget.apiKey}',
//       ),
//     );
//     final data = json.decode(response.body);
//     if (data['status'] == 'OK') {
//       final loc = data['result']['geometry']['location'];
//       return LatLng(loc['lat'], loc['lng']);
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Search Location')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search here',
//                 border: OutlineInputBorder(),
//                 suffixIcon: Icon(Icons.search),
//               ),
//               onChanged: _fetchPredictions,
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _predictions.length,
//               itemBuilder: (_, index) {
//                 final place = _predictions[index];
//                 return ListTile(
//                   title: Text(place['description']),
//                   onTap: () async {
//                     LatLng? loc = await _getLatLngFromPlaceId(
//                       place['place_id'],
//                     );
//                     if (loc != null) {
//                       Navigator.pop(context, {
//                         'latLng': loc,
//                         'description': place['description'],
//                       });
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }