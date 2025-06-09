// import 'dart:async';
// import 'package:flutter/material.dart' hide Colors;
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:kawach/components/circuler_image.dart';
// import 'package:kawach/constant/color.dart';
// import 'package:kawach/constant/image.dart';
// import 'package:kawach/utils/size.dart';
// import 'package:kawach/utils/style.dart';
// import 'package:kawach/pages/profile.dart';
// import 'package:kawach/pages/notification.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int soc = 0;
//   double current = 0;
//   double avgTemp = 0;
//   String lastSyncedTime = "—";

//   final double topSpeed = 110;
//   StreamSubscription<DatabaseEvent>? _sensorSubscription;

//   double get estimatedRange => (soc / 60) * 80;
//   double get avgSpeedDuration => estimatedRange / topSpeed;

//   String get formattedDistanceLeft => "${estimatedRange.toStringAsFixed(1)} km";

//   String get formattedTimeLeft {
//     final duration = avgSpeedDuration;
//     if (duration < 1.0) {
//       final minutes = (duration * 60).round();
//       return "$minutes min";
//     } else {
//       return "${duration.toStringAsFixed(1)} hr";
//     }
//   }

//   String getBatteryImage(int soc) {
//     if (soc == 0) return 'assets/images/battery_0.png';
//     if (soc > 0 && soc <= 25) return 'assets/images/battery_25.png';
//     if (soc > 25 && soc <= 50) return 'assets/images/battery_50.png';
//     if (soc > 50 && soc <= 75) return 'assets/images/battery_75.png';
//     return 'assets/images/battery_100.png';
//   }

//   @override
//   void initState() {
//     super.initState();
//     listenToSensorData();
//   }

//   void listenToSensorData() {
//     final ref = FirebaseDatabase.instance.ref("sensor");
//     _sensorSubscription = ref.orderByKey().limitToLast(1).onValue.listen((event) {
//       final dataSnapshot = event.snapshot;

//       if (dataSnapshot.exists && dataSnapshot.children.isNotEmpty) {
//         final firstChild = dataSnapshot.children.first;
//         final rawData = firstChild.value;

//         if (rawData is Map) {
//           final data = Map<String, dynamic>.from(rawData);
//           setState(() {
//             soc = (data["soc"] ?? soc).toInt();
//             current = (data["current"] ?? current).toDouble();
//             avgTemp = (data["avg_temp"] ?? avgTemp).toDouble();

//             final rawTime = data["time"];
//             if (rawTime != null && rawTime is String) {
//               final parts = rawTime.split(":");
//               if (parts.length == 3) {
//                 int hour = int.parse(parts[0]);
//                 final minute = parts[1];
//                 final period = hour >= 12 ? "pm" : "am";
//                 hour = hour % 12 == 0 ? 12 : hour % 12;
//                 lastSyncedTime = "$hour:$minute $period";
//               } else {
//                 lastSyncedTime = rawTime;
//               }
//             } else {
//               lastSyncedTime = "—";
//             }
//           });
//         }
//       }
//     }, onError: (error) {
//       print("Firebase error: $error");
//     });
//   }

//   @override
//   void dispose() {
//     _sensorSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: const Color.fromARGB(255, 29, 28, 28),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Profile and Notification
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
//                         },
//                         child: CirculerImage(size: 45),
//                       ),
//                       const SizedBox(width: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Good Morning", style: subTitle1(fontWeight: FontWeight.w500, fontSize: 16.sp, color: Colors.white)),
//                           Text("Naivedya", style: bodyText(color: Colors.white, fontSize: 14.sp)),
//                         ],
//                       ),
//                     ],
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
//                     },
//                     child: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               Center(
//                 child: ShaderMask(
//                   shaderCallback: (bounds) => const LinearGradient(
//                     colors: [Color(0xFF00C6FF), Color(0xFF99E6FF)],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ).createShader(bounds),
//                   child: Text(
//                     "Konnect",
//                     style: subTitle1(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 32.sp),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               Center(
//                 child: Image.asset(ebike, width: deviceWidth(context) * 0.85),
//               ),

//               const SizedBox(height: 12),
//               Center(child: Text("Erkey Motor D92", style: subTitle1(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.sp))),

//               const SizedBox(height: 28),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(getBatteryImage(soc), width: 120, height: 120),
//                   const SizedBox(width: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("$soc% battery left", style: subTitle1(fontWeight: FontWeight.w500, fontSize: 18.sp, color: Colors.white)),
//                       const SizedBox(height: 4),
//                       Text("$formattedDistanceLeft of ride left", style: bodyText(color: Colors.white, fontSize: 14.sp)),
//                       Text("${topSpeed.toInt()} kmph for $formattedTimeLeft", style: bodyText(color: Colors.white, fontSize: 14.sp)),
//                       Text("Temperature: ${avgTemp.toStringAsFixed(1)} ℃", style: bodyText(color: Colors.white, fontSize: 14.sp)),
//                     ],
//                   )
//                 ],
//               ),

//               const Spacer(),

//               // Ignition container
//               Container(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.cardBG,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 5,
//                       offset: const Offset(0, 2),
//                     )
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text("Ignition Status", style: bodyText(color: Colors.white, fontSize: 12.sp)),
//                             const SizedBox(width: 6),
//                             Icon(
//                               Icons.circle,
//                               color: current > 0 ? Colors.green : Colors.red,
//                               size: 10,
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               current > 0 ? "ON" : "OFF",
//                               style: bodyText(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 2),
//                         Text("Last synced $lastSyncedTime", style: caption(color: Colors.white, fontSize: 12.sp)),
//                       ],
//                     ),
//                     Container(
//                       width: 36,
//                       height: 36,
//                       decoration: BoxDecoration(
//                         color: Colors.primary,
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
