import 'package:flutter/material.dart';

class Authprovider extends ChangeNotifier {
  bool _hasSignedInProgress = false;
  bool get getSignedInProgress => _hasSignedInProgress;
  set setSignedInProgress(bool hasSignedIn) {
    _hasSignedInProgress = hasSignedIn;
    notifyListeners();
  }

  bool _hasOtpProgress = false;
  bool get getOtpProgress => _hasOtpProgress;
  set setOtpProgress(bool hasOtpProgress) {
    _hasOtpProgress = hasOtpProgress;
    notifyListeners();
  }

  Future<void> phoneNoVerification(
    BuildContext context, {
    required String phone,
  }) async {
    // FirebaseAuth _auth = FirebaseAuth.instance;
    // await _auth.verifyPhoneNumber(
    //   phoneNumber: "+91$phone",
    //   verificationCompleted: (phoneAuthCredential) {
    //     print("complete $phoneAuthCredential");
    //     setSignedInProgress = false;
    //     showSnackBar(context, "user successfully verified");
    //   },
    //   verificationFailed: (authException) {
    //     print(authException);
    //     setSignedInProgress = false;
    //     if (authException.code == 'invalid-phone-number')
    //       showSnackBar(context, "invalid phone number, enter again");
    //     else
    //       showSnackBar(context, "User Verification Failed, try again");
    //   },
    //   codeSent: (verificationId, forceResendingToken) {
    //     setSignedInProgress = false;
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => OtpPage()),
    //     );
    //   },
    //   codeAutoRetrievalTimeout: (verificationId) {},
    // );

    // notifyListeners();
  }
}
