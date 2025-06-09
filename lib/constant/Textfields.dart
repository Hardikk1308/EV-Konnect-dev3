import 'package:flutter/material.dart';

const kTextFormFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
);

class CustomFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextInputType Keyboard;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  CustomFormField({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    this.validator,
    required this.icon,
    required this.Keyboard,
    required TextInputType keyboardType, required TextStyle hintStyle,
  }) : super(key: key);

  // Default border for the text field
  final border = OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(16.0),
  );

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white70,
      keyboardType: widget.Keyboard,
      controller: widget.controller,
      obscureText: _obscureText,
      
      decoration: kTextFormFieldDecoration.copyWith(
        
        hintText: widget.hintText,
       hintStyle: const TextStyle(color: Colors.white70,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(widget.icon),
        prefixIconColor:  Colors.white70,
        border: widget.border,
        fillColor: Colors.grey[700],
        filled: true,
        suffixIcon:
            widget.obscureText
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleObscureText,
                )
                : null,
             suffixIconColor: Colors.white70
      ),
      validator: widget.validator,
    );
  }
}
