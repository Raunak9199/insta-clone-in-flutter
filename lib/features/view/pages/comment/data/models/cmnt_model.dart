import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/cmnt_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    String? userName,
    String? userProfUrl,
    String? comment,
    String? cmntId,
    String? pstId,
    String? userUid,
    num? totReplies,
    List<String>? likes,
    Timestamp? timeCreatedAt,
  }) : super(
          userName: userName,
          userProfUrl: userProfUrl,
          comment: comment,
          timeCreatedAt: timeCreatedAt,
          cmntId: cmntId,
          likes: likes,
          userUid: userUid,
          pstId: pstId,
          totReplies: totReplies,
        );

  factory CommentModel.fromSnapshot(DocumentSnapshot snapshot) {
    return CommentModel(
      comment: snapshot.get('comment'),
      userName: snapshot.get('userName'),
      userProfUrl: snapshot.get('userProfUrl'),
      timeCreatedAt: snapshot.get('timeCreatedAt'),
      cmntId: snapshot.get('cmntId'),
      likes: List.from(snapshot.get('likes')),
      userUid: snapshot.get('userUid'),
      pstId: snapshot.get('pstId'),
      totReplies: snapshot.get('totReplies'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "pstId": pstId,
      "userUid": userUid,
      "comment": comment,
      "userProfUrl": userProfUrl,
      "cmntId": cmntId,
      "timeCreatedAt": timeCreatedAt,
      "totReplies": totReplies,
      "userName": userName,
      "likes": likes,
    };
  }
}
