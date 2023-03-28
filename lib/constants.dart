import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tiktok/controller/auth_controller.dart';
import 'package:flutter_tiktok/views/screens/add_video_screen.dart';
import 'package:flutter_tiktok/views/screens/profile_screen.dart';
import 'package:flutter_tiktok/views/screens/search_screen.dart';
import 'package:flutter_tiktok/views/screens/video_screen.dart';
import 'package:video_player/video_player.dart';

//PAGES
List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  const Center(child: Text('Messages Screen')),
  ProfileScreen(uid: authController.user.uid),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

//FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

//CONTROLLER
var authController = AuthController.isntance;
