// // lib/side_nav_wrapper.dart

// import 'package:flutter/material.dart';
// import '../pages/edit_profile.dart'; // Import the EditProfilePage file

// class SideNavWrapper extends StatefulWidget {
//   const SideNavWrapper({super.key});

//   @override
//   State<SideNavWrapper> createState() => _SideNavWrapperState();
// }

// class _SideNavWrapperState extends State<SideNavWrapper> {
//   String name = "Hardik Pawar";
//   String email = "hardik@example.com";
//   String mobile = "9999999999"; // optional if you use it later

//   @override
//   Widget build(BuildContext context) {
//     return SideNavBar(
//       name: name,
//       email: email,
//     );
//   }

//   void editProfile(BuildContext context) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditProfilePage(
//           name: name,
//           mobile: mobile,
//           email: email,
//         ),
//       ),
//     );

//     if (result != null) {
//       setState(() {
//         name = result['name'] ?? name;
//         email = result['email'] ?? email;
//         mobile = result['mobile'] ?? mobile;
//       });
//     }
//   }
// }
