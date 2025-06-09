import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kawach/constant/Buttons.dart';
import 'package:kawach/utils/size.dart';
import 'package:kawach/utils/style.dart';
import 'package:firebase_database/firebase_database.dart'; // 🔹 ADDED

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(
    "contact_submissions",
  ); // 🔹 ADDED

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _mobileController.clear();
    _feedbackController.clear();
  }

  void _handleSend() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final mobile = _mobileController.text.trim();
    final feedback = _feedbackController.text.trim();

    if (name.isEmpty || email.isEmpty || mobile.isEmpty || feedback.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final submission = {
      "name": name,
      "email": email,
      "mobile": mobile,
      "feedback": feedback,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };

    try {
      await _dbRef.push().set(submission); // 🔹 ADDED

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thanks for your feedback 💙")),
      );
      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error submitting: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text("Contact Us"),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.grey[300],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: statusBarHeight(context) + 20),
                Text(
                  "Get in Touch",
                 style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal, // Adjust as needed
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  
                  "Need assistance with our app? We're here to help!\nReach out to us for support, enquiries, or feedback.",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal, // Adjust as needed
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                buildTextField("Name", controller: _nameController),
                buildTextField("Email", controller: _emailController),
                buildTextField("Mobile No.", controller: _mobileController),
                buildTextField(
                  "Feedback",
                  controller: _feedbackController,
                  maxLines: 4,
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  // child: ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blue,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(vertical: 12),
                  //   ),
                  //   onPressed: _handleSend,
                  //   child: Text(
                  //     "Send",
                  //     style: subTitle1(color: Colors.white, fontSize: 16),
                  //   ),
                  // )
                  child: CommonButton(
                    text: "Send",
                    onPressed: _handleSend,
                  ),
                ),

                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.black,),
                    const SizedBox(width: 1),
                    Text("9835594986", style: subTitle2(color: Colors.black,)),
                    const SizedBox(width: 1),
                    Icon(Icons.email, color: Colors.black),
                    const SizedBox(width:1),
                    Text(
                      "naivedya456@gmail.com",
                      style: subTitle2(color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
    String hint, {
    int maxLines = 1,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
