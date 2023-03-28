import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tiktok/constants.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

import '../models/video.dart';

class UploadVideoController extends GetxController {
  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);

    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);

    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

//Upload video
  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage('Video $len', videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      Video video = Video(
          username: (userDoc.data()! as Map<String, dynamic>)['name']
              as String, //olsa belke burada problem ola biler
          uid: uid,
          id: 'video $len',
          likes: [],
          caption: caption,
          commentCount: 0,
          profilePhoto:
              (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
          shareCount: 0,
          songName: songName,
          thumbNail: thumbnail,
          videoUrl: videoUrl);

      await firestore
          .collection('videos')
          .doc('video $len')
          .set(video.toJson());

      Get.back();
    } catch (error) {
      Get.snackbar('Error Uploading Video', error.toString());
    }
  }
}
