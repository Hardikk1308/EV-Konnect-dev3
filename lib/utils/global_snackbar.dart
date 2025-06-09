import 'package:flutter/material.dart' hide Colors;
import 'package:kawach/constant/color.dart';

void showSnackBar(BuildContext context, String value, {Color? color = Colors.red}) {
    final snackBar = SnackBar(
      content: Text(value),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }