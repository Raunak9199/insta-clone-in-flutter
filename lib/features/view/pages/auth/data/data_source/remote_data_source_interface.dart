import 'dart:io';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';

abstract class FirebRemoteDataSourceInterface {
  Future<void> signInUser(UserEntity user);
  Future<void> registerUserToFirebase(UserEntity user);
  Future<bool> isSignedIn();
  Future<void> logoutUserFromFirebase();

  Stream<List<UserEntity>> fetchTotalUsersFromFirebase(UserEntity user);
  Stream<List<UserEntity>> fetchLoggedInUserData(String uid);
  Future<String> fetchLoggedInUserUid();
  Future<String> storeImage(File? file, String name);
  Future<String> storePost(File? file, String name, String randId);
  Future<void> implementLoggedInUserData(UserEntity user);
  Future<void> refreshUserData(UserEntity user, PostEntity post);
  Future<void> updateUserProfImg(UserEntity user);
  Stream<List<UserEntity>> fetchEveryOtherUser(String otherUid);

  Future<void> followUser(UserEntity user);
}
