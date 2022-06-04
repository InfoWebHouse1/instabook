import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/model/model_user.dart';

class ExploreController extends GetxController {
  final authController = Get.put(AuthController());
  final userRef = FirebaseFirestore.instance.collection("Users");
  final firebaseFirestore = FirebaseFirestore.instance;
  QuerySnapshot? snapshot;

  var isExecuted = false.obs;
  //User? currentUser = FirebaseAuth.instance.currentUser;
  List<UserModel> userList = <UserModel>[].obs;
  Future<QuerySnapshot>? searchResult;
  TextEditingController searchController = TextEditingController();

  var updaters = Queue();
  var update_counter = "".obs;

  @override
  void onInit() {
    super.onInit();
    dataUpdate();
  }

  update1({from: ""}) {
    if (from != "") {
      updaters.add(from);
      // For tracking, who is calling this method
      if (updaters.length > 5) {
        updaters.removeFirst();
      }
    }
    update_counter.value =
        "cont_pr_list-${DateTime.now()} ${DateTime.now().microsecond} $updaters";
  }

  handleSearchUser(query) {
    Future<QuerySnapshot> user =
        userRef.where("name", isGreaterThanOrEqualTo: query).get();
    searchResult = user;
  }

  Future getData(String collection) async {
    QuerySnapshot? querySnapshot =
        await firebaseFirestore.collection(collection).get();
    return querySnapshot.docs;
  }

  Future queryData(String queryString) async {
    return userRef.where("name", isEqualTo: queryString).get();
  }

  Future<List<UserModel>> fetchAllUsers() async {
    List<UserModel> list = <UserModel>[];

    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection("Users").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != authController.user!.uid) {
        list.add(UserModel.fromMap(
            querySnapshot.docs[i].data() as Map<String, dynamic>));
      }
    }
    return list;
  }

  dataUpdate() {
    fetchAllUsers().then(
      (List<UserModel> list) {
        userList = list;
        update();
      },
    );
  }
}
