import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/constants.dart';
import 'package:flutter_tiktok/views/screens/auth/login_screen.dart';
import 'package:flutter_tiktok/views/screens/home_screen.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart' as model;

class AuthController extends GetxController {
  static AuthController isntance =
      Get.find(); //it finds the instance of required class
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have succesfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  //upload to firebasestorage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);

    TaskSnapshot snap =
        await uploadTask; //imagine as it take the screenshoot of uploadTask
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  //registering the user
  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
//save our user to a authentication and firebase firestore
        UserCredential cred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          email: email,
          name: username,
          profilePhoto: downloadUrl,
          uid: cred.user!.uid,
        ); // we write it in this form by helping user model
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar('Error Creating  Account', 'Please Enter all the fields');
      }
    } catch (e) {
      Get.snackbar(
        'Error Creating  Account',
        e.toString(),
      );
    }
  }

  //LOGIN USER

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print('log success');
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Creating  Account',
        e.toString(),
      );
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }
}
