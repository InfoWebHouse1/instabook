
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_profile.dart';


class EditGenderButton extends StatelessWidget {
  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    print("${profileController.update_counter}");
    return Obx(() => SizedBox(
          width: Get.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: customRadioButton(
                    profileController.genderVal[1],
                    1,
                    context,
                  )),

              Expanded(
                flex: 1,
                child: customRadioButton(
                  profileController.genderVal[2],
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
          profileController.editGenderIndex(index);
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          side: BorderSide(
            color: profileController.selectedGenderIndex.value == index ? Theme.of(context).colorScheme.primary : Colors.grey,
            width: 2.0,
          ),
        ),
        child: Text(
          gender,
          style: TextStyle(
            color: profileController.selectedGenderIndex.value == index ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
        ),
      ),
    );
  }
}
