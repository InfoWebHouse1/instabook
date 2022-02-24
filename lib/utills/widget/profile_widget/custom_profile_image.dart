// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomProfileImage extends StatelessWidget {
  const CustomProfileImage({Key? key, required this.imageVal}) : super(key: key);

  final String imageVal;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      radius: 43,
      child: ClipOval(
        child: SizedBox(
          width: 80,
          height: 80,
          child: Image.network(
                  "$imageVal",
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

class CustomAssetsProfileImage extends StatelessWidget {

  final String imageVal;

  const CustomAssetsProfileImage({Key? key, required this.imageVal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      radius: 43,
      child: ClipOval(
        child: SizedBox(
          width: 80,
          height: 80,
          child:Image.asset(
                  imageVal,
                  fit: BoxFit.cover,
                )
        ),
      ),
    );
  }
}