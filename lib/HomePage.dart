import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kawach/pages/Navigation/nav.dart';
import 'package:kawach/pages/navigation.dart';
import 'package:kawach/pages/Navigation/contact.dart';
import 'package:kawach/pages/Navigation/stats.dart';
import 'package:kawach/pages/notification.dart' as mynotif;
import 'package:kawach/utils/Bikeframe.dart';
import 'package:kawach/utils/Sidenavbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static const customTextStyle = TextStyle(color: Colors.black);

  int batteryPercentage = 0;
  double batteryTemperature = 0.0;
  bool ignitionStatus = false;
  int navIndex = 0;

  String userName = '   ';
  String profileImageUrl = '';

  final List<Widget> navPage = [
    const NavPage(),
    //RoutePlanner(),
    const StatsPage(),
    const ContactPage(),
  ];

  @override
  void initState() {
    super.initState();
    fetchBatteryData();
    fetchUserProfileData();
  }

  void fetchBatteryData() {
    final dbRef = FirebaseDatabase.instance.ref("sensor");

    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null || data.isEmpty) {
        print("No data found in 'sensor'");
        return;
      }

      final sortedKeys = data.keys.toList()..sort();
      final latestKey = sortedKeys.last;
      final latestEntry = data[latestKey] as Map<dynamic, dynamic>;

      final newSOC = (latestEntry['soc'] ?? 0) is int
          ? latestEntry['soc']
          : int.tryParse(latestEntry['soc'].toString()) ?? batteryPercentage;

      final newTemp = (latestEntry['avg_temp'] ?? 0.0) is double
          ? latestEntry['avg_temp']
          : double.tryParse(latestEntry['avg_temp'].toString()) ?? batteryTemperature;

      final newIgnition = latestEntry['ignition_status'] == 1;

      if (newSOC != batteryPercentage ||
          newTemp != batteryTemperature ||
          newIgnition != ignitionStatus) {
        setState(() {
          batteryPercentage = newSOC;
          batteryTemperature = newTemp;
          ignitionStatus = newIgnition;
        });
      }

      print("✅ Data fetched from key: $latestKey");
      print("🔋 SOC: $batteryPercentage | 🌡️ Temp: $batteryTemperature");
    });
  }

  void fetchUserProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final userRef = FirebaseDatabase.instance.ref("users/$uid/profile");

      userRef.onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          setState(() {
            userName = data['Name'] ?? 'Namaste';
            profileImageUrl = data['profileImage'] ?? '';
          });

          print("👤 User profile loaded: $userName");
        }
      });
    }
  }

  String getBatteryImage(int percentage) {
    if (percentage >= 90) {
      return 'assets/images/battery_full.png';
    } else if (percentage >= 75) {
      return 'assets/images/battery_75.png';
    } else if (percentage >= 50) {
      return 'assets/images/battery_50.png';
    } else {
      return 'assets/images/battery_25.png';
    }
  }

  double getEstimatedDistance() {
    return batteryPercentage * 0.6;
  }

  String getEstimatedDuration() {
    final distance = getEstimatedDistance();
    final durationInHours = distance / 25;
    final hours = durationInHours.floor();
    final minutes = ((durationInHours - hours) * 60).round();
    return "${hours}h ${minutes}m";
  }

  double getAvgSpeed() {
    final distance = getEstimatedDistance();
    final durationInHours = distance / 25;
    return distance / durationInHours;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: const SideNavBar(),
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: navIndex == 0
          ? AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 3,
              shadowColor: Colors.black,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 197, 220, 250),
                      Color.fromARGB(255, 186, 228, 253),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: width * 0.045,
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : const AssetImage('assets/images/user.png')
                            as ImageProvider,
                  ),
                  SizedBox(width: width * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$userName",
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Ignition Status ",
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          CircleAvatar(
                            radius: 6,
                            backgroundColor:
                                ignitionStatus ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const mynotif.Notification()),
                    );
                  },
                ),
              ],
            )
          : null,
      body: navIndex == 0
          ? SingleChildScrollView(child: buildHomeContent(width, height))
          : navPage[navIndex - 1],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: navIndex,
        onTap: (index) {
          setState(() {
            navIndex = index;
          });
        },
      ),
    );
  }

  Widget buildHomeContent(double width, double height) {
    return Column(
      children: [
        SizedBox(height: height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            children: [
              buildBatteryCard(width, height),
              SizedBox(height: height * 0.03),
              buildRideSummaryCard(width, height),
            ],
          ),
        ),
        SizedBox(height: height * 0.06),
        const Bikeframe(),
        Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: buildBatteryInfoCard(width, height),
        ),
      ],
    );
  }

  Widget buildBatteryCard(double width, double height) {
    return Container(
      height: height * 0.16,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: batteryTemperature < 40
              ? [
                  const Color(0xFFE6FFEA),
                  const Color(0xFFA5ECA5),
                  const Color(0xFF46D046),
                ]
              : [
                  const Color(0xFFFFE6E6),
                  const Color(0xFFFFCCCC),
                  const Color(0xFFFF9999),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.015,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Battery",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Temperature",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "${batteryTemperature.toStringAsFixed(2)}°C",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.09,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/celsius1.png', height: height * 0.08),
        ],
      ),
    );
  }

  Widget buildRideSummaryCard(double width, double height) {
    return Container(
      height: height * 0.14,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 197, 224, 252),
            Color.fromARGB(255, 234, 243, 251),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Ride",
            style: TextStyle(
              fontSize: width * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRideInfo("Distance", "${getEstimatedDistance().toStringAsFixed(1)} km", width),
              buildRideInfo("Avg. Speed", "25 km/h", width),
              buildRideInfo("Duration", getEstimatedDuration(), width),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBatteryInfoCard(double width, double height) {
    return Container(
      height: height * 0.15,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            getBatteryImage(batteryPercentage),
            height: height * 0.08,
          ),
          SizedBox(width: width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildRichLine("Charge: ", "$batteryPercentage%"),
                buildRichLine("Distance: ", "${getEstimatedDistance().toStringAsFixed(1)} km left"),
                buildRichLine("Time: ", getEstimatedDuration()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRideInfo(String title, String value, double width) {
    return Column(
      children: [
        Text(title, style: customTextStyle.copyWith(fontSize: width * 0.035)),
        Text(
          value,
          style: TextStyle(
            fontSize: width * 0.04,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildRichLine(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
