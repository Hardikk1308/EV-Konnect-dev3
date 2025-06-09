import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FleetManagementScreen extends StatelessWidget {
  const FleetManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fleet Management',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 120, 197, 241),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Fleet management coming soon!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
