import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? postID;
  String? ownerID;
  String? userName;
  String? caption;
  String? mediaUrl;
  String? location;
  Map? likes;
  String? timeStamp;

  PostModel({
    required this.postID,
    required this.ownerID,
    required this.userName,
    required this.caption,
    required this.mediaUrl,
    required this.location,
    required this.likes,
    required this.timeStamp,
  });

  factory PostModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    return PostModel(
      postID: documentSnapshot.get("post_id"),
      ownerID: documentSnapshot.get("owner_id"),
      userName: documentSnapshot.get("userName"),
      caption: documentSnapshot.get("caption"),
      mediaUrl: documentSnapshot.get("mediaUrl"),
      location: documentSnapshot.get("location"),
      likes: documentSnapshot.get("likes"),
      timeStamp: documentSnapshot.get("timeStamp"),
    );
  }
}
