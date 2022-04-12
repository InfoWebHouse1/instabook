import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/controllers/controller_setting_page.dart';
import 'package:instabook/utills/utilities.dart';

class ProfileSettingPage extends StatelessWidget {
  final generalController = Get.put(GeneralController());
  final settingController = Get.put(SettingPageController());

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
      body: ListView.builder(
          itemCount: settingController.menu.length,
          itemBuilder: (context, index) {
            var item = settingController.menu[index];
            var icon = settingController.icon[index];
            return GestureDetector(
              onTap: () => settingController.navigate_next(index,context),
              child: ListTile(
                leading: Icon(
                  icon,
                  color: generalController.isThemeDark.value
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text(
                  "${item}",
                  style: TextStyle(
                    color: generalController.isThemeDark.value
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
