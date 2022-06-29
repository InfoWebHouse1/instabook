// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/utills/widget/profile_widget/custom_main_profile_posts.dart';

class FullPostScreen extends StatelessWidget {
  final generalController = Get.put(GeneralController());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String postId;
  final String userId;

  FullPostScreen({
    Key? key,
    required this.postId,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: firestore
            .collection("posts")
            .doc(userId)
            .collection("user_posts")
            .doc(postId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var post = MainProfilePosts.fromDocument(doc: snapshot.data!);
          return Center(
            child: Scaffold(
              appBar: AppBar(
                title: CustomText(
                  "Photo",
                  generalController.isThemeDark.value
                      ? Colors.white
                      : Colors.black,
                  FontWeight.bold,
                  30.5,
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: generalController.isThemeDark.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              body: ListView(
                children: [
                  Container(
                    child: post,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
