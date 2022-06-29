// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/controllers/controller_timeline.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/utills/widget/profile_widget/custom_main_profile_posts.dart';

class HomeScreen extends StatelessWidget {
  final String? currentUserId;

  HomeScreen({Key? key, required this.currentUserId}) : super(key: key);
  final timelineController = Get.put(TimelineController());
  final generalController = Get.put(GeneralController());

  @override
  Widget build(BuildContext context) {
    timelineController.getTimelineUser();
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: CustomText(
            "Home",
            generalController.isThemeDark.value ? Colors.white : Colors.black,
            FontWeight.bold,
            30.5,
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: timelineRef
                .doc(currentUserId)
                .collection("timelinePosts")
                .orderBy(
                  "timeStamp",
                  descending: true,
                )
                .snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              //List<MainProfilePosts> posts = [];
              for (var doc in snap.data!.docs) {
                timelineController.post.add(MainProfilePosts.fromDocument(doc: doc));
              }
              return ListView(
                children: timelineController.post,
              );
            }));
  }

  // buildTimeline() {
  //   print(timelineController.update_counter);
  //   if (timelineController.post == null) {
  //     return CircularProgressIndicator();
  //   } else if (timelineController.post.isEmpty) {
  //     return Center(
  //       child: Text("No Posts Yet"),
  //     );
  //   } else {
  //     return ListView(
  //       children: timelineController.post,
  //     );
  //   }
  // }
}
