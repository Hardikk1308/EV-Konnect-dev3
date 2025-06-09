import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "About",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle("About Kavach"),
              sectionText(
                "Konnect, a cutting-edge product by Navyug, is designed to redefine EV telematics and battery intelligence through real-time data, smart analytics, and seamless connectivity. Whether you're an individual EV owner, fleet operator, or energy provider, Konnect provides advanced monitoring, security, and optimization tools to ensure maximum efficiency and reliability for electric vehicles."
              ),
              const SizedBox(height: 20),
              sectionTitle("Our Mission"),
              sectionText(
                "At Navyug, we are committed to revolutionizing the EV ecosystem with intelligent telematics solutions that enhance performance, safety, and sustainability. Kavach bridges the gap between vehicles, energy infrastructure, and cloud-based intelligence, empowering users with real-time insights and predictive analytics to drive smarter mobility decisions."
              ),
              const SizedBox(height: 20),
              sectionTitle("Key Features of Konnect"),
              sectionBulletPoints([
                "Real-Time Tracking – Live GPS updates, route history, and geospatial analytics",
                "Battery Intelligence – CAN/UART-based monitoring for health, performance, and charging insights",
                "4G LTE Connectivity – Secure cloud integration and over-the-air updates",
              ]),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
          height: 1.6,
        ),
      ),
    );
  }

  Widget sectionBulletPoints(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((point) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• ", style: TextStyle(fontSize: 20, color: Colors.black)),
              Expanded(
                child: Text(
                  point,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
