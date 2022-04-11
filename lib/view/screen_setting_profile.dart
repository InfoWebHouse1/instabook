import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/utills/utilities.dart';

class ProfileSettingPage extends StatelessWidget {
  final generalController = Get.put(GeneralController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
          "Setting",
          generalController.isThemeDark.value ? Colors.white : Colors.black,
          FontWeight.bold,
          30.5,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Setting"),
      ),
    );
  }
}
