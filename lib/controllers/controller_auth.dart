import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instabook/controllers/controller_user.dart';
import 'package:instabook/model/model_user.dart';
import 'package:instabook/services/services_database.dart';
import 'package:instabook/view/home.dart';
import 'package:instabook/view/screen_login.dart';

class AuthController extends GetxController {
  final userController = Get.put(UserController());
  FirebaseAuth auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();

  User? get user => firebaseUser.value;

  var updaters = Queue();
  var update_counter = "".obs;

  @override
  void onInit() {
    firebaseUser.bindStream(auth.authStateChanges());
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

  void createUser(
    String? id,
    String? userName,
    String? email,
    String? imageURL,
    String? gender,
    String? password,
    String? bio,
    String? phoneNo,
      String? timeStamp,
  ) async {
    try {
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
        email: email!.trim(),
        password: password!,
      );
      UserModel userModel = UserModel(
        id: authResult.user!.uid,
        email: authResult.user!.email,
        name: userName!,
        imageUrl: imageURL!,
        gender: gender!,
        bio: bio!,
        phoneNo: phoneNo!,
        //timeStamp: timeStamp,
      );
      if (authResult.additionalUserInfo!.isNewUser) {
        await UserDataBase().createNewUser(userModel);
        Get.find<UserController>().user = userModel;
      }
      await Get.offAll(() => MainHomeScreen());
      /*if ((await UserDataBase().createNewUser(userModel))!) {
        Get.find<UserController>().user = userModel;
        Get.to(() => HomeScreen());
      }*/
    } catch (e) {
      print(e);
    }
  }

  Future<String> signInWithGoogle() async {
    String retVal = "Error";
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    UserModel user = UserModel();
    try {
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      UserCredential authResult = await auth.signInWithCredential(credential);
      if (authResult.additionalUserInfo!.isNewUser) {
        user.id = authResult.user!.uid;
        user.name = authResult.user!.displayName;
        user.email = authResult.user!.email;
        user.imageUrl = authResult.user!.photoURL;
        user.phoneNo = authResult.user!.phoneNumber;
        //user.timeStamp = DateTime.now().toString();
        user.bio = "";
        user.gender = "";
        UserDataBase().createNewUser(user);
      }
      await Get.to(() => MainHomeScreen());
      retVal = "Success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  void signInWithEmailAndPassword(String? email, String? password) async {
    try {
      UserCredential authResult = await auth.signInWithEmailAndPassword(
        email: email!.trim(),
        password: password!,
      );
      userController.user == await UserDataBase().getUser(authResult.user!.uid);
      Get.to(() => MainHomeScreen());
    } catch (e) {
      print(e);
    }
  }

  void signOut() async {
    try {
      await auth.signOut();
      Get.offAll(() => LoginScreen());
      Get.find<UserController>().clear();
    } catch (e) {
      print(e);
    }
  }
}
