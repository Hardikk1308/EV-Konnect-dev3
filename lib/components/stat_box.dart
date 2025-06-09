import 'package:flutter/material.dart' hide Colors;
import 'package:kawach/constant/color.dart';
import 'package:kawach/utils/style.dart';

class StatBox extends StatelessWidget {
  const StatBox({super.key, this.ext, this.value, this.title});
  final String? title;
  final String? value;
  final String? ext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.info.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.info),
      ),
      child: Column(
        children: [
          Text("$title", style: subTitle1(fontSize: 16)),
          RichText(
            text: TextSpan(
              text: "$value",
              style: subTitle1(fontWeight: FontWeight.w600, fontSize: 16),
              children: [TextSpan(text: " $ext", style: subTitle1(fontSize: 16))],
            ),
          ),
        ],
      ),
    );
  }
}
