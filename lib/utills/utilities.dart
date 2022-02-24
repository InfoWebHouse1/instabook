// ignore_for_file: non_constant_identifier_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

CustomText(String text, Color color, FontWeight fontWeight, double fontSize) {
  return Text(
    text,
    style: GoogleFonts.cookie(color: color, fontWeight: fontWeight, fontSize: fontSize),
  );
}

CustomRichText(String firstText, String lastText, Function()? onPressed) {
  return RichText(
    text: TextSpan(
      text: firstText,
      style: GoogleFonts.roboto(
        color: Colors.grey,
      ),
      children: <TextSpan>[
        TextSpan(
            text: lastText,
            style: GoogleFonts.roboto(
              color: Colors.blueAccent,
            ),
            recognizer: TapGestureRecognizer()..onTap = onPressed),
      ],
    ),
  );
}
