import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChargingStationScreen extends StatelessWidget {
  const ChargingStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Charging Station',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 120, 197, 241),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Charging station content coming soon... Stay Tuned!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
