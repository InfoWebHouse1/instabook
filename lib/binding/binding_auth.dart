import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}