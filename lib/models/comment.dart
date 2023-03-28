import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String username;
  String comment;
  final datePublished;
  List likes;
  String profilePhoto;
  String uid;
  String id;

  Comment(
      {required this.username,
      required this.comment,
      required this.datePublished,
      required this.id,
      required this.likes,
      required this.profilePhoto,
      required this.uid});

  Map<String, dynamic> toJson() => {
        'username': username,
        'comment': comment,
        'datePublished': datePublished,
        'id': id,
        'likes': likes,
        'profilePhoto': profilePhoto,
        'uid': uid,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
        username: snap['username'],
        comment: snap['comment'],
        datePublished: snap['datePublished'],
        id: snap['id'],
        likes: snap['likes'],
        profilePhoto: snap['profilePhoto'],
        uid: snap['uid']);
  }
}
