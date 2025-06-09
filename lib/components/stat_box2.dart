import 'package:flutter/material.dart' hide Colors;
import 'package:kawach/constant/color.dart';
import 'package:kawach/utils/style.dart';

class StatBox2 extends StatelessWidget {
  const StatBox2({super.key, this.icon, this.title, this.iconColor, this.value});
  final IconData? icon;
  final String? title;
  final String? value;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(blurRadius: 30, color: Colors.shadow)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, color: iconColor ?? Colors.gray),
          const SizedBox(height: 2),
          Text("$title", style: caption(color: Colors.gray)),
          const SizedBox(height: 3),
          Text("$value", style: subTitle1(fontWeight: FontWeight.w600, fontSize: 16)),
        ],
      ),
    );
  }
}
