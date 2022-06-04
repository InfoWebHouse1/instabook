// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/controllers/controller_post.dart';
import 'package:instabook/controllers/controller_user.dart';
import 'package:instabook/services/service_sharedPreferecnce.dart';
import 'package:instabook/services/services_database.dart';
import 'package:instabook/utills/widget/profile_widget/custom_main_profile_data.dart';
import 'package:instabook/utills/widget/profile_widget/custom_profile_image.dart';
import 'package:instabook/view/screen_comment.dart';

class MainProfilePosts extends StatelessWidget {
  final generalController = Get.put(GeneralController());
  final postController = Get.put(PostController());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String postID;
  final String ownerID;
  final String userName;
  final String caption;
  final String mediaUrl;
  final String location;
  final Map likes;
  int? likesCount;

  MainProfilePosts({
    Key? key,
    required this.postID,
    required this.ownerID,
    required this.userName,
    required this.caption,
    required this.mediaUrl,
    required this.location,
    required this.likes,
    this.likesCount,
  }) : super(key: key);

  factory MainProfilePosts.fromDocument({required DocumentSnapshot doc}) {
    return MainProfilePosts(
      postID: doc["post_id"],
      ownerID: doc["owner_id"],
      userName: doc["userName"],
      caption: doc["caption"],
      mediaUrl: doc["mediaUrl"],
      location: doc["location"],
      likes: doc["likes"],
    );
  }

  int getLikeCount(_likes) {
    if (_likes == null) {
      return 0;
    }
    int count = 0;
    for (var val in _likes.values) {
      if (val == true) {
        count += 1;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    likesCount = getLikeCount(likes);
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildPostHeader(),
          buildPostImage(),
          buildPostFooter(),
          Divider(),
        ],
      ),
    );
  }

  buildPostFooter() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
              GestureDetector(
                onTap: handleLikes,
                child: Icon(
                  postController.isLiked.value
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.pink,
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 20.0)),
              GestureDetector(
                onTap: () => Get.to(
                  CommentScreen(
                    postId: postID,
                    ownerId: ownerID,
                    mediaUrl: mediaUrl,
                  ),
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text(
                  "$likesCount Likes",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                caption,
                style: TextStyle(color: Colors.grey),
              ))
            ],
          )
        ],
      ),
    );
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: handleLikes,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(mediaUrl),
              )),
            ),
          ),
          postController.showHeart.value
              ? AnimateWidget(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  cycles: 0,
                  builder: (context, anim) {
                    return ScaleTransition(
                      scale: anim.curvedAnimation,
                      child: Icon(
                        Icons.favorite,
                        size: 80,
                        color: Colors.red,
                      ),
                    );
                  })
              : SizedBox(),
        ],
      ),
    );
  }

  buildPostHeader() {
    return ListTile(
      leading: GetX<UserController>(initState: (_) async {
        Get.find<UserController>().user = await UserDataBase().getUser(ownerID);
      }, builder: (_) {
        if (_.user!.imageUrl != "") {
          return CustomProfileImage(
            imageVal: "${_.user!.imageUrl}",
            radius: 20,
          );
        } else {
          return CustomAssetsProfileImage(
            imageVal: "assets/images/default_image.png",
          );
        }
      }),
      title: MainProfileData(
        width: Get.width,
        text: userName,
        fontSize: 18.4,
        hasLine: false,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      subtitle: MainProfileData(
        width: Get.width,
        text: location,
        fontSize: 14.6,
        hasLine: false,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
      trailing: IconButton(
          onPressed: () => print("Delete"),
          icon: Icon(
            Icons.delete_outline,
            color: Colors.red,
          )),
    );
  }

  handleLikes() async {
    bool _isLiked = likes[ownerID] == true;
    if (_isLiked) {
      firestore
          .collection("posts")
          .doc(ownerID)
          .collection("user_posts")
          .doc(postID)
          .update({"likes.$ownerID": false});
      postController.removeLikeToNotification(
        postId: postID,
        ownerId: ownerID,
      );
      likesCount = likesCount! - 1;
      bool liked = postController.isLiked.value = false;
      await UseSimplePreference.setLikeValue(liked);
      likes[ownerID] == false;
    } else if (!_isLiked) {
      firestore
          .collection("posts")
          .doc(ownerID)
          .collection("user_posts")
          .doc(postID)
          .update({"likes.$ownerID": true});
      postController.addLikeToNotification(
        postId: postID,
        ownerId: ownerID,
        mediaUrl: mediaUrl,
      );
      likesCount = likesCount! + 1;
      bool liked = postController.isLiked.value = true;
      await UseSimplePreference.setLikeValue(liked);
      likes[ownerID] == true;
      postController.showHeart.value = true;
      Timer(Duration(milliseconds: 500), () {
        postController.showHeart.value = false;
      });
    }
  }
}
