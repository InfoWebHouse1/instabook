// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/view/navigation_tabs/screen_profile.dart';
import 'package:instabook/view/screen_full_post_screen.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class NotificationScreen extends StatelessWidget {
  final String? currentUserid;

  NotificationScreen({Key? key, this.currentUserid}) : super(key: key);
  final generalController = Get.put(GeneralController());
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
          "Notification",
          generalController.isThemeDark.value ? Colors.white : Colors.black,
          FontWeight.bold,
          30.5,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("feed")
            .doc(authController.user!.uid)
            .collection("feed_items")
            .orderBy("timeStamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("Loading..."),
            );
          }
          List<NotificationItems> notifyItem = [];
          for (var doc in snapshot.data!.docs) {
            notifyItem.add(NotificationItems.fromDocument(doc: doc));
          }
          return ListView(
            children: notifyItem,
          );
        },
      ),
    );
  }
}

class NotificationItems extends StatelessWidget {
  Widget? mediaPreview;
  String? notificationItemText;

  final String type;
  final String userName;
  final String userId;
  final String postId;
  final String mediaUrl;
  final String userImgUrl;
  final String commentData;
  final Timestamp timeStamp;

  NotificationItems({
    Key? key,
    required this.type,
    required this.userId,
    required this.userName,
    required this.postId,
    required this.mediaUrl,
    required this.userImgUrl,
    required this.commentData,
    required this.timeStamp,
  }) : super(key: key);

  factory NotificationItems.fromDocument({required DocumentSnapshot doc}) {
    return NotificationItems(
      type: doc["type"],
      userId: doc["userId"],
      userName: doc["userName"],
      postId: doc["postId"],
      mediaUrl: doc["mediaUrl"],
      userImgUrl: doc["userProfileImg"],
      commentData: doc["commentData"],
      timeStamp: doc["timeStamp"],
    );
  }

  configureMediaPreview() {
    if (type == "like" || type == "comment") {
      mediaPreview = GestureDetector(
        onTap: () => Get.to(
          () => FullPostScreen(
            postId: postId,
            userId: userId,
          ),
        ),
        child: SizedBox(
          height: 50,
          width: 50,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(mediaUrl),
              )),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = SizedBox();
    }

    if (type == "like") {
      notificationItemText = "liked your post";
    } else if (type == "comment") {
      notificationItemText = "replied: ${commentData.trim()}";
    } else if (type == "follow") {
      notificationItemText = "is following you";
    } else {
      notificationItemText = "Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview();
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
        child: ListTile(
          title: GestureDetector(
            onTap: () => Get.to(
              () => ProfileScreen(
                currentUserId: userId.toString(),
              ),
            ),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(fontSize: 14.0, color: Colors.black),
                children: [
                  TextSpan(
                    text: userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: " $notificationItemText",
                  ),
                ],
              ),
            ),
          ),
          subtitle: Text(
            timeAgo.format(timeStamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userImgUrl),
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}
