import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    String? postId,
    String? userName,
    String? userUid,
    String? ownerProfUrl,
    String? desc,
    String? postUrl,
    Timestamp? timeCreatedAt,
    List<String>? likes,
    List<String>? disLikes,
    num? totalLike,
    num? totalComments,
    // this.totalPosts,
    num? totalDisLike,
  }) : super(
          desc: desc,
          disLikes: disLikes,
          likes: likes,
          userName: userName,
          ownerProfUrl: ownerProfUrl,
          userUid: userUid,
          postId: postId,
          postUrl: postUrl,
          timeCreatedAt: timeCreatedAt,
          totalComments: totalComments,
          totalLike: totalLike,
          // // totalPosts: totalPosts,
          totalDisLike: totalDisLike,
        );

  factory PostModel.fromSnapshot(DocumentSnapshot snapshot) {
    return PostModel(
      userUid: snapshot.get('userUid'),
      userName: snapshot.get('userName'),
      ownerProfUrl: snapshot.get('ownerProfUrl'),
      desc: snapshot.get('desc'),
      likes: List.from(snapshot.get('likes')),
      postId: snapshot.get('postId'),
      postUrl: snapshot.get('postUrl'),
      disLikes: List.from(snapshot.get('disLikes')),
      timeCreatedAt: snapshot.get('timeCreatedAt'),
      totalComments: snapshot.get('totalComments'),
      totalLike: snapshot.get('totalLike'),
      // // totalPosts: snapshot.get('totalPosts'),
      totalDisLike: snapshot.get('totalDisLike'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'userUid': userUid,
      'userName': userName,
      'ownerProfUrl': ownerProfUrl,
      'desc': desc,
      'likes': likes,
      'postId': postId,
      'postUrl': postUrl,
      'disLikes': disLikes,
      'timeCreatedAt': timeCreatedAt,
      'totalComments': totalComments,
      'totalLike': totalLike,
      'totalDisLike': totalDisLike,
      // // 'totalPosts': totalPosts,
    };
  }
}
