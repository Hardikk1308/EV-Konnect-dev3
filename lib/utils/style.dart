import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kawach/constant/color.dart';

TextStyle h5({
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.w400,
  double fontSize = 24,
}) => TextStyle(
  fontFamily: 'Poppins',
  color: color,
  fontWeight: fontWeight,
  fontSize: fontSize.sp,
);

TextStyle h6({
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.w600,
  double fontSize = 20,
}) => TextStyle(
  fontFamily: 'Poppins',
  color: color,
  fontWeight: fontWeight,
  fontSize: fontSize.sp,
);

TextStyle subTitle1({
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.w400,
  double fontSize = 16,
}) => TextStyle(
  fontFamily: 'Poppins',
  color: color,
  fontWeight: fontWeight,
  fontSize: fontSize.sp,
);

TextStyle subTitle2({
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.w500,
  double fontSize = 14,
}) => TextStyle(
  fontFamily: 'Poppins',
  color: color,
  fontWeight: fontWeight,
  fontSize: fontSize.sp,
);

TextStyle bodyText({
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.w400,
  double fontSize = 16,
}) => TextStyle(
  fontFamily: 'Poppins',
  color: color,
  fontWeight: fontWeight,
  fontSize: fontSize.sp,
);

TextStyle buttonText({
  Color color = Colors.white,
  FontWeight fontWeight = FontWeight.w500,
  double fontSize = 14,
}) => TextStyle(
  fontFamily: 'Poppins',
  color: color,
  fontWeight: fontWeight,
  fontSize: fontSize.sp,
);

TextStyle caption({
  Color color = Colors.textLabel,
  FontWeight fontWeight = FontWeight.w400,
  double fontSize = 14,
}) => TextStyle(
  fontFamily: 'Poppins',
  color: color,
  fontWeight: fontWeight,
  fontSize: fontSize.sp,
);

TextStyle overline({
  Color color = Colors.textLabel,
  FontWeight fontWeight = FontWeight.w400,
  double fontSize = 10,
}) => TextStyle(
  fontFamily: 'Poppins',
  color: color,
  fontWeight: fontWeight,
  fontSize: fontSize.sp,
);

InputDecoration textFieldDecoration({
  String? hintText,
  Widget? suffixIcon,
  Widget? prffixIcon,
}) => InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
  fillColor: Colors.textFieldBG,
  filled: true,
  isDense: true,
  hintText: hintText ?? "",
  hintStyle: bodyText(color: Colors.textLabel),
  prefixIcon: prffixIcon,
  suffixIcon: suffixIcon,
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.primary),
    borderRadius: BorderRadius.circular(50.r),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(width: 0.5, color: Colors.textFieldBG),
    borderRadius: BorderRadius.circular(50.r),
  ),
);

ButtonStyle primaryButtonStyle({Color? backgroundColor, Color? borderColor}) =>
    ButtonStyle(
      overlayColor: WidgetStatePropertyAll(
        backgroundColor == Colors.transparent
            ? Colors.textLabel.withOpacity(0.1)
            : Colors.white.withOpacity(0.15),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          side:
              borderColor != null
                  ? BorderSide(color: borderColor)
                  : BorderSide.none,
          borderRadius: BorderRadius.circular(50.r),
        ),
      ),
      elevation: const WidgetStatePropertyAll(0.0),
      backgroundColor: WidgetStatePropertyAll(
        backgroundColor ?? Colors.primary,
      ),
    );
