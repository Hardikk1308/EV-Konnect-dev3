import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndPoliciesScreen extends StatelessWidget {
  const TermsAndPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Terms & Policies',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle('Terms & Conditions'),
              sectionText(
                  "Your privacy is important to us. It is Navyug Technologies India Private Limited’s policy to respect your privacy regarding any information we may collect from you."),
              const SizedBox(height: 20),
              sectionTitle('Information We Collect'),
              const SizedBox(height: 10),
              smallSectionTitle('Log Data'),
              sectionText(
                  "When you visit our app, our servers may automatically log the standard data provided by your web browser. This data is considered non-identifying."),
              const SizedBox(height: 20),
              smallSectionTitle('Personal Information'),
              sectionText(
                  "We may ask for personal information, such as your name, email address, and phone number, which will only be used for providing our services."),
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
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget smallSectionTitle(String subtitle) {
    return Text(
      subtitle,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.black54,

        fontWeight: FontWeight.w600,
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
          height: 1.6,
          color: Colors.black87,
        ),
      ),
    );
  }
}
