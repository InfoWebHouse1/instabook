// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomProfileImage extends StatelessWidget {
  const CustomProfileImage({
    Key? key,
    required this.imageVal,
    required this.radius,
  }) : super(key: key);

  final String imageVal;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      backgroundImage: CachedNetworkImageProvider("$imageVal"),
      radius: radius,
    );
  }
}

class CustomAssetsProfileImage extends StatelessWidget {
  final String imageVal;

  const CustomAssetsProfileImage({Key? key, required this.imageVal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      radius: 43,
      child: ClipOval(
        child: SizedBox(
            width: 80,
            height: 80,
            child: Image.asset(
              imageVal,
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
