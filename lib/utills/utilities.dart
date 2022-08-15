// ignore_for_file: non_constant_identifier_names, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



//Todo: collection references
final userRef = FirebaseFirestore.instance.collection("Users");
final postRef = FirebaseFirestore.instance.collection("posts");
final commentRef = FirebaseFirestore.instance.collection("comments");
final notificationRef = FirebaseFirestore.instance.collection("feed");
final followerRef = FirebaseFirestore.instance.collection("followers");
final followingRef = FirebaseFirestore.instance.collection("following");
final timelineRef = FirebaseFirestore.instance.collection("timeline");


var kPrimaryLight = const Color(0xFF64D8CB);
var kPrimaryDark = const Color(0xFF00766C);
var kSecondaryLight = const Color(0xFFB085F5);
var kSecondaryDark = const Color(0xFF4D2C91);
var kBackgroundDark = const Color(0xFF4B636E);
var kWhiteColor = Colors.white;
var kBlackColor = Colors.black;

CustomText(String text, Color color, FontWeight fontWeight, double fontSize) {
  return Text(
    text,
    style: GoogleFonts.cookie(
        color: color, fontWeight: fontWeight, fontSize: fontSize),
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

