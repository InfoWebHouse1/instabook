// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ProfileData1 extends StatelessWidget {
  const ProfileData1({Key? key, this.postCount, this.followerCount, this.followingCount,required this.color}) : super(key: key);

  final String? postCount;
  final String? followerCount;
  final String? followingCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Todo: post Column
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              postCount!,
              style: TextStyle(
                fontSize: 14.6,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              "Post",
              style: TextStyle(
                fontSize: 14.6,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(width: 10,),
        //Todo: Follower Column
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              followerCount!,
              style: TextStyle(
                fontSize: 14.6,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              "Follower",
              style: TextStyle(
                fontSize: 14.6,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(width: 10,),
        //Todo: post Column
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              followingCount!,
              style: TextStyle(
                fontSize: 14.6,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              "Following",
              style: TextStyle(
                fontSize: 14.6,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(width: 10,),
      ],
    );
  }
}
