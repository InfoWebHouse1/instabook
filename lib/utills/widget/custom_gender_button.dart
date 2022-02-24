// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_registration.dart';

class GenderButton extends StatelessWidget {
  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    print("${registerController.update_counter}");
    return Obx(() => SizedBox(
          width: Get.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: customRadioButton(
                    registerController.genderVal[1],
                    1,
                    context,
                  )),

              Expanded(
                flex: 1,
                child: customRadioButton(
                  registerController.genderVal[2],
                  2,
                  context,
                ),
              ),
            ],
          ),
        ));
  }

  Widget customRadioButton(String gender, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: () {
          registerController.changeGenderIndex(index);
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          side: BorderSide(
            color: registerController.selectedGenderIndex.value == index ? Theme.of(context).colorScheme.primary : Colors.grey,
            width: 2.0,
          ),
        ),
        child: Text(
          gender,
          style: TextStyle(
            color: registerController.selectedGenderIndex.value == index ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
        ),
      ),
    );
  }
}
