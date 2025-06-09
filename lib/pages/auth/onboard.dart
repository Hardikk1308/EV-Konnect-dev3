import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kawach/constant/Buttons.dart';
import 'package:kawach/pages/auth/loginpage.dart' show LoginPage;
import 'package:kawach/pages/auth/register.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(); // Exits the app properly
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/unsplash003.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // Black Overlay for readability
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0)),
            ),
            // Bottom Container with White Background
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Column(
                      children: [
                        const Text(
                          "Welcome To Konnect",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        const Text(
                          "Ride Smart Ride Safe with Konnect",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 20),
                    // Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Login Button
                        CommonButton(
                          text: "Login",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                        ),
                        // Register Button
                        CommonButton(text: "Register", onPressed:() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          }, )
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
