import 'dart:collection';

import 'package:get/get.dart';

class RootController extends GetxController{
  var updaters = Queue();
  var update_counter = "".obs;

  var isRoot = false.obs ;


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
}