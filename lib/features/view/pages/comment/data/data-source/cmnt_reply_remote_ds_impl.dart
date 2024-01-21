import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socio_chat/features/view/pages/comment/data/data-source/cmnt_reply_remote_ds_interface.dart';
import 'package:socio_chat/features/view/pages/comment/data/models/cmnt_model.dart';
import 'package:socio_chat/features/view/pages/comment/data/models/reply_model.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/cmnt_entity.dart';
import 'package:socio_chat/features/view/pages/comment/domain/entities/reply_entity.dart';

class CommentReplyRemoteDataSourceImpl
    implements CommentReplyRemoteDataSourceInterface {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage storage;
  CommentReplyRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
    required this.storage,
  });

  Future<String> fetchLoggedInUserUid() async => firebaseAuth.currentUser!.uid;
  // Method to post a comment on a specific post
  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentSnapshot =
        firestore.collection("posts").doc(comment.pstId).collection("comments");

    final newComment = CommentModel(
      userName: comment.userName,
      userProfUrl: comment.userProfUrl,
      cmntId: comment.cmntId,
      pstId: comment.pstId,
      comment: comment.comment,
      likes: const [],
      userUid: comment.userUid,
      timeCreatedAt: comment.timeCreatedAt,
      totReplies: comment.totReplies,
    ).toDocument();

    try {
      // Get the reference of comment document
      final commentDocRef = await commentSnapshot.doc(comment.cmntId).get();
      // If the do doesn't exists set a new comment
      if (!commentDocRef.exists) {
        commentSnapshot.doc(comment.cmntId).set(newComment).then((value) {
          final postSnapshot = firestore.collection("posts").doc(comment.pstId);
          // Increase comment count by 1
          postSnapshot.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('totalComments');
              postSnapshot.update({"totalComments": totalComments + 1});
              return;
            }
          });
        });
      }
    } catch (e) {
      log("Oops! some error occured :=> $e");
    }
  }

/* else {
        postSnapshot.doc(postEntity.postId).update(newPost);
      } */
  @override
  Future<void> delComment(CommentEntity comment) async {
    final commentSnapshot =
        firestore.collection("posts").doc(comment.pstId).collection("comments");

    try {
      commentSnapshot.doc(comment.cmntId).delete().then((value) {
        final postSnapshot = firestore.collection("posts").doc(comment.pstId);
        // Decrease comment count by 1
        postSnapshot.get().then((value) {
          if (value.exists) {
            final totalComments = value.get('totalComments');
            postSnapshot.update({"totalComments": totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      log("Oops! some error occured :=> $e");
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentSnapshot =
        firestore.collection("posts").doc(comment.pstId).collection("comments");
    final currentUid = await fetchLoggedInUserUid();

    final commentReference = await commentSnapshot.doc(comment.cmntId).get();

    if (commentReference.exists) {
      List likes = commentReference.get("likes");
      if (likes.contains(currentUid)) {
        commentSnapshot.doc(comment.cmntId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        commentSnapshot.doc(comment.cmntId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

// Display all the comments of a post
  @override
  Stream<List<CommentEntity>> fetchAndReadComments(String postId) {
    final commentSnapshot = firestore
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .orderBy("timeCreatedAt", descending: true);
    return commentSnapshot.snapshots().map((querySnap) =>
        querySnap.docs.map((snap) => CommentModel.fromSnapshot(snap)).toList());
  }

// Make a reply to a comment
  @override
  Future<void> createReply(ReplyEntity reply) async {
    final replySnapshot = firestore
        .collection("posts")
        .doc(reply.postId)
        .collection("comments")
        .doc(reply.commentId)
        .collection("reply");

    final commentReply = ReplyModel(
            ownerProfileUrl: reply.ownerProfileUrl,
            userName: reply.userName,
            replyId: reply.replyId,
            commentId: reply.commentId,
            postId: reply.postId,
            likes: const [],
            comment: reply.comment,
            userUid: reply.userUid,
            timeCreateAt: reply.timeCreateAt)
        .toDocument();

    try {
      final replyDocRef = await replySnapshot.doc(reply.replyId).get();

      if (!replyDocRef.exists) {
        replySnapshot.doc(reply.replyId).set(commentReply).then((value) {
          final commentSnapshot = firestore
              .collection("posts")
              .doc(reply.postId)
              .collection("comments")
              .doc(reply.commentId);

          commentSnapshot.get().then((value) {
            if (value.exists) {
              final totalreplies = value.get('totalreplies');
              commentSnapshot.update({"totalreplies": totalreplies + 1});
              return;
            }
          });
        });
        // Increase the overall commnets (include replies)
        final postSnapshot = firestore.collection("posts").doc(reply.postId);

        postSnapshot.get().then((value) {
          if (value.exists) {
            final totalComments = value.get('totalComments');
            postSnapshot.update({"totalComments": totalComments + 1});
            return;
          }
        });
      } else {
        replySnapshot.doc(reply.replyId).update(commentReply);
      }
    } catch (e) {
      log("Oops! some error occured :=> $e");
    }
  }

  @override
  Future<void> deleteReply(ReplyEntity reply) async {
    final replySnapshot = firestore
        .collection("posts")
        .doc(reply.postId)
        .collection("comments")
        .doc(reply.commentId)
        .collection("reply");

    try {
      replySnapshot.doc(reply.replyId).delete().then((value) {
        final commentSnapshot = firestore
            .collection("posts")
            .doc(reply.postId)
            .collection("comments")
            .doc(reply.commentId);

        commentSnapshot.get().then((value) {
          if (value.exists) {
            final totalreplies = value.get('totalreplies');
            commentSnapshot.update({"totalreplies": totalreplies - 1});

            return;
          }
        });
      });
      // To decrease the count of total comments when reply deleted
      final postSnapshot = firestore.collection("posts").doc(reply.postId);

      postSnapshot.get().then((value) {
        if (value.exists) {
          final totalComments = value.get('totalComments');
          postSnapshot.update({"totalComments": totalComments - 1});
          return;
        }
      });
    } catch (e) {
      log("Oops! some error occured :=> $e");
    }
  }

  @override
  Future<void> likeReply(ReplyEntity reply) async {
    final replySnapshot = firestore
        .collection("posts")
        .doc(reply.postId)
        .collection("comments")
        .doc(reply.commentId)
        .collection("reply");

    final currentUid = await fetchLoggedInUserUid();

    final replyDocSnapshot = await replySnapshot.doc(reply.replyId).get();

    if (replyDocSnapshot.exists) {
      List likes = replyDocSnapshot.get("likes");
      if (likes.contains(currentUid)) {
        replySnapshot.doc(reply.replyId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        replySnapshot.doc(reply.replyId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  // Display all the replies to a specific comment
  @override
  Stream<List<ReplyEntity>> fetchAndReadReplies(ReplyEntity reply) {
    final replySnapshot = firestore
        .collection("posts")
        .doc(reply.postId)
        .collection("comments")
        .doc(reply.commentId)
        .collection("reply");
    return replySnapshot.snapshots().map((querySnap) =>
        querySnap.docs.map((snap) => ReplyModel.fromSnapshot(snap)).toList());
  }
}
