// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:google_fonts/google_fonts.dart';

// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});

//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }

// class _NotificationsScreenState extends State<NotificationsScreen> {
//   double avgTemp = 0;
//   double soc = 100;
//   bool isLoading = true;

//   List<Map<String, String>> notifications = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchSensorData();
//   }

//   Future<void> fetchSensorData() async {
//     final dbRef = FirebaseDatabase.instance.ref("sensor");

//     final snapshot = await dbRef.orderByKey().limitToLast(1).get();

//     if (snapshot.exists) {
//       final latestEntry =
//           snapshot.children.first.value as Map<dynamic, dynamic>;

//       avgTemp = (latestEntry["avg_temp"] ?? 0).toDouble();
//       soc = (latestEntry["soc"] ?? 100).toDouble();

//       generateNotifications();
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   void generateNotifications() {
//     notifications.clear();

//     if (avgTemp > 50) {
//       notifications.add({
//         "title": "Battery Temperature Warning",
//         "message":
//             "Battery temperature is too high! Park in a shaded area to cool down.",
//         "days": "Just now",
//         "badge": "!",
//       });
//     }

//     if (soc < 20) {
//       notifications.add({
//         "title": "Low Battery Alert",
//         "message":
//             "Battery is below 20%. Please charge soon to avoid shutdown.",
//         "days": "Just now",
//         "badge": "!",
//       });
//     }

//     // Static notification
//     notifications.addAll([
//       {
//         "title": "Battery Health Tip",
//         "message":
//             "Your battery health is optimal! Keep charging between 20%-80%.",
//         "days": "Today",
//       },
//     ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final message =
//         ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//     return Scaffold(
//       backgroundColor: Colors.grey[200], // White background
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: true,
//         title: Text(
//           "Notifications",
//           style: GoogleFonts.poppins(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: notifications.length,
//                 itemBuilder: (context, index) {
//                   var notification = notifications[index];
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 12.0),
//                     child: Card(
//                       color: Colors.grey[100],
//                       elevation: 1,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 12,
//                         ),
//                         leading: CircleAvatar(
//                           backgroundColor: const Color(0xFF78C5F1),
//                           child: const Icon(
//                             Icons.notifications,
//                             color: Colors.white,
//                           ),
//                         ),
//                         title: Text(
//                           notification["title"] ?? "Notification",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                             color: Colors.grey[900],
//                           ),
//                         ),
//                         subtitle: Padding(
//                           padding: const EdgeInsets.only(top: 4.0),
//                           child: Text(
//                             notification["message"] ?? "",
//                             style: GoogleFonts.poppins(
//                               fontSize: 13,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                         ),
//                         trailing: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             if (notification.containsKey("badge"))
//                               CircleAvatar(
//                                 radius: 10,
//                                 backgroundColor: Colors.red,
//                                 child: Text(
//                                   notification["badge"]!,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             const SizedBox(height: 6),
//                             Text(
//                               notification["days"] ?? "",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 10,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Notification extends StatelessWidget {
  const Notification({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
