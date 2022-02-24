import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Container(
        height: 0.5,
        color: Colors.grey,
      ),
    );
  }
}