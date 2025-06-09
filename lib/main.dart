import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kawach/constant/color.dart';
import 'package:kawach/models/Firebaseapi.dart';
import 'package:kawach/pages/about.dart';
import 'package:kawach/pages/auth/loginpage.dart';
import 'package:kawach/pages/auth/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kawach/pages/charging_station.dart';
import 'package:kawach/pages/edit_profile.dart';
import 'package:kawach/pages/fleet_management_screen.dart';
import 'package:kawach/pages/notification.dart' as kawach;
import 'package:kawach/pages/term.dart';
import 'package:kawach/pages/upload_doc.dart';
import 'package:kawach/pages/auth/onboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Firebaseapi().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 720),
      builder: (context, child) {
        return MaterialApp(
          title: 'Konnect',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF121212),
            primaryColor: Colors.primary,
            cardColor: const Color(0xFF1E1E1E),
            iconTheme: const IconThemeData(color: Colors.white),
            textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Poppins',
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.primary,
              unselectedItemColor: Color(0xFF757575),
              showUnselectedLabels: true,
            ),
            colorScheme: const ColorScheme.dark(primary: Colors.primary),
          ),
          initialRoute: '/',
          routes: {
            '/login': (context) => const LoginPage(),
            '/editprofile':
                (context) => EditProfilePage(name: '', mobile: '', email: ''),
            '/notifications': (context) => const kawach.Notification(),
            '/upload': (context) => UploadDocumentScreen(),
            '/faq': (context) => const TermsAndPoliciesScreen(),
            '/about': (context) => const AboutScreen(),
            '/onboard': (context) => const OnboardPage(),
            '/fleet': (context) => const FleetManagementScreen(),
            '/charging': (context) => const ChargingStationScreen(),
          },
          home: SplashPage(),
        );
      },
    );
  }
}


// AIzaSyBSUmzgvcFvNiUDusmdBPdOIk7kKREDrFA