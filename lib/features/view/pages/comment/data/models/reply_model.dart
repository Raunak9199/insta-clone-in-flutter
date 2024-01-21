import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/reply_entity.dart';

class ReplyModel extends ReplyEntity {
  const ReplyModel({
    String? userUid,
    String? replyId,
    String? commentId,
    String? postId,
    String? comment,
    String? userName,
    String? ownerProfileUrl,
    List<String>? likes,
    Timestamp? timeCreateAt,
    num? totalreplies,
  }) : super(
          comment: comment,
          commentId: commentId,
          postId: postId,
          userUid: userUid,
          ownerProfileUrl: ownerProfileUrl,
          userName: userName,
          likes: likes,
          timeCreateAt: timeCreateAt,
          replyId: replyId,
          totalreplies: totalreplies,
        );

  factory ReplyModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReplyModel(
      postId: snapshot['postId'],
      userUid: snapshot['userUid'],
      comment: snapshot['comment'],
      ownerProfileUrl: snapshot['ownerProfileUrl'],
      commentId: snapshot['commentId'],
      replyId: snapshot['replyId'],
      timeCreateAt: snapshot['timeCreateAt'],
      userName: snapshot['userName'],
      totalreplies: snapshot['totalreplies'],
      likes: List.from(snap.get("likes")),
    );
  }

  Map<String, dynamic> toDocument() => {
        "userUid": userUid,
        "comment": comment,
        "ownerProfileUrl": ownerProfileUrl,
        "commentId": commentId,
        "timeCreateAt": timeCreateAt,
        "replyId": replyId,
        "postId": postId,
        "likes": likes,
        "userName": userName,
        "totalreplies": totalreplies,
      };
}
