import 'dart:io';

import 'package:socio_chat/features/view/pages/auth/data/data_source/remote_data_source_interface.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/repository/firebase_repository_interface.dart';

class FirebaseRepositoryImplementation implements FirebaseRepositoryInterface {
  final FirebRemoteDataSourceInterface remoteDataSource;

  FirebaseRepositoryImplementation({required this.remoteDataSource});

  @override
  Stream<List<UserEntity>> fetchTotalUsersFromFirebase(UserEntity user) =>
      remoteDataSource.fetchTotalUsersFromFirebase(user);
// Create signedin user
  @override
  Future<void> implementLoggedInUserData(UserEntity user) async =>
      remoteDataSource.implementLoggedInUserData(user);

  @override
  Future<String> fetchLoggedInUserUid() async =>
      remoteDataSource.fetchLoggedInUserUid();

  @override
  Stream<List<UserEntity>> fetchLoggedInUserData(String uid) =>
      remoteDataSource.fetchLoggedInUserData(uid);

  @override
  Future<bool> isSignedIn() async => remoteDataSource.isSignedIn();

  @override
  Future<void> signInUser(UserEntity user) async =>
      remoteDataSource.signInUser(user);

  @override
  Future<void> logoutUserFromFirebase() async =>
      remoteDataSource.logoutUserFromFirebase();

  @override
  Future<void> registerUserToFirebase(UserEntity user) async =>
      remoteDataSource.registerUserToFirebase(user);

  @override
  Future<void> refreshUserData(UserEntity user, PostEntity post) async =>
      remoteDataSource.refreshUserData(user, post);
  @override
  Future<void> updateUserProfImg(UserEntity user) async =>
      remoteDataSource.updateUserProfImg(user);

  @override
  Future<String> storeImage(File? file, String name) async =>
      remoteDataSource.storeImage(file, name);
  @override
  Future<String> storePost(File? file, String name, String randId) async =>
      remoteDataSource.storePost(file, name, randId);

  @override
  Stream<List<UserEntity>> fetchEveryOtherUser(String otherUid) =>
      remoteDataSource.fetchEveryOtherUser(otherUid);

  @override
  Future<void> followUser(UserEntity user) async =>
      remoteDataSource.followUser(user);
}
