import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String? userName, userProfUrl, comment, cmntId, pstId, userUid;
  final Timestamp? timeCreatedAt;
  final num? totReplies;
  final List<String>? likes;

  const CommentEntity({
    this.userName,
    this.userProfUrl,
    this.comment,
    this.timeCreatedAt,
    this.cmntId,
    this.pstId,
    this.totReplies,
    this.likes,
    this.userUid,
  });

  @override
  List<Object?> get props => [
        userName,
        userProfUrl,
        comment,
        timeCreatedAt,
        cmntId,
        pstId,
        totReplies,
        likes,
        userUid,
      ];
}
