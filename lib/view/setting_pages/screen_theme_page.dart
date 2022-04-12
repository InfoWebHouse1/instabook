// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/view/home.dart';

class ThemePage extends StatelessWidget {
  final generalController = Get.put(GeneralController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
          "Theme",
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
      body: Obx(() => buildBody()),
    );
  }

  buildBody() {
    print("${generalController.update_counter}");
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            width: Get.width,
            height: 50,
            child: RadioListTile(
              value: false,
              groupValue: generalController.isThemeDark.value,
              onChanged: (state) {
                generalController.isThemeDark.value == state;
                print(state);
                generalController.changeTheme(state);
                Get.to(()=>MainHomeScreen());
              },
              title: Text("Light", style: TextStyle(
                color: generalController.isThemeDark.value
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
              ),),
              activeColor: kPrimaryDark,
            ),
          ),
          SizedBox(
            width: Get.width,
            height: 50,
            child: RadioListTile(
              value: true,
              groupValue: generalController.isThemeDark.value,
              onChanged: (state) {
                generalController.isThemeDark.value == state;
                print(state);
                generalController.changeTheme(state);
                Get.to(()=>MainHomeScreen());
              },
              title: Text("Dark",style: TextStyle(
                color: generalController.isThemeDark.value
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
              )),
              activeColor: kPrimaryLight,
            ),
          ),
          // _myRadioButton(
          //   title: "Light",
          //   value: 0,
          //   onChanged: (state) {
          //     print("State $state");
          //     generalController.groupVal == state;
          //     generalController.isThemeDark.value == state;
          //     generalController.changeTheme(state);
          //   },
          // ),
          // _myRadioButton(
          //   title: "Dark",
          //   value: 1,
          //   onChanged: (state) {
          //     print("State $state");
          //     generalController.groupVal == state;
          //     generalController.isThemeDark.value == state;
          //     generalController.changeTheme(state);
          //   },
          // ),
        ],
      ),
    );
  }

  // Widget _myRadioButton(
  //     {required String title, required value, required onChanged}) {
  //   return RadioListTile(
  //     value: value,
  //     groupValue: generalController.groupVal,
  //     onChanged: onChanged,
  //     title: Text(title),
  //   );
  // }
}
