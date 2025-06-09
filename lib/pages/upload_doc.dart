import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadDocumentScreen extends StatefulWidget {
  @override
  _UploadDocumentScreenState createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _regController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  File? aadharFile;
  File? regFile;
  File? licenseFile;

  Future<void> pickFile(Function(File) onSelected) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      onSelected(File(result.files.single.path!));
    }
  }

  void _showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(221, 254, 254, 254),
          content: Row(
            children: const [
              CircularProgressIndicator(color: Colors.cyan),
              SizedBox(width: 20),
              Text("Submitting... Please wait", style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );
  }

  void _hideLoadingIndicator(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> submitDocuments() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    if (aadharFile == null || regFile == null || licenseFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload all required documents")),
      );
      return;
    }

    _showLoadingIndicator(context);

    try {
      final storageRef = FirebaseStorage.instance.ref("documents/${user.uid}");
      final aadharRef = await storageRef.child("aadhar.pdf").putFile(aadharFile!);
      final regRef = await storageRef.child("registration.pdf").putFile(regFile!);
      final licenseRef = await storageRef.child("license.pdf").putFile(licenseFile!);

      final aadharUrl = await aadharRef.ref.getDownloadURL();
      final regUrl = await regRef.ref.getDownloadURL();
      final licenseUrl = await licenseRef.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection("user_documents").doc(user.uid).set({
        "aadharNumber": _aadharController.text,
        "registrationNumber": _regController.text,
        "licenseNumber": _licenseController.text,
        "aadharUrl": aadharUrl,
        "registrationUrl": regUrl,
        "licenseUrl": licenseUrl,
        "timestamp": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Documents submitted successfully!")),
      );

      setState(() {
        _aadharController.clear();
        _regController.clear();
        _licenseController.clear();
        aadharFile = null;
        regFile = null;
        licenseFile = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: ${e.toString()}")),
      );
    } finally {
      _hideLoadingIndicator(context);
    }
  }

  Widget fileRow({
    required String label,
    required TextEditingController controller,
    required File? file,
    required Function(File) onFilePicked,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter $label",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () => pickFile(onFilePicked),
              icon: const Icon(Icons.upload_file, color: Colors.white),
              label: const Text("Upload", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent.shade400,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
            ),
          ],
        ),
        if (file != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              "Selected: ${file.path.split('/').last}",
              style: const TextStyle(fontSize: 13, color: Colors.greenAccent),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Upload Documents", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Model: Konnect", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            fileRow(
              label: "Aadhar Number",
              controller: _aadharController,
              file: aadharFile,
              onFilePicked: (file) => setState(() => aadharFile = file),
            ),
            fileRow(
              label: "Registration Number",
              controller: _regController,
              file: regFile,
              onFilePicked: (file) => setState(() => regFile = file),
            ),
            fileRow(
              label: "Driving License",
              controller: _licenseController,
              file: licenseFile,
              onFilePicked: (file) => setState(() => licenseFile = file),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: submitDocuments,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent.shade400,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text("Submit", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}