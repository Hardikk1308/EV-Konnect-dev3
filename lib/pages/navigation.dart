// import 'package:flutter/material.dart' hide Colors;
// import 'package:kawach/HomePage.dart';
// import 'package:kawach/constant/color.dart';
// import 'package:kawach/pages/subpage/contact.dart';
// import 'package:kawach/pages/subpage/home.dart';
// import 'package:kawach/pages/subpage/nav.dart';
// import 'package:kawach/pages/subpage/stats.dart';

// class NavigationPage extends StatefulWidget {
//   const NavigationPage({super.key});

//   @override
//   State<NavigationPage> createState() => _NavigationPageState();
// }

// class _NavigationPageState extends State<NavigationPage> {
//   int navIndex = 0;
//   List<Widget> navPage = [
//     const Homepage(),
//     const NavPage(),
//     const StatsPage(),
//     const ContactPage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,  // Dark background color
//       bottomNavigationBar: BottomNavigationBar(
//         iconSize: 30,
//         showUnselectedLabels: true,
//         unselectedItemColor: Colors.grey,  // Lighter grey for unselected items
//         selectedItemColor: Colors.primary,  // Primary color for selected item
//         backgroundColor: Colors.grey600,  // Dark background for the bottom navigation bar
//         currentIndex: navIndex,
//         onTap: (index) {
//           setState(() {
//             navIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, color: navIndex == 0 ? Colors.primary : Colors.grey),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.navigation, color: navIndex == 1 ? Colors.primary : Colors.grey),
//             label: "Nav",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings, color: navIndex == 2 ? Colors.primary : Colors.grey),
//             label: "Stats",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.call, color: navIndex == 3 ? Colors.primary : Colors.grey),
//             label: "Contact us",
//           ),
//         ],
//       ),
//       body: navPage[navIndex],
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 25,
      showUnselectedLabels: true,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.blue,
      backgroundColor: Colors.grey[300],
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: currentIndex == 0 ? Colors.blue : Colors.black,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.navigation,
            color: currentIndex == 1 ? Colors.blue : Colors.black,
          ),
          label: "Nav",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.stacked_bar_chart_outlined,
            color: currentIndex == 2 ? Colors.blue : Colors.black,
          ),
          label: "Stats",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.call,
            color: currentIndex == 3 ? Colors.blue : Colors.black,
          ),
          label: "Contact us",
        ),
      ],
    );
  }
}
