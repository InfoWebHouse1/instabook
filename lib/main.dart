import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instabook/binding/binding_auth.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/controllers/controller_profile.dart';
import 'package:instabook/utills/root.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final profileThemeChange = Get.put(ProfileController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(),
      theme:profileThemeChange.isThemeDark.value ? ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.teal.shade900).copyWith(secondary: Colors.purple.shade900),
      ) : ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.teal).copyWith(secondary: Colors.purple),
      ),
      home: RootScreen(),
    ),);
  }
}
