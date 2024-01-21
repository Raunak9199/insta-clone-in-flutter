import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socio_chat/features/view/pages/add-post/data/models/post_model.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/add-post/data/data_source/addpost_remote_ds_interface.dart';
import 'package:socio_chat/global-widgets/global_widgets.dart';

class AddPostRemoteDataSourceImpl implements AddPostRemoteDataSourceInterface {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage storage;
  AddPostRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
    required this.storage,
  });
  Future<String> fetchLoggedInUserUid() async => firebaseAuth.currentUser!.uid;
  @override
  Future<void> createPost(PostEntity postEntity) async {
    // Get the snapshot of the post collection.
    final postSnapshot = firestore.collection("posts");
    // Get the post model to create a post with post details
    final newPost = PostModel(
      ownerProfUrl: postEntity.ownerProfUrl,
      userName: postEntity.userName,
      totalLike: 0,
      totalComments: 0,
      postUrl: postEntity.postUrl,
      postId: postEntity.postId,
      likes: const [],
      disLikes: const [],
      desc: postEntity.desc,
      userUid: postEntity.userUid,
      timeCreatedAt: postEntity.timeCreatedAt,
    ).toDocument();

    try {
      // Get the post id snapshot
      final postDocSnapshot = await postSnapshot.doc(postEntity.postId).get();

      // Check id any post doesn't exist onto that post id snapshot then do a post
      if (!postDocSnapshot.exists) {
        postSnapshot.doc(postEntity.postId).set(newPost).then((value) {
          final userSnapshot =
              firestore.collection("users").doc(postEntity.userUid);
          // Increase the post count by 1 on the userprofile
          userSnapshot.get().then((posts) {
            if (posts.exists) {
              final totalPosts = posts.get('totalPosts');
              userSnapshot.update({"totalPosts": totalPosts + 1});
              return;
            }
          });
        });
      }
    } catch (e) {
      NewAppSnackBar.showSnackbar(msg: "$e");
      log("some error occured $e");
    }
  }

// Delete own post from the app
  @override
  Future<void> delPost(PostEntity postEntity) async {
    // Get the snapshot of posts collection
    final postSnapshot = firestore.collection("posts");
    try {
      postSnapshot.doc(postEntity.postId).delete().then((value) {
        // After delete, Get the snapshot of users collection to update the total posts value on the user's profile
        final userSnapshot =
            firestore.collection("users").doc(postEntity.userUid);

        userSnapshot.get().then((posts) {
          if (posts.exists) {
            final totalPosts = posts.get('totalPosts');
            userSnapshot.update({"totalPosts": totalPosts - 1});
            return;
          }
        });
      });
    } catch (e) {
      NewAppSnackBar.showSnackbar(msg: "$e");
      log("some error occured $e");
    }
  }

  // Like the posts posted by users on the app
  @override
  Future<void> likePost(PostEntity postEntity) async {
    // Get the snapshot of the posts collection
    final postSnapshot = firestore.collection("posts");

    // Get the userid of the currently logged in user
    final currentUid = await fetchLoggedInUserUid();
    // Get the post reference
    final postReference = await postSnapshot.doc(postEntity.postId).get();

    // Chech if postref exists
    if (postReference.exists) {
      // Get the list of likes on the post
      List likes = postReference.get("likes");
      final totalLike = postReference.get("totalLike");
      // If like already exists remove the like and update (decrease) the totallikes
      if (likes.contains(currentUid)) {
        postSnapshot.doc(postEntity.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLike": totalLike - 1
        });
      } else {
        postSnapshot.doc(postEntity.postId).update({
          // Increase the totallikes
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLike": totalLike + 1
        });
      }
    }
  }

  // Dislike the Post
  @override
  Future<void> disLikePost(PostEntity postEntity) async {
    final postSnapshot = firestore.collection("posts");

    final currentUid = await fetchLoggedInUserUid();
    final postReference = await postSnapshot.doc(postEntity.postId).get();

    if (postReference.exists) {
      List disLikes = postReference.get("disLikes");
      final totalDisLike = postReference.get("totalDisLike");
      if (disLikes.contains(currentUid)) {
        postSnapshot.doc(postEntity.postId).update({
          "disLikes": FieldValue.arrayRemove([currentUid]),
          "totalDisLike": totalDisLike - 1
        });
      } else {
        postSnapshot.doc(postEntity.postId).update({
          "disLikes": FieldValue.arrayUnion([currentUid]),
          "totalDisLike": totalDisLike + 1
        });
      }
    }
  }

// Get the stream of posts and display on the screen
  @override
  Stream<List<PostEntity>> fetchAndDisplayPosts(PostEntity post) {
    final postSnapshot = firestore.collection("posts").orderBy(
          "timeCreatedAt",
          descending: true,
        );
    return postSnapshot.snapshots().map((querySnap) =>
        querySnap.docs.map((snap) => PostModel.fromSnapshot(snap)).toList());
  }

// Get the stream of the currently logged in user(to display on profile)
  @override
  Stream<List<PostEntity>> readCurrentUserPost(String postId) {
    final postSnapshot = firestore
        .collection("posts")
        .orderBy(
          "createAt",
          descending: true,
        )
        .where("postId", isEqualTo: postId);
    return postSnapshot.snapshots().map((querySnap) =>
        querySnap.docs.map((snap) => PostModel.fromSnapshot(snap)).toList());
  }
}
