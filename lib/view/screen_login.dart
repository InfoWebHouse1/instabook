// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/controllers/controller_login.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/utills/widget/custom_button1.dart';
import 'package:instabook/utills/widget/custom_google_button.dart';
import 'package:instabook/utills/widget/custom_horizontal_line.dart';
import 'package:instabook/utills/widget/custom_textFormField.dart';
import 'package:instabook/view/screen_registration.dart';

class LoginScreen extends StatelessWidget {
  final authController = Get.put(AuthController());
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: buildBody(context),
    );
  }

  buildBody(BuildContext context) {
    print("${authController.update_counter} ${loginController.update_counter}");
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: loginController.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //todo:  email form
                CustomTextForm(
                  labelText: "Email",
                  controller: loginController.emailController,
                  icon: Icon(Icons.mail_rounded),
                  validator: MultiValidator(
                    [
                      RequiredValidator(errorText: "Required *"),
                      EmailValidator(errorText: "Not a Valid Email")
                    ],
                  ),
                  isPassword: false,
                ),
                SizedBox(
                  height: 20.0,
                ),
                //todo: password form
                CustomTextForm(
                  labelText: "Password",
                  controller: loginController.passwordController,
                  icon: Icon(Icons.lock_rounded),
                  validator: loginController.validatePass,
                  isPassword: true,
                ),
                SizedBox(
                  height: 20.0,
                ),
                //todo: login button
                Button1(
                  labelText: "Login",
                  onPressed: () {
                    loginController.validateLogin();
                    print("Login");
                  },
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  "Login With",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                GoogleButton(
                  onPressed: () {
                    authController.signInWithGoogle();
                    print("Google");
                  },
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  "Or",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                HorizontalLine(),
                CustomRichText(
                  "Don't have an account?",
                  " Sign up",
                  () => Get.offAll(() => RegistrationScreen()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
