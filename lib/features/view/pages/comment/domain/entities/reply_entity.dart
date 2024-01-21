import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReplyEntity extends Equatable {
  final String? userUid;
  final String? replyId;
  final String? commentId;
  final String? postId;
  final String? comment;
  final String? userName;
  final String? ownerProfileUrl;
  final List<String>? likes;
  final Timestamp? timeCreateAt;
  final num? totalreplies;

  const ReplyEntity({
    this.userUid,
    this.replyId,
    this.commentId,
    this.postId,
    this.comment,
    this.userName,
    this.ownerProfileUrl,
    this.likes,
    this.timeCreateAt,
    this.totalreplies,
  });

  @override
  List<Object?> get props => [
        userUid,
        replyId,
        commentId,
        postId,
        comment,
        userName,
        ownerProfileUrl,
        likes,
        timeCreateAt,
        totalreplies,
      ];
}
