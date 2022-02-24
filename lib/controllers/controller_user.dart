import 'package:get/get.dart';
import 'package:instabook/model/model_user.dart';

class UserController extends GetxController{
  Rx<UserModel?> userModel = UserModel().obs;

  UserModel? get user => userModel.value;

  set user(UserModel? value) => userModel.value = value!;

  void clear(){
    userModel.value = UserModel();
  }
}