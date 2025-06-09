import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kawach/constant/Buttons.dart';
import 'package:kawach/pages/auth/loginpage.dart';
import 'dart:ui';
import 'package:kawach/pages/otp.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  // Added state variables for toggling password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => OtpPage(
                    phoneNumber: '+91${_mobileController.text.trim()}',
                  ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/unsplash001.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Create your Konnect account",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(height: 25),
                          _glassTextField("Username", _usernameController),
                          const SizedBox(height: 15),
                          _glassTextField(
                            "Email",
                            _emailController,
                            isEmail: true,
                          ),
                          const SizedBox(height: 15),
                          _glassTextField(
                            "Mobile No.",
                            _mobileController,
                            isPhone: true,
                          ),
                          const SizedBox(height: 15),
                          _glassTextField(
                            "Password",
                            _passwordController,
                            isPassword: true,
                          ),
                          const SizedBox(height: 15),
                          _glassTextField(
                            "Confirm Password",
                            _confirmPasswordController,
                            isPassword: true,
                            isConfirm: true,
                          ),
                          const SizedBox(height: 25),
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : CommonButton(
                                text: "Register",
                                onPressed: _registerUser,
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RichText(
                  text: TextSpan(
                    text: 'Already have account? ',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[400]!,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue[700]!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassTextField(
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
    bool isEmail = false,
    bool isPhone = false,
    bool isConfirm = false,
  }) {
    return TextFormField(
      controller: controller,
      // Update obscureText based on which field it is
      obscureText:
          isPassword
              ? _obscurePassword
              : isConfirm
              ? _obscureConfirmPassword
              : false,
      keyboardType:
          isEmail
              ? TextInputType.emailAddress
              : isPhone
              ? TextInputType.phone
              : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon:
            isEmail
                ? const Icon(Icons.email, color: Colors.white54)
                : isPhone
                ? const Icon(Icons.phone, color: Colors.white54)
                : isPassword || isConfirm
                ? const Icon(Icons.lock, color: Colors.white54)
                : const Icon(Icons.person, color: Colors.white54),
        suffixIcon:
            (isPassword || isConfirm)
                ? IconButton(
                  icon: Icon(
                    (isPassword ? _obscurePassword : _obscureConfirmPassword)
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.white54,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isPassword) {
                        _obscurePassword = !_obscurePassword;
                      } else if (isConfirm) {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      }
                    });
                  },
                )
                : null,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Please enter $hint";
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Enter a valid email";
        }
        if (isPhone &&
            (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value))) {
          return "Enter valid 10-digit number";
        }
        if (isPassword && value.length < 6) {
          return "Minimum 6 characters";
        }
        if (isConfirm && value != _passwordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }
}
