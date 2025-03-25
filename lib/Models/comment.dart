import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String? commentRef;
  final String commentText;
  final Timestamp timeStamp;
  final DocumentReference<Object?>? commentOwnerRef;
  final String commentOwnerName;
  final DocumentReference<Object?>? taskRef;
  final String commentOwnerImg;
  final Timestamp commentDate;
  final List<String> likedBy;
  final List<DocumentReference> likedByRef;
  final int totalLikes;
  final String taskStatusCategory;

  Comment({
    this.commentRef,
    required this.commentText,
    required this.timeStamp,
    this.commentOwnerRef,
    required this.commentOwnerName,
    this.taskRef,
    required this.commentOwnerImg,
    required this.commentDate,
    required this.likedBy,
    required this.likedByRef,
    required this.totalLikes,
    required this.taskStatusCategory,
  });

  factory Comment.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return Comment(
      commentRef: doc.id,
      commentText: json['comment_text'] ?? '',
      timeStamp: json['timeStamp'] ?? Timestamp.now(),
      commentOwnerRef: json['comment_owner_ref'] as DocumentReference<Object?>?,
      commentOwnerName: json['comment_owner_name'] ?? '',
      taskRef: json['taskRef']  as DocumentReference<Object?>?,
      commentOwnerImg: json['comment_owner_img'] ?? '',
      commentDate: json['commentDate'] ?? Timestamp.now(),
      likedBy: List<String>.from(json['likedBy'] ?? []),
      likedByRef:
          (json['likedByRef'] as List<dynamic>?)
              ?.map((e) => e as DocumentReference)
              .toList() ??
          [],
      totalLikes: json['totalLikes'] ?? 0,
      taskStatusCategory: json['taskStatusCategory'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentRef': commentRef,
      'comment_text': commentText,
      'timeStamp': timeStamp,
      'comment_owner_ref': commentOwnerRef,
      'comment_owner_name': commentOwnerName,
      'taskRef': taskRef,
      'comment_owner_img': commentOwnerImg,
      'commentDate': commentDate,
      'likedBy': likedBy,
      'likedByRef': likedByRef,
      'totalLikes': totalLikes,
      'taskStatusCategory': taskStatusCategory,
    };
  }
}
