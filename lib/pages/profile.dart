import 'package:flutter/material.dart';
import 'package:kawach/pages/auth/onboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile.dart';
import 'notification.dart' as mynoti;
import 'upload_doc.dart';
import 'term.dart';
import 'about.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Naivedya";
  String email = "xyz@gmail.com";
  String mobile = "+91 773583675";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? name;
      email = prefs.getString("email") ?? email;
      mobile = prefs.getString("mobile") ?? mobile;
    });
  }

  Future<void> _saveProfileData(String newName, String newEmail, String newMobile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", newName);
    await prefs.setString("email", newEmail);
    await prefs.setString("mobile", newMobile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/images/user.png"),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(email, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          name: name,
                          email: email,
                          mobile: mobile,
                        ),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        name = result["name"];
                        email = result["email"];
                        mobile = result["mobile"];
                      });
                      _saveProfileData(name, email, mobile);
                    }
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text("Edit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          _buildMenuItem(
            context,
            icon: Icons.notifications,
            text: "Notifications",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => mynoti.Notification())),
          ),
          _buildMenuItem(
            context,
            icon: Icons.ev_station,
            text: "Find Charging Station",
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: Icons.upload_file,
            text: "Upload Document",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UploadDocumentScreen())),
          ),
          _buildMenuItem(
            context,
            icon: Icons.question_answer,
            text: "FAQ",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndPoliciesScreen())),
          ),
          _buildMenuItem(
            context,
            icon: Icons.info,
            text: "About",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen())),
          ),

          const Spacer(),

          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text("Log out", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear(); // optional if you want to clear profile on logout
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OnboardPage()),
            (route) => false,
          );
        },
      ),
    );
  }
}
