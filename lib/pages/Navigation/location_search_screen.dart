import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kawach/components/location_list_tile.dart';
import 'package:kawach/models/autocomplate_prediction.dart';
import 'package:kawach/models/place_auto_complate_response.dart';
import '../../models/Netwok.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({Key? key}) : super(key: key);

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  final border = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: Color(0xFF0D0D0E), width: 1),
  );
  List<AutocompletePrediction> placePredictions = [];

  Future<void> fetchPlaceAutocomplete(String query) async {
    Uri uri = Uri.https("maps.googleapis.com", "/maps/api/place/autocomplete/json", {
      "input": query,
      "key": "AIzaSyAVBLRC-45AYpoSVu6yppziRP3I0OvpBfI",
    });

    String? response = await Network().fetchUrl(uri);
    PlaceAutocompleteResponse result =
        PlaceAutocompleteResponse.parseAutocompleteResult(response);

    if (result.predictions != null) {
      setState(() {
        placePredictions = result.predictions!;
      });
    }
  }

  Future<void> fetchPlaceDetailsAndReturn(AutocompletePrediction prediction) async {
    Uri detailsUri = Uri.https("maps.googleapis.com", "/maps/api/place/details/json", {
      "place_id": prediction.placeId!,
      "key": "AIzaSyAVBLRC-45AYpoSVu6yppziRP3I0OvpBfI",
    });

    String? response = await Network().fetchUrl(detailsUri);
    final details = jsonDecode(response!);

    if (details['status'] == 'OK') {
      final location = details['result']['geometry']['location'];
      final lat = location['lat'];
      final lng = location['lng'];

      Navigator.pop(context, {
        "description": prediction.description!,
        "lat": lat,
        "lng": lng,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundColor: Color(0xFFEEEEEE),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
        title: const Text(
          "Set Delivery Location",
          style: TextStyle(color: Color(0xFF0D0D0E)),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Color(0xFFEEEEEE),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.black),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    fetchPlaceAutocomplete(value);
                  }
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFEFEFEF),
                  enabledBorder: border,
                  focusedBorder: border,
                  border: border,
                  hintText: "Search your location",
                  hintStyle: const TextStyle(color: Color(0xFF0D0D0E), fontSize: 14),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Icon(Icons.location_on_outlined, color: Color(0xFF0D0D0E)),
                  ),
                ),
                style: const TextStyle(color: Color(0xFF0D0D0E)),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFF0D0D0E)),
          Expanded(
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index) {
                return LocationListTile(
                  location: placePredictions[index].description!,
                  press: () {
                    fetchPlaceDetailsAndReturn(placePredictions[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
