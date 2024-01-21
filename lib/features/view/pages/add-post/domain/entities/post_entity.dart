import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String? postId;
  final String? userName; // username
  final String? userUid;
  final String? ownerProfUrl;
  final String? desc;
  final String? postUrl;
  final Timestamp? timeCreatedAt;
  final List<String>? likes;
  final List<String>? disLikes;
  final num? totalLike;
  final num? totalDisLike;
  final num? totalComments;
  // final num? totalPosts;

  const PostEntity({
    this.postId,
    this.userName,
    this.userUid,
    this.ownerProfUrl,
    this.desc,
    this.postUrl,
    this.timeCreatedAt,
    this.likes,
    this.disLikes,
    this.totalLike,
    this.totalDisLike,
    this.totalComments,
    // this.totalPosts,
  });

  @override
  List<Object?> get props => [
        postId,
        userName,
        userUid,
        ownerProfUrl,
        desc,
        postUrl,
        timeCreatedAt,
        likes,
        disLikes,
        totalLike,
        totalDisLike,
        totalComments,
        // totalPosts,
      ];
}
