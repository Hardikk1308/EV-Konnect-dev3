import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  String userName = 'Loading...';
  String userEmail = 'Loading...';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child('users/$userId/profile')
        .get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        userName = data['name'] ?? 'No Name';
        userEmail = data['email'] ?? 'No Email';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 190, 215, 246),
                  Color.fromARGB(255, 172, 208, 255),
                  Color.fromARGB(255, 144, 187, 243),
                  Color.fromARGB(255, 120, 197, 241),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
            accountName: Text(
              userName,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            accountEmail: Text(
              userEmail,
              style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14),
            ),
          ),
          buildMenuItem(context,
              icon: Icons.person_outline,
              title: 'Edit Profile',
              routeName: '/editprofile'),
          buildMenuItem(context,
              icon: Icons.notifications_active_outlined,
              title: 'Notifications',
              routeName: '/notifications'),
          buildMenuItem(context,
              icon: Icons.upload_file_outlined,
              title: 'Upload Document',
              routeName: '/upload'),
          buildMenuItem(context,
              icon: Icons.help_outline, title: 'FAQ', routeName: '/faq'),
          buildMenuItem(context,
              icon: Icons.info_outline, title: 'About', routeName: '/about'),

          // 💥 New menu item: Fleet Management
          buildMenuItem(context,
              icon: Icons.directions_car_filled_outlined,
              title: 'Fleet Management',
              routeName: '/fleet'),

          // ⚡ New menu item: Charging Station
          buildMenuItem(context,
              icon: Icons.ev_station_outlined,
              title: 'Charging Station',
              routeName: '/charging'),

          const Spacer(),
          Divider(
            color: Colors.grey[400],
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/onboard',
                  (route) => false,
                );
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String routeName}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 24),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      hoverColor: const Color.fromARGB(50, 120, 197, 241),
      splashColor: const Color.fromARGB(50, 120, 197, 241),
    );
  }
}
