import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:instabook/services/services_database.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/utills/widget/profile_widget/custom_main_profile_posts.dart';

class TimelineController extends GetxController {
  List<MainProfilePosts> post = [];

  var updaters = Queue();
  var update_counter = "".obs;

  update1({from: ""}) {
    if (from != "") {
      updaters.add(from);
      // For tracking, who is calling this method
      if (updaters.length > 5) {
        updaters.removeFirst();
      }
    }
    update_counter.value = "cont_pr_list-${DateTime.now()} ${DateTime.now().microsecond} $updaters";
  }

  getTimelineUser() async {
    var userId = await UserDataBase().getUser(FirebaseAuth.instance.currentUser!.uid);
    QuerySnapshot snapshot = await timelineRef.doc(userId!.id).collection(
        "timelinePosts").orderBy("timeStamp", descending: true).get();
    List<MainProfilePosts> mainPost = snapshot.docs.map((doc) => MainProfilePosts.fromDocument(doc: doc)).toList();
    post = mainPost;
  }
}