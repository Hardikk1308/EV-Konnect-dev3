import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Network {
  Future<String> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint("Network error: ${e.toString()}");
    }
    throw Exception('Failed to fetch URL');
  }
}
