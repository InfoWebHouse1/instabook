// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/controllers/controller_post.dart';
import 'package:instabook/controllers/controller_user.dart';
import 'package:instabook/services/services_database.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/utills/widget/profile_widget/custom_profile_image.dart';

import '../../utills/widget/profile_widget/custom_profile_edit_button.dart';

class PostScreen extends StatelessWidget {
  final generalController = Get.put(GeneralController());
  final authController = Get.put(AuthController());
  final postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.5),
      body: buildBody(context),
    );
  }

  buildBody(context) {
    return Obx(
      () => SafeArea(
        child: buildBody2(context),
      ),
    );
  }

  buildBody2(context) {
    print(
        "${postController.update_counter} ${generalController.update_counter} ");
    return postController.isLoadingUploadForm.value
        ? buildUploadForm(context)
        : buildBoContent(context);
  }

  buildUploadForm(context) {
    var colorChange =
        generalController.isThemeDark.value ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.5),
      appBar: AppBar(
        title: CustomText(
          "Create a post",
          colorChange,
          FontWeight.bold,
          30.5,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorChange,
          ),
          onPressed: () => postController.isLoadingUploadForm.value = false,
        ),
        actions: [
          TextButton(
            onPressed: postController.isUploading.value ? () => print("Posting...") : () => postController.submitPost(),
            child: Text(
              "Post",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 20.6,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          postController.isUploading.value ? SizedBox(
            height: 10,
            child: LinearProgressIndicator(
              minHeight: 10.0,
            ),
          ) : SizedBox(),
          SizedBox(
            height: Get.height * 0.35,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(postController.imageFile!),
                )),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: ListTile(
              leading: GetX<UserController>(initState: (_) async {
                Get.find<UserController>().user =
                    await UserDataBase().getUser(authController.user!.uid);
              }, builder: (_) {
                if (_.user!.imageUrl != "") {
                  return CustomProfileImage(
                    imageVal: "${_.user!.imageUrl}",
                    radius: 30,
                  );
                } else {
                  return CustomAssetsProfileImage(
                    imageVal: "assets/images/default_image.png",
                  );
                }
              }),
              title: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.black.withOpacity(0.5))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: TextFormField(
                    controller: postController.captionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: generalController.isThemeDark.value ? Colors.white.withOpacity(0.5) : Colors.grey.withOpacity(0.4),
                      hintText: "Write something here...",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Theme.of(context).colorScheme.primary,
              size: 35.0,
            ),
            trailing: IconButton(
              icon: Icon(Icons.my_location_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 35.0,),
              onPressed: postController.getGeoLocation,
            ),
            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: TextFormField(
                  controller: postController.locationController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: generalController.isThemeDark.value ? Colors.white.withOpacity(0.5) : Colors.grey.withOpacity(0.4),
                    hintText: "Where was this post from...",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildBoContent(context) {
    final orientation = MediaQuery.of(context).orientation;
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Image.asset(
            "assets/images/postImage.png",
            height: orientation == Orientation.portrait ? 300 : 200,
          ),
          SizedBox(
            width: Get.width,
            child: Center(
              child: CustomButton(
                controller: generalController,
                name: "Upload Post",
                onPressed: () => postController.selectImage(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
