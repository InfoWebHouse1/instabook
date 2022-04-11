
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instabook/binding/binding_auth.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/utills/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instabook/utills/utilities.dart';

Future<void> main() async{
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: kPrimaryLight.withOpacity(0.5), // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final generalController = Get.put(GeneralController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("${generalController.update_counter}");
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(),
      theme:generalController.isThemeDark.value ? ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: kPrimaryDark).copyWith(secondary: kSecondaryDark),
        backgroundColor: kBackgroundDark,
        iconTheme: IconThemeData(
            color: kWhiteColor
        ),
      ) : ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: kPrimaryLight).copyWith(secondary: kSecondaryLight),
        backgroundColor: kWhiteColor,
        iconTheme: IconThemeData(
          color: kBlackColor,
        )
      ),
      home: RootScreen(),
    ),);
  }
}
