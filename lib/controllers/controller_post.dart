// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/services/service_sharedPreferecnce.dart';
import 'package:instabook/services/services_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

class PostController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final authController = Get.put(AuthController());

  final locationController = TextEditingController();
  final captionController = TextEditingController();
  final commentController = TextEditingController();

  var isLoadingUploadForm = false.obs;
  var isUploading = false.obs;
  var postOrientation = "grid".obs;
  var isLiked = false.obs;
  var showHeart = false.obs;

  File? imageFile;
  var imageURl = "".obs;
  String _postID = Uuid().v4();

  final ImagePicker picker = ImagePicker();
  final DateTime timeStamp = DateTime.now();

  final Reference storageReference = FirebaseStorage.instance.ref();

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
    update_counter.value =
        "cont_pr_list-${DateTime.now()} ${DateTime.now().microsecond} $updaters";
  }

  Future handleTakePicFromCamera() async {
    Get.back();
    var file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 20,
      maxHeight: 675,
      maxWidth: 960,
    );
    imageFile = File(file!.path);
    isLoadingUploadForm.value = true;
    update();
    print("Image Path $imageFile");
  }

  Future handleTakePicFromGallery() async {
    Get.back();
    var file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    imageFile = File(file!.path);
    isLoadingUploadForm.value = true;
    update();
    print("Image Path $imageFile");
  }

  selectImage(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create Post"),
            children: [
              SimpleDialogOption(
                onPressed: handleTakePicFromCamera,
                child: Text("Image from Camera"),
              ),
              SimpleDialogOption(
                onPressed: handleTakePicFromGallery,
                child: Text("Image from Gallery"),
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Get.back(),
              ),
            ],
          );
        });
  }

  Future compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    var imageFile2 = Im.decodeImage(imageFile!.readAsBytesSync());
    final compressedImageFile = File("$path/img_$_postID.jpg")
      ..writeAsBytesSync(Im.encodeJpg(imageFile2!, quality: 85));
    imageFile = compressedImageFile;
  }

  Future<String> uploadImage(file) async {
    UploadTask uploadTask =
        storageReference.child("post_$_postID.jpg").putFile(file);
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => print("Upload Successfully"));
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future createPostInFirestore({
    required String mediaURl,
    required String location,
    required String caption,
  }) async {
    var user = await UserDataBase().getUser(authController.user!.uid);
    final postRef = FirebaseFirestore.instance.collection("posts");
    postRef.doc(user!.id).collection("user_posts").doc(_postID).set({
      "post_id": _postID,
      "owner_id": user.id,
      "userName": user.name,
      "mediaUrl": user.imageUrl,
      "location": location,
      "caption": caption,
      "timeStamp": timeStamp,
      "likes": {},
    });
  }

  Future createCommentInFirestore({
    required String postId,
    required String ownerId,
    required String mediaUrl,
  }) async {
    var user = await UserDataBase().getUser(authController.user!.uid);
    final commentRef = FirebaseFirestore.instance.collection("comments");
    commentRef.doc(postId).collection("users_comment").add({
      "userId": ownerId,
      "userName": user!.name,
      "avatarUrl": user.imageUrl,
      "comment": commentController.text,
      "timeStamp": timeStamp,
    });
    bool isNotPostOwner = user.id != ownerId;
    if (isNotPostOwner) {
      final notificationRef = FirebaseFirestore.instance.collection("feed");
      notificationRef.doc(ownerId).collection("feed_items").add({
        "type": "comment",
        "commentData": commentController.text,
        "userName": user.name,
        "userProfileImg": user.imageUrl,
        "postId": postId,
        "userId": user.id,
        "mediaUrl": mediaUrl,
        "timeStamp": timeStamp,
      });
    }
    commentController.clear();
  }

  Future addLikeToNotification({
    required String postId,
    required String ownerId,
    required String mediaUrl,
  }) async {
    var user = await UserDataBase().getUser(authController.user!.uid);
    bool isNotPostOwner = user!.id != ownerId;
    if (isNotPostOwner) {
      final notificationRef = FirebaseFirestore.instance.collection("feed");
      notificationRef.doc(ownerId).collection("feed_items").doc(postId).set({
        "type": "like",
        "userName": user.name,
        "userProfileImg": user.imageUrl,
        "postId": postId,
        "mediaUrl": mediaUrl,
        "timeStamp": timeStamp,
      });
    }
  }

  Future removeLikeToNotification({
    required String postId,
    required String ownerId,
  }) async {
    var user = await UserDataBase().getUser(authController.user!.uid);
    bool isNotPostOwner = user!.id != ownerId;
    if (isNotPostOwner) {
      final notificationRef = FirebaseFirestore.instance.collection("feed");
      notificationRef
          .doc(ownerId)
          .collection("feed_items")
          .doc(postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  Future submitPost() async {
    isUploading.value = true;
    await compressImage();
    String mediaURL = await uploadImage(imageFile);
    createPostInFirestore(
      mediaURl: mediaURL,
      location: locationController.text,
      caption: captionController.text,
    );
    captionController.clear();
    locationController.clear();
    isLoadingUploadForm.value = false;
    isUploading.value = false;
    _postID = Uuid().v4();
  }

  Future getGeoLocation() async {
    Position position = await determinePosition();
    List<Placemark> coordinates =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = coordinates[0];
    String formateAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formateAddress;
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("User Denied");
      }
    }
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void setPostOrientation(String orientation) {
    postOrientation.value = orientation;
  }
}
