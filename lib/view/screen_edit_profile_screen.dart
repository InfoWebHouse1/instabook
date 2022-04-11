// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/controllers/controller_profile.dart';
import 'package:instabook/controllers/controller_user.dart';
import 'package:instabook/services/services_database.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/utills/widget/custom_button1.dart';
import 'package:instabook/utills/widget/profile_widget/custom_edit_profile_gender_button.dart';
import 'package:instabook/utills/widget/profile_widget/custom_profile_image.dart';

class EditProfileScreen extends StatelessWidget {
  final authController = Get.put(AuthController());
  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
          "Edit Profile",
          Colors.white,
          FontWeight.bold,
          30.5,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: buildBody(context),
    );
  }

  buildBody(BuildContext context) {
    print("${profileController.update_counter}");
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //todo: profile picture
              GetBuilder<ProfileController>(
                init: profileController,
                builder: (_) => SizedBox(
                  child: profileController.newProfilePic != null
                      ? CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          radius: 43,
                          child: ClipOval(
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Image.file(profileController.newProfilePic!),
                            ),
                          ),
                        )
                      : CustomAssetsProfileImage(
                          imageVal: "assets/images/default_image.png",
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: profileController.getImage1,
                  child: Text(
                    "Change Profile Picture",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              //todo: username field change
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Username",
                        style: TextStyle(
                          fontSize: 14.6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: profileController.updateNameController,
                        cursorColor: Colors.transparent,
                        decoration: InputDecoration(
                          hintText: "Username",
                          hintStyle: TextStyle(
                            fontSize: 14.6,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //todo: email field change
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 14.6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GetX<UserController>(initState: (_) async {
                        Get.find<UserController>().user = await UserDataBase().getUser(authController.user!.uid);
                      }, builder: (_) {
                        if (_.user!.email != null) {
                          return Text(
                            "${_.user!.email}",
                            style: TextStyle(
                              fontSize: 14.6,
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
                    ),
                  ],
                ),
              ),
              //todo: Bio field change
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Bio",
                        style: TextStyle(
                          fontSize: 14.6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: profileController.updateBioController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        maxLength: 50,
                        cursorColor: Colors.transparent,
                        decoration: InputDecoration(
                          hintText: "Bio",
                          hintStyle: TextStyle(
                            fontSize: 14.6,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //todo: Phone No field change
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Phone No",
                        style: TextStyle(
                          fontSize: 14.6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: profileController.updatePhnController,
                        cursorColor: Colors.transparent,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Phone No",
                          hintStyle: TextStyle(
                            fontSize: 14.6,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //todo: Gender field change
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 5,
                ),
                child: EditGenderButton(),
              ),
              //todo: Save Button
              Button1(
                  labelText: "Save",
                  onPressed: () {
                    profileController.saveData();
                    print("Save");
                  },
                ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
