// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/controllers/controller_profile.dart';
import 'package:instabook/controllers/controller_user.dart';
import 'package:instabook/services/services_database.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/utills/widget/profile_widget/custom_profile_data2.dart';
import 'package:instabook/utills/widget/profile_widget/custom_profile_edit_button.dart';
import 'package:instabook/utills/widget/profile_widget/custom_profile_image.dart';
import 'package:instabook/utills/widget/profile_widget/custon_profile_data1.dart';
import 'package:instabook/view/screen_setting_profile.dart';

class ProfileScreen extends StatelessWidget {
  final authController = Get.put(AuthController());
  final profileController = Get.put(ProfileController());
  final userController = Get.put(UserController());
  final generalController = Get.put(GeneralController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
          "Profile",
          generalController.isThemeDark.value ? Colors.white : Colors.black,
          FontWeight.bold,
          30.5,
        ),
        leading: GetBuilder<GeneralController>(
          builder: (_) {
            return Switch(
              activeColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              value: generalController.isThemeDark.value,
              onChanged: (state) {
                print("State $state");
                generalController.changeTheme(state);
              },
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => ProfileSettingPage());
            },
            icon: Icon(Icons.settings),
            color: Theme.of(context).iconTheme.color,
          ),
        ],
      ),
      body: buildBody(context),
    );
  }

  buildBody(BuildContext context) {
    print("${authController.update_counter} ${profileController.update_counter} ");
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
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
                            GetX<UserController>(initState: (_) async {
                              Get.find<UserController>().user = await UserDataBase().getUser(authController.user!.uid);
                            }, builder: (_) {
                              if (_.user!.imageUrl != "") {
                                return CustomProfileImage(
                                  imageVal: "${_.user!.imageUrl}",
                                );
                              } else {
                                return CustomAssetsProfileImage(
                                  imageVal: "assets/images/default_image.png",
                                );
                              }
                            }),
                            //todo: profile post follower following
                            ProfileData1(
                              postCount: "0",
                              followerCount: "0",
                              followingCount: "0",
                              color: generalController.isThemeDark.value ? Colors.white : Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    //todo: Name
                    GetX<UserController>(
                      initState: (_) async {
                        Get.find<UserController>().user = await UserDataBase().getUser(authController.user!.uid);
                      },
                      builder: (_) {
                        if (_.user!.name != null) {
                          return ProfileData2(
                            width: Get.width,
                            text: "${_.user!.name}",
                            fontSize: 18.0,
                            hasLine: false,
                            fontWeight: FontWeight.bold,
                            color: generalController.isThemeDark.value ? Colors.white : Colors.black,
                          );
                        } else {
                          return ProfileData2(
                            width: Get.width,
                            text: "User",
                            fontSize: 18.0,
                            hasLine: false,
                            fontWeight: FontWeight.bold,
                            color: generalController.isThemeDark.value ? Colors.white : Colors.black,
                          );
                        }
                      },
                    ),
                    //todo: Bio
                    GetX<UserController>(initState: (_) async {
                      Get.find<UserController>().user = await UserDataBase().getUser(authController.user!.uid);
                    }, builder: (_) {
                      if (_.user!.bio != null) {
                        return ProfileData2(
                          width: Get.width * 0.5,
                          text: "${_.user!.bio}",
                          fontSize: 15.4,
                          hasLine: true,
                          fontWeight: FontWeight.normal,
                          color: generalController.isThemeDark.value ? Colors.white : Colors.black,
                        );
                      } else {
                        return ProfileData2(
                          width: Get.width * 0.5,
                          text: "Bio",
                          fontSize: 15.4,
                          hasLine: true,
                          fontWeight: FontWeight.normal,
                          color: generalController.isThemeDark.value ? Colors.white : Colors.black,
                        );
                      }
                    }),
                    //todo: Edit Button
                    SizedBox(
                      width: Get.width,
                      child: Center(
                        child: CustomProfileEditButton(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Divider(
                  color: Colors.grey,
                  height: 8.0,
                ),
              ),
              Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    ) /*Obx(
      () => profileController.showProgressIndicator.value
          ? Container(
              width: Get.width,
              height: Get.height,
              color: Colors.white.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                ),
              ),
            )
          : ,
    )*/
        ;
  }
}
