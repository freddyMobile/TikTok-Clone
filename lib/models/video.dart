import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumbNail;
  String profilePhoto;

  Video({
    required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.caption,
    required this.commentCount,
    required this.profilePhoto,
    required this.shareCount,
    required this.songName,
    required this.thumbNail,
    required this.videoUrl,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'id': id,
        'likes': likes,
        'caption': caption,
        'commentCount': commentCount,
        'profilePhoto': profilePhoto,
        'shareCount': shareCount,
        'songName': songName,
        'thumbNail': thumbNail,
        'videoUrl': videoUrl,
      };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
        username: snapshot['username'],
        uid: snapshot['uid'],
        id: snapshot['id'],
        likes: snapshot['likes'],
        caption: snapshot['caption'],
        commentCount: snapshot['commentCount'],
        profilePhoto: snapshot['profilePhoto'],
        shareCount: snapshot['shareCount'],
        songName: snapshot['songName'],
        thumbNail: snapshot['thumbNail'],
        videoUrl: snapshot['videoUrl']);
  }
}
