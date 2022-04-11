// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProfileData2 extends StatelessWidget {
  const ProfileData2({
    Key? key,
    required this.width,
    required this.text,
    required this.fontSize,
    required this.hasLine,
    required this.fontWeight,
    required this.color,
  }) : super(key: key);
  final double width;
  final String text;
  final double fontSize;
  final bool hasLine;
  final FontWeight fontWeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 5.0),
        child: Text(
          text,
          maxLines: hasLine ? 6 : null,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ),
        ),
      ),
    );
  }
}
