import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kawach/constant/color.dart';
import 'package:kawach/constant/image.dart';

class CirculerImage extends StatelessWidget {
  const CirculerImage({super.key, this.size = 70});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.r,
      width: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.textFieldBG,
        border: Border.all(color: Colors.textFieldBG),
      ),
      child: ClipOval(child: Image.asset(userIcon, fit: BoxFit.cover)),
    );
  }
}
