import 'dart:async';
import 'dart:collection';
import 'package:get/get.dart';
import 'package:instabook/view/screen_login.dart';

class SplashScreenController extends GetxController{
  var updaters = Queue();
  var update_counter = "".obs;


  @override
  void onInit() {
    startTimer();
    update1();
    super.onInit();
  }

  update1({from: ""}) {
    if (from != "") {
      updaters.add(from);
      // For tracking, who is calling this method
      if (updaters.length > 5) {
        updaters.removeFirst();
      }
    }
    update_counter.value = "cont_pr_list-${DateTime.now()} ${DateTime.now().microsecond} $updaters";
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }
  void navigationPage(){
    Get.to(()=>LoginScreen());
  }
}