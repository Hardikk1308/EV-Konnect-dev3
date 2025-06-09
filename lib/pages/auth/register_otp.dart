// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:kawach/components/otp_input.dart';
// import 'package:kawach/pages/navigation.dart';

// class OtpPage extends StatefulWidget {
//   final String phoneNumber;

//   const OtpPage({super.key, required this.phoneNumber});

//   @override
//   State<OtpPage> createState() => _OtpPageState();
// }

// class _OtpPageState extends State<OtpPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String _verificationId = "";
//   bool _isLoading = false;
//   int _resendOtpTimer = 25;

//   final TextEditingController _field1 = TextEditingController();
//   final TextEditingController _field2 = TextEditingController();
//   final TextEditingController _field3 = TextEditingController();
//   final TextEditingController _field4 = TextEditingController();
//   final TextEditingController _field5 = TextEditingController();
//   final TextEditingController _field6 = TextEditingController();

//   final FocusNode _focus1 = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _startResendTimer();
//     _sendOtp();
//   }

//   @override
//   void dispose() {
//     _field1.dispose();
//     _field2.dispose();
//     _field3.dispose();
//     _field4.dispose();
//     _field5.dispose();
//     _field6.dispose();
//     _focus1.dispose();
//     super.dispose();
//   }

//   void _startResendTimer() {
//     Future.delayed(const Duration(seconds: 1), () {
//       if (mounted && _resendOtpTimer > 0) {
//         setState(() {
//           _resendOtpTimer--;
//         });
//         _startResendTimer();
//       }
//     });
//   }

//   Future<void> _sendOtp() async {
//     setState(() => _isLoading = true);
//     await _auth.verifyPhoneNumber(
//       phoneNumber: widget.phoneNumber,
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         _navigateToHome();
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Verification Failed: ${e.message}")),
//         );
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         setState(() {
//           _verificationId = verificationId;
//           _isLoading = false;
//         });
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         _verificationId = verificationId;
//       },
//     );
//   }

//   Future<void> _verifyOtp() async {
//     String otpCode = _field1.text + _field2.text + _field3.text + _field4.text + _field5.text + _field6.text;

//     if (otpCode.length != 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter a valid 6-digit OTP")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId,
//         smsCode: otpCode,
//       );
//       await _auth.signInWithCredential(credential);
//       _navigateToHome();
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Invalid OTP, please try again")),
//       );
//     }
//   }

//   void _navigateToHome() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const NavigationPage()),
//     );
//   }

//   Widget _otpBox(TextEditingController controller, FocusNode currentFocus, FocusNode? nextFocus) {
//     return SizedBox(
//       width: 45,
//       child: TextField(
//         controller: controller,
//         focusNode: currentFocus,
//         autofocus: currentFocus == _focus1,
//         onChanged: (value) {
//           if (value.length == 1 && nextFocus != null) {
//             FocusScope.of(context).requestFocus(nextFocus);
//           } else if (value.isEmpty && currentFocus != _focus1) {
//             FocusScope.of(context).previousFocus();
//           }
//         },
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         maxLength: 1,
//         style: const TextStyle(fontSize: 22, color: Colors.white),
//         decoration: const InputDecoration(
//           counterText: "",
//           border: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.blue),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/contactus.jpg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned.fill(
//             child: Container(color: Colors.black.withOpacity(0.3)),
//           ),
//           Positioned(
//             top: 100,
//             left: 20,
//             right: 20,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Verify your OTP",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   "Enter OTP sent to ${widget.phoneNumber}",
//                   style: const TextStyle(fontSize: 14, color: Colors.white),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     OtpInputWidget(_field1, true),
//                     const SizedBox(width: 10),
//                     OtpInputWidget(_field2, false),
//                     const SizedBox(width: 10),
//                     OtpInputWidget(_field3, false),
//                     const SizedBox(width: 10),
//                     OtpInputWidget(_field4, false),
//                     const SizedBox(width: 10),
//                     OtpInputWidget(_field5, false),
//                     const SizedBox(width: 10),
//                     OtpInputWidget(_field6, false),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: _verifyOtp,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text("Verify OTP", style: TextStyle(color: Colors.white, fontSize: 16)),
//                         ),
//                       ),
//                 const SizedBox(height: 15),
//                 if (_resendOtpTimer > 0)
//                   Text(
//                     "Resend OTP in $_resendOtpTimer sec",
//                     style: const TextStyle(color: Colors.white),
//                   )
//                 else
//                   TextButton(
//                     onPressed: _sendOtp,
//                     child: const Text("Resend OTP", style: TextStyle(color: Colors.blue)),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }