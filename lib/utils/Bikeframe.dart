import 'package:flutter/material.dart';

class Bikeframe extends StatelessWidget {
  const Bikeframe({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 200,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Container(
              width: 340,
              height: 150,
              decoration: BoxDecoration(
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.5),
                //     blurRadius: 5.0,
                //     spreadRadius: 2.0,
                //     offset: Offset(0.0, 5.0),
                //   ),
                // ],
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                    colors: [
                  // Darker Green
                    Color.fromARGB(255, 250, 250, 250), // White
                    Color.fromARGB(255, 226, 226, 226), // Very Light Grey
                    Color.fromARGB(255, 209, 208, 208), // Light Grey
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -70,
            left: -10,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Shadow under bike
                Positioned(
                  top: 160,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Opacity(
                      opacity: 0.7,
                      child: Container(
                        width: 240,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 9,
                              spreadRadius: 8,
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bike image
                Image.asset('assets/images/ereck.png', width: 370, height: 230),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
