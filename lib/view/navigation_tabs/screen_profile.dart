// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/controllers/controller_post.dart';
import 'package:instabook/controllers/controller_profile.dart';
import 'package:instabook/controllers/controller_user.dart';
import 'package:instabook/model/model_posts.dart';
import 'package:instabook/model/model_user.dart';
import 'package:instabook/services/services_database.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/utills/widget/profile_widget/custom_main_profile_data.dart';
import 'package:instabook/utills/widget/profile_widget/custom_main_profile_posts.dart';
import 'package:instabook/utills/widget/profile_widget/custom_profile_edit_button.dart';
import 'package:instabook/utills/widget/profile_widget/custom_profile_image.dart';
import 'package:instabook/view/screen_edit_profile_screen.dart';
import 'package:instabook/view/screen_full_post_screen.dart';
import 'package:instabook/view/screen_setting_profile.dart';

class ProfileScreen extends StatelessWidget {
  final String? currentUserId;

  ProfileScreen({
    Key? key,
    required this.currentUserId,
  }) : super(key: key);
  final authController = Get.put(AuthController());
  final profileController = Get.put(ProfileController());
  final postController = Get.put(PostController());
  final userController = Get.put(UserController());
  final generalController = Get.put(GeneralController());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    profileController.checkIfFollowing(profileId: currentUserId);
    profileController.getFollower(profileId: currentUserId);
    profileController.getFollowing(profileId: currentUserId);
    bool isMainProfile = currentUserId == authController.user!.uid;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.5),
      appBar: AppBar(
        title: CustomText(
          "Profile",
          generalController.isThemeDark.value ? Colors.white : Colors.black,
          FontWeight.bold,
          30.5,
        ),
        leading: currentUserId == FirebaseAuth.instance.currentUser?.uid ? Text("") : IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: generalController.isThemeDark.value
                ? Colors.white
                : Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          isMainProfile
              ? IconButton(
                  onPressed: () {
                    Get.to(() => ProfileSettingPage());
                  },
                  icon: Icon(Icons.settings),
                  color: Theme.of(context).iconTheme.color,
                )
              : SizedBox(),
        ],
      ),
      body: SafeArea(
        child: buildBody(context, isMainProfile),
      ),
    );
  }

  buildBody(context, isMainProfile) {
    print(
        "${authController.update_counter} ${profileController.update_counter} ${postController.update_counter}");
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor.withOpacity(0.5)),
      child: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("posts")
            .doc(authController.user!.uid)
            .collection("user_posts")
            .orderBy(
              "timeStamp",
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<MainProfilePosts> posts = [];
          for (var doc in snapshot.data!.docs) {
            posts.add(MainProfilePosts.fromDocument(doc: doc));
          }
          return Column(
            children: [
              buildProfileHeader(
                isMainProfile,
                context: context,
                postCount: snapshot.data!.docs.length,
                follower: 0,
                following: 0,
              ),
              Container(
                padding: const EdgeInsets.only(top: 8.0),
                color: Theme.of(context).backgroundColor,
                child: Divider(
                  color: Colors.grey,
                  height: 3.0,
                ),
              ),
              Obx(
                () => Container(
                  color: Theme.of(context).backgroundColor,
                  child: buildToggole(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8.0),
                color: Theme.of(context).backgroundColor,
                child: Divider(
                  color: Colors.grey,
                  height: 3.0,
                ),
              ),
              Expanded(
                child: Obx(
                  () => Container(
                    color: Theme.of(context).backgroundColor,
                    child: buildPostOrientation(context, snapshot, posts),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  buildToggole(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () => postController.setPostOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postController.postOrientation.value == "grid"
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => postController.setPostOrientation("list"),
          icon: Icon(Icons.list),
          color: postController.postOrientation.value == "list"
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
      ],
    );
  }

  buildPostOrientation(context, snapshot, post) {
    if (postController.postOrientation.value == "grid") {
      return buildGrid(snapshot);
    } else if (postController.postOrientation.value == "list") {
      return buildList(post);
    }
  }

  buildGrid(snapshot) {
    return GridView.builder(
      itemCount: snapshot.data!.size,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 1.5,
          crossAxisSpacing: 1.5),
      itemBuilder: (context, index) {
        var data = snapshot.data!.docs[index];
        return GestureDetector(
          onTap: () => Get.to(
            () => FullPostScreen(
              postId: data["post_id"],
              userId: data["owner_id"],
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: '${data["mediaUrl"]}',
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  buildList(posts) {
    return ListView(
      children: posts,
    );
  }

  buildProfileHeader(isMainProfile, {context, postCount, follower, following}) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        UserModel user =
            UserModel.fromDocumentSnapshot(documentSnapshot: snapshot.data!);
        return Container(
          height: Get.height * 0.3,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.white,
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //todo: Profile Image
                      CustomProfileImage(
                        imageVal: "${user.imageUrl}",
                        radius: 40,
                      ),
                      //todo: profile post follower following
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: Get.width * 0.5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //Todo: post Column
                                  buildCountColumn(
                                      count: postCount, name: "Posts"),
                                  //Todo: Follower Column
                                  Obx(
                                    () => buildCountColumn(
                                        count: profileController
                                            .followersCount.value,
                                        name: "Followers"),
                                  ),
                                  //Todo: post Column
                                  Obx(
                                    () => buildCountColumn(
                                        count: profileController
                                            .followingCount.value,
                                        name: "Following"),
                                  ),
                                ],
                              ),
                            ),
                            //todo: Edit Button
                            SizedBox(
                              width: Get.width,
                              child: Center(
                                child: Obx(
                                  () => buildProfileButton(
                                    isMainProfile: isMainProfile,
                                    val: profileController.isFollowing.value,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //todo: Name
              MainProfileData(
                width: Get.width,
                text: "${user.name}",
                fontSize: 18.0,
                hasLine: false,
                fontWeight: FontWeight.bold,
                color: generalController.isThemeDark.value
                    ? Colors.white
                    : Colors.black,
              ),
              //todo: Bio
              MainProfileData(
                width: Get.width * 0.5,
                text: "${user.bio}",
                fontSize: 15.4,
                hasLine: true,
                fontWeight: FontWeight.normal,
                color: generalController.isThemeDark.value
                    ? Colors.white
                    : Colors.black,
              ),
            ],
          ),
        );
      },
    );
  }

  buildProfileButton({isMainProfile, val}) {
    if (isMainProfile) {
      return CustomButton(
        controller: generalController,
        name: "Edit Profile",
        onPressed: () => Get.to(() => EditProfileScreen()),
      );
    } else if (val) {
      return CustomButton(
        controller: generalController,
        name: "Unfollow",
        onPressed: () =>
            profileController.handleUnFollowUser(profileId: currentUserId),
      );
    } else if (!val) {
      return CustomButton(
        controller: generalController,
        name: "Follow",
        onPressed: () =>
            profileController.handleFollowUser(profileId: currentUserId),
      );
    }
  }

  buildCountColumn({required int count, required String name}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 14.6,
            fontWeight: FontWeight.bold,
            color: generalController.isThemeDark.value
                ? Colors.white
                : Colors.black,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 14.6,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
