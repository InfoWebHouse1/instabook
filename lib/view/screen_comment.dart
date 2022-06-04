// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/controllers/controller_post.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class CommentScreen extends StatelessWidget {
  final generalController = Get.put(GeneralController());
  final commentController = Get.put(PostController());

  final String postId;
  final String ownerId;
  final String mediaUrl;

  CommentScreen({
    Key? key,
    required this.postId,
    required this.ownerId,
    required this.mediaUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: CustomText(
            "Comment",
            generalController.isThemeDark.value ? Colors.white : Colors.black,
            FontWeight.bold,
            30.5,
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back),
            color: generalController.isThemeDark.value
                ? Colors.white
                : Colors.black,
          ),
          centerTitle: true,
        ),
        body: buildComment(context),
      ),
    );
  }

  buildComment(context) {
    return Column(
      children: [
        Expanded(child: buildUserComment() ?? Text("Comment")),
        Divider(),
        ListTile(
          title: TextFormField(
            controller: commentController.commentController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Write a Comment....",
              filled: true,
              fillColor: Colors.white,
              hintStyle: TextStyle(
                color: Colors.black54,
                fontSize: 16.4,
              ),
            ),
          ),
          trailing: IconButton(
              onPressed: () => commentController.createCommentInFirestore(
                    postId: postId,
                    ownerId: ownerId,
                    mediaUrl: mediaUrl,
                  ),
              icon: Icon(Icons.comment),
              color: Theme.of(context).colorScheme.secondary),
        )
      ],
    );
  }

  buildUserComment() {
    return StreamBuilder<QuerySnapshot>(
        stream: commentController.firestore
            .collection("comments")
            .doc(postId)
            .collection("users_comment")
            .orderBy("timeStamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<Comments> comment = [];
          for (var doc in snapshot.data!.docs) {
            comment.add(Comments.fromDocument(doc: doc));
          }
          return ListView(
            children: comment,
          );
        });
  }
}

class Comments extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final String comment;
  final Timestamp timeStamp;
  final String userId;

  const Comments({
    Key? key,
    required this.userId,
    required this.comment,
    required this.avatarUrl,
    required this.timeStamp,
    required this.username,
  }) : super(key: key);

  factory Comments.fromDocument({required DocumentSnapshot doc}) {
    return Comments(
      userId: doc["userId"],
      username: doc["userName"],
      avatarUrl: doc["avatarUrl"],
      comment: doc["comment"],
      timeStamp: doc["timeStamp"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            comment,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(
            timeAgo.format(timeStamp.toDate()),
          ),
        ),
        Divider(),
      ],
    );
  }
}
