import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    String? uid,
    String? userName,
    String? name,
    String? about,
    String? email,
    String? profileUrl,
    List? connections,
    List? friends,
    num? totalConnections,
    num? totalFriends,
    num? totalPosts,
    File? file,
  }) : super(
          uid: uid,
          about: about,
          connections: connections,
          email: email,
          friends: friends,
          name: name,
          profileUrl: profileUrl,
          totalConnections: totalConnections,
          totalPosts: totalPosts,
          totalFriends: totalFriends,
          userName: userName,
          imgFile: file,
        );

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      uid: snapshot.get('uid'),
      email: snapshot.get('email'),
      name: snapshot.get('name'),
      profileUrl: snapshot.get('profileUrl'),
      about: snapshot.get('about'),
      connections: List.from(snapshot.get('connections')),
      friends: List.from(snapshot.get('friends')),
      totalConnections: snapshot.get('totalConnections'),
      totalFriends: snapshot.get('totalFriends'),
      userName: snapshot.get('userName'),
      totalPosts: snapshot.get('totalPosts'),
      file: snapshot.get('file'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profileUrl': profileUrl,
      'about': about,
      'connections': connections,
      'friends': friends,
      'totalConnections': totalConnections,
      'totalFriends': totalFriends,
      'userName': userName,
      'totalPosts': totalPosts,
      'file': imgFile,
    };
  }
}
